using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest.Members
{
    public partial class Cart : Page
    {
        private const decimal DELIVERY_FEE = 5.00m;
        private const decimal FREE_DELIVERY_MIN = 50.00m;

        private string UserId
        {
            get
            {
                object id = DatabaseHelper.ExecuteScalar(
                    "SELECT Id FROM AspNetUsers WHERE UserName = @u",
                    new[] { new SqlParameter("@u", User.Identity.Name) });
                return id?.ToString() ?? "";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadCart();
        }

        private void LoadCart()
        {
            string userId = UserId;
            if (string.IsNullOrEmpty(userId)) return;

            DataTable dt = DatabaseHelper.ExecuteQuery(
                @"SELECT c.CartId, c.Quantity,
                         p.ProductId, p.Name, p.Price, p.Unit,
                         p.ImageUrl, p.Stock,
                         cat.Name AS CategoryName,
                         CAST(c.Quantity * p.Price AS DECIMAL(10,2)) AS LineTotal
                  FROM Cart c
                  INNER JOIN Products p   ON c.ProductId   = p.ProductId
                  INNER JOIN Categories cat ON p.CategoryId = cat.CategoryId
                  WHERE c.UserId = @uid
                  ORDER BY c.CreatedAt DESC",
                new[] { new SqlParameter("@uid", userId) });

            if (dt.Rows.Count == 0)
            {
                pnlEmpty.Visible = true;
                pnlCart.Visible = false;
                return;
            }

            pnlCart.Visible = true;
            pnlEmpty.Visible = false;

            rptCart.DataSource = dt;
            rptCart.DataBind();

            // Calculate totals
            decimal subtotal = 0;
            int totalQty = 0;
            foreach (DataRow row in dt.Rows)
            {
                subtotal += (decimal)row["LineTotal"];
                totalQty += (int)row["Quantity"];
            }

            decimal delivery = subtotal >= FREE_DELIVERY_MIN ? 0 : DELIVERY_FEE;
            decimal total = subtotal + delivery;

            litItemCount.Text = totalQty.ToString();
            litSummaryCount.Text = totalQty.ToString();
            litSubtotal.Text = subtotal.ToString("F2");
            litTotal.Text = total.ToString("F2");

            if (delivery == 0)
            {
                litDeliveryFee.Text = "<span class='text-green-600 font-semibold'>FREE</span>";
                pnlFreeDelivery.Visible = true;
                pnlDeliveryProgress.Visible = false;
            }
            else
            {
                litDeliveryFee.Text = "$" + delivery.ToString("F2");
                decimal remaining = FREE_DELIVERY_MIN - subtotal;
                litDeliveryProgress.Text = $"Add ${remaining:F2} more for free delivery!";
                pnlDeliveryProgress.Visible = true;
                pnlFreeDelivery.Visible = false;
            }
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int cartId = int.Parse(e.CommandArgument.ToString());

            switch (e.CommandName)
            {
                case "Remove":
                    DatabaseHelper.ExecuteNonQuery(
                        "DELETE FROM Cart WHERE CartId = @id",
                        new[] { new SqlParameter("@id", cartId) });
                    ShowSuccess("Item removed from cart.");
                    break;

                case "Increase":
                    // Check stock before increasing
                    object stock = DatabaseHelper.ExecuteScalar(
                        @"SELECT p.Stock FROM Cart c
                          INNER JOIN Products p ON c.ProductId = p.ProductId
                          WHERE c.CartId = @id",
                        new[] { new SqlParameter("@id", cartId) });

                    object currentQty = DatabaseHelper.ExecuteScalar(
                        "SELECT Quantity FROM Cart WHERE CartId = @id",
                        new[] { new SqlParameter("@id", cartId) });

                    int stockVal = stock != null ? (int)stock : 0;
                    int currQty = currentQty != null ? (int)currentQty : 1;

                    if (currQty >= stockVal)
                    {
                        ShowError("Maximum available stock reached.");
                        break;
                    }
                    DatabaseHelper.ExecuteNonQuery(
                        @"UPDATE Cart SET Quantity  = Quantity + 1,
                                         UpdatedAt  = GETDATE()
                          WHERE CartId = @id",
                        new[] { new SqlParameter("@id", cartId) });
                    break;

                case "Decrease":
                    object qty = DatabaseHelper.ExecuteScalar(
                        "SELECT Quantity FROM Cart WHERE CartId = @id",
                        new[] { new SqlParameter("@id", cartId) });

                    if (qty != null && (int)qty <= 1)
                    {
                        // Remove if qty would go to 0
                        DatabaseHelper.ExecuteNonQuery(
                            "DELETE FROM Cart WHERE CartId = @id",
                            new[] { new SqlParameter("@id", cartId) });
                        ShowSuccess("Item removed from cart.");
                    }
                    else
                    {
                        DatabaseHelper.ExecuteNonQuery(
                            @"UPDATE Cart SET Quantity  = Quantity - 1,
                                             UpdatedAt  = GETDATE()
                              WHERE CartId = @id",
                            new[] { new SqlParameter("@id", cartId) });
                    }
                    break;
            }

            LoadCart();
        }

        protected void btnClearCart_Click(object sender, EventArgs e)
        {
            DatabaseHelper.ExecuteNonQuery(
                "DELETE FROM Cart WHERE UserId = @uid",
                new[] { new SqlParameter("@uid", UserId) });
            ShowSuccess("Cart cleared.");
            LoadCart();
        }

        private void ShowSuccess(string msg)
        {
            pnlSuccess.Visible = true;
            litSuccess.Text = msg;
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litError.Text = msg;
        }
    }
}