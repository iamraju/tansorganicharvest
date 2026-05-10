using System;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest.Admin
{
    public partial class ProductForm : Page
    {
        private bool IsEditMode => int.TryParse(
            Request.QueryString["id"], out int id) && id > 0;

        private int ProductId => IsEditMode
            ? int.Parse(Request.QueryString["id"]) : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                if (IsEditMode)
                    LoadProductForEdit();
                else
                    SetAddMode();
            }
        }

        private void LoadCategories()
        {
            var dt = DatabaseHelper.ExecuteQuery(
                "SELECT CategoryId, Name FROM Categories " +
                "WHERE IsActive = 1 ORDER BY SortOrder, Name");

            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new ListItem("-- Select Category --", ""));
            foreach (System.Data.DataRow row in dt.Rows)
                ddlCategory.Items.Add(
                    new ListItem(row["Name"].ToString(),
                                 row["CategoryId"].ToString()));
        }

        private void SetAddMode()
        {
            litPageTitle.Text = "Add Product";
            litPageSubtitle.Text = "Fill in the details to add a new product.";
            hfProductId.Value = "0";
        }

        private void LoadProductForEdit()
        {
            var dt = DatabaseHelper.ExecuteQuery(
                "SELECT * FROM Products WHERE ProductId = @id",
                new[] { new SqlParameter("@id", ProductId) });

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("Products.aspx");
                return;
            }

            var row = dt.Rows[0];

            litPageTitle.Text = "Edit Product";
            litPageSubtitle.Text = "Update the product details below.";
            hfProductId.Value = ProductId.ToString();

            txtName.Text = row["Name"].ToString();
            txtDescription.Text = row["Description"].ToString();
            txtPrice.Text = ((decimal)row["Price"]).ToString("F2");
            txtUnit.Text = row["Unit"].ToString();
            txtStock.Text = row["Stock"].ToString();
            chkIsActive.Checked = (bool)row["IsActive"];
            chkIsFeatured.Checked = (bool)row["IsFeatured"];

            // Set category dropdown
            string catId = row["CategoryId"].ToString();
            var item = ddlCategory.Items.FindByValue(catId);
            if (item != null) item.Selected = true;

            // Show existing image
            string existingImg = row["ImageUrl"]?.ToString();
            hfExistingImage.Value = existingImg ?? "";
            if (!string.IsNullOrEmpty(existingImg))
            {
                imgPreview.ImageUrl = "/" + existingImg;
                pnlCurrentImage.Visible = true;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                string imageUrl = hfExistingImage.Value;

                if (fuImage.HasFile)
                {
                    string uploaded = UploadImage();
                    if (uploaded == null) return;

                    if (!string.IsNullOrEmpty(hfExistingImage.Value))
                        DeleteImageFile(hfExistingImage.Value);

                    imageUrl = uploaded;
                }

                int productId = int.Parse(hfProductId.Value);
                string admin = AdminAuth.GetUsername();
                decimal price = decimal.Parse(txtPrice.Text.Trim());
                int stock = int.Parse(txtStock.Text.Trim());
                int catId = int.Parse(ddlCategory.SelectedValue);

                if (productId == 0)
                {
                    DatabaseHelper.ExecuteNonQuery(
                        @"INSERT INTO Products
                            (CategoryId, Name, Description, Price, Unit, Stock,
                             ImageUrl, IsFeatured, IsActive, CreatedBy)
                          VALUES
                            (@catId, @name, @desc, @price, @unit, @stock,
                             @img, @featured, @active, @by)",
                        new[]
                        {
                            new SqlParameter("@catId",    catId),
                            new SqlParameter("@name",     txtName.Text.Trim()),
                            new SqlParameter("@desc",     txtDescription.Text.Trim()),
                            new SqlParameter("@price",    price),
                            new SqlParameter("@unit",     txtUnit.Text.Trim()),
                            new SqlParameter("@stock",    stock),
                            new SqlParameter("@img",      imageUrl ?? ""),
                            new SqlParameter("@featured", chkIsFeatured.Checked),
                            new SqlParameter("@active",   chkIsActive.Checked),
                            new SqlParameter("@by",       admin)
                        });

                    Response.Redirect("Products.aspx?msg=added");
                }
                else
                {
                    DatabaseHelper.ExecuteNonQuery(
                        @"UPDATE Products SET
                            CategoryId  = @catId,
                            Name        = @name,
                            Description = @desc,
                            Price       = @price,
                            Unit        = @unit,
                            Stock       = @stock,
                            ImageUrl    = @img,
                            IsFeatured  = @featured,
                            IsActive    = @active,
                            UpdatedAt   = GETDATE(),
                            UpdatedBy   = @by
                          WHERE ProductId = @id",
                        new[]
                        {
                            new SqlParameter("@catId",    catId),
                            new SqlParameter("@name",     txtName.Text.Trim()),
                            new SqlParameter("@desc",     txtDescription.Text.Trim()),
                            new SqlParameter("@price",    price),
                            new SqlParameter("@unit",     txtUnit.Text.Trim()),
                            new SqlParameter("@stock",    stock),
                            new SqlParameter("@img",      imageUrl ?? ""),
                            new SqlParameter("@featured", chkIsFeatured.Checked),
                            new SqlParameter("@active",   chkIsActive.Checked),
                            new SqlParameter("@by",       admin),
                            new SqlParameter("@id",       productId)
                        });

                    Response.Redirect("Products.aspx?msg=updated");
                }
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Error saving product: " + ex.Message;
            }
        }

        private string UploadImage()
        {
            string[] allowed = { ".jpg", ".jpeg", ".png", ".webp" };
            string ext = Path.GetExtension(fuImage.FileName).ToLower();

            if (Array.IndexOf(allowed, ext) < 0)
            {
                ShowError("Invalid file type. Only JPG, PNG and WEBP allowed.");
                return null;
            }
            if (fuImage.PostedFile.ContentLength > 10 * 1024 * 1024)
            {
                ShowError("Image must be less than 10MB.");
                return null;
            }

            string folderPath = Server.MapPath("~/Images/products/");
            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            string fileName = Guid.NewGuid().ToString("N") + ext;
            fuImage.SaveAs(Path.Combine(folderPath, fileName));

            return "Images/products/" + fileName;
        }

        private void DeleteImageFile(string relativePath)
        {
            if (string.IsNullOrEmpty(relativePath)) return;
            try
            {
                string full = Server.MapPath("~/" + relativePath);
                if (File.Exists(full)) File.Delete(full);
            }
            catch { }
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litError.Text = msg;
        }
    }
}