using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest
{
    public partial class ProductDetail : Page
    {
        private int ProductId
        {
            get
            {
                int id;
                return int.TryParse(Request.QueryString["id"], out id) ? id : 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadProduct();
        }

        private void LoadProduct()
        {
            if (ProductId == 0)
            {
                ShowNotFound();
                return;
            }

            DataTable dt = DatabaseHelper.ExecuteQuery(
                @"SELECT p.ProductId, p.Name, p.Description, p.Price,
                         p.Unit, p.Stock, p.ImageUrl, p.IsFeatured,
                         c.Name AS CategoryName, p.CategoryId
                  FROM Products p
                  INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                  WHERE p.ProductId = @id AND p.IsActive = 1",
                new[] { new SqlParameter("@id", ProductId) });

            if (dt.Rows.Count == 0)
            {
                ShowNotFound();
                return;
            }

            DataRow row = dt.Rows[0];

            Title = row["Name"].ToString() + " — Tan's Organic Harvest";

            litBreadcrumb.Text = row["Name"].ToString();
            litName.Text = row["Name"].ToString();
            litCategory.Text = row["CategoryName"].ToString();
            litDescription.Text = row["Description"].ToString();
            litPrice.Text = ((decimal)row["Price"]).ToString("F2");
            litUnit.Text = row["Unit"].ToString();

            // ── Image: build URL directly, no ViewHelpers ──
            string imgUrl = row["ImageUrl"] != null
                ? row["ImageUrl"].ToString() : "";
            imgProduct.ImageUrl = string.IsNullOrEmpty(imgUrl)
                ? "/Images/placeholder.png" : "/" + imgUrl;
            imgProduct.AlternateText = row["Name"].ToString();

            pnlFeaturedBadge.Visible = (bool)row["IsFeatured"];

            int stock = (int)row["Stock"];
            if (stock > 0)
            {
                pnlInStock.Visible = true;
                litStock.Text = stock.ToString();
            }
            else
            {
                pnlOutOfStock.Visible = true;
            }

            pnlProduct.Visible = true;

            LoadRelated((int)row["CategoryId"]);
        }

        private void LoadRelated(int categoryId)
        {
            DataTable dt = DatabaseHelper.ExecuteQuery(
                @"SELECT TOP 4 ProductId, Name, Price, ImageUrl
                  FROM Products
                  WHERE CategoryId = @catId
                    AND ProductId  != @pid
                    AND IsActive   = 1
                  ORDER BY NEWID()",
                new[]
                {
                    new SqlParameter("@catId", categoryId),
                    new SqlParameter("@pid",   ProductId)
                });

            if (dt.Rows.Count > 0)
            {
                pnlRelated.Visible = true;
                rptRelated.DataSource = dt;
                rptRelated.DataBind();
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("/Account/Login.aspx?ReturnUrl=" +
                    Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

            try
            {
                // ── Find txtQty inside the LoggedInTemplate ──
                // LoginView → find the named container → then the TextBox
                int qty = 1;
                TextBox txtQtyCtrl = FindControlRecursive(lvCart, "txtQty") as TextBox;
                if (txtQtyCtrl != null)
                    int.TryParse(txtQtyCtrl.Text, out qty);
                if (qty < 1) qty = 1;

                // Get userId
                string username = User.Identity.Name;
                object userIdObj = DatabaseHelper.ExecuteScalar(
                    "SELECT Id FROM AspNetUsers WHERE UserName = @u",
                    new[] { new SqlParameter("@u", username) });

                if (userIdObj == null)
                {
                    ShowCartError("Could not identify your account. Please sign in again.");
                    return;
                }
                string userId = userIdObj.ToString();

                // Check stock
                object stockObj = DatabaseHelper.ExecuteScalar(
                    "SELECT Stock FROM Products WHERE ProductId = @id",
                    new[] { new SqlParameter("@id", ProductId) });
                int stock = stockObj != null ? Convert.ToInt32(stockObj) : 0;

                if (stock <= 0)
                {
                    ShowCartError("Sorry, this product is currently out of stock.");
                    return;
                }

                if (qty > stock)
                    qty = stock;

                // Already in cart? Update quantity; otherwise insert
                object existingQty = DatabaseHelper.ExecuteScalar(
                    @"SELECT Quantity FROM Cart
                      WHERE UserId = @uid AND ProductId = @pid",
                    new[]
                    {
                        new SqlParameter("@uid", userId),
                        new SqlParameter("@pid", ProductId)
                    });

                if (existingQty != null)
                {
                    int newQty = Convert.ToInt32(existingQty) + qty;
                    if (newQty > stock) newQty = stock;

                    DatabaseHelper.ExecuteNonQuery(
                        @"UPDATE Cart SET Quantity  = @qty,
                                         UpdatedAt  = GETDATE(),
                                         UpdatedBy  = @by
                          WHERE UserId = @uid AND ProductId = @pid",
                        new[]
                        {
                            new SqlParameter("@qty", newQty),
                            new SqlParameter("@by",  username),
                            new SqlParameter("@uid", userId),
                            new SqlParameter("@pid", ProductId)
                        });
                }
                else
                {
                    DatabaseHelper.ExecuteNonQuery(
                        @"INSERT INTO Cart (UserId, ProductId, Quantity, CreatedBy)
                          VALUES (@uid, @pid, @qty, @by)",
                        new[]
                        {
                            new SqlParameter("@uid", userId),
                            new SqlParameter("@pid", ProductId),
                            new SqlParameter("@qty", qty),
                            new SqlParameter("@by",  username)
                        });
                }

                ShowCartSuccess(qty + " × " + litName.Text + " added to your cart!");
            }
            catch (Exception ex)
            {
                ShowCartError("Could not add to cart: " + ex.Message);
            }
        }

        // ── Recursive FindControl ────────────────────────────────
        // Standard FindControl only searches one level deep.
        // This searches the entire control tree inside a parent.
        private Control FindControlRecursive(Control parent, string id)
        {
            if (parent == null) return null;

            Control found = parent.FindControl(id);
            if (found != null) return found;

            foreach (Control child in parent.Controls)
            {
                found = FindControlRecursive(child, id);
                if (found != null) return found;
            }
            return null;
        }

        private void ShowNotFound()
        {
            pnlNotFound.Visible = true;
            pnlProduct.Visible = false;
        }

        private void ShowCartSuccess(string msg)
        {
            var pnl = FindControlRecursive(lvCart, "pnlCartSuccess") as Panel;
            var lit = FindControlRecursive(lvCart, "litCartMsg") as Literal;
            if (pnl != null) pnl.Visible = true;
            if (lit != null) lit.Text = msg;
        }

        private void ShowCartError(string msg)
        {
            var pnl = FindControlRecursive(lvCart, "pnlCartError") as Panel;
            var lit = FindControlRecursive(lvCart, "litCartError") as Literal;
            if (pnl != null) pnl.Visible = true;
            if (lit != null) lit.Text = msg;
        }
    }
}