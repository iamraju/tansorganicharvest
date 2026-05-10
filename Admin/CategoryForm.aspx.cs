using System;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class CategoryForm : Page
    {
        // Is this an edit (has ?id= param) or a new add?
        private bool IsEditMode => int.TryParse(
            Request.QueryString["id"], out int id) && id > 0;

        private int CategoryId => IsEditMode
            ? int.Parse(Request.QueryString["id"])
            : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (IsEditMode)
                    LoadCategoryForEdit();
                else
                    SetAddMode();
            }
        }

        private void SetAddMode()
        {
            litPageTitle.Text = "Add Category";
            litPageSubtitle.Text = "Fill in the details to create a new category.";
            hfCategoryId.Value = "0";
        }

        private void LoadCategoryForEdit()
        {
            var dt = DatabaseHelper.ExecuteQuery(
                "SELECT * FROM Categories WHERE CategoryId = @id",
                new[] { new SqlParameter("@id", CategoryId) });

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("Categories.aspx");
                return;
            }

            var row = dt.Rows[0];

            litPageTitle.Text = "Edit Category";
            litPageSubtitle.Text = "Update the details below.";
            hfCategoryId.Value = CategoryId.ToString();

            txtName.Text = row["Name"].ToString();
            txtDescription.Text = row["Description"].ToString();
            txtSortOrder.Text = row["SortOrder"].ToString();
            chkIsActive.Checked = (bool)row["IsActive"];

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
                string imageUrl = hfExistingImage.Value; // keep existing by default

                // Handle image upload if a new file was selected
                if (fuImage.HasFile)
                {
                    string uploadedPath = UploadImage();
                    if (uploadedPath == null) return; // upload failed, error shown

                    // Delete old image from disk if replacing
                    if (!string.IsNullOrEmpty(hfExistingImage.Value))
                        DeleteImageFile(hfExistingImage.Value);

                    imageUrl = uploadedPath;
                }

                int categoryId = int.Parse(hfCategoryId.Value);
                string admin = AdminAuth.GetUsername();

                if (categoryId == 0)
                {
                    // INSERT
                    DatabaseHelper.ExecuteNonQuery(
                        @"INSERT INTO Categories 
                            (Name, Description, ImageUrl, SortOrder, IsActive, CreatedBy)
                          VALUES 
                            (@name, @desc, @img, @sort, @active, @by)",
                        new[]
                        {
                            new SqlParameter("@name",   txtName.Text.Trim()),
                            new SqlParameter("@desc",   txtDescription.Text.Trim()),
                            new SqlParameter("@img",    imageUrl ?? ""),
                            new SqlParameter("@sort",   int.Parse(txtSortOrder.Text.Trim())),
                            new SqlParameter("@active", chkIsActive.Checked),
                            new SqlParameter("@by",     admin)
                        });

                    Response.Redirect("Categories.aspx?msg=added");
                }
                else
                {
                    // UPDATE
                    DatabaseHelper.ExecuteNonQuery(
                        @"UPDATE Categories SET
                            Name        = @name,
                            Description = @desc,
                            ImageUrl    = @img,
                            SortOrder   = @sort,
                            IsActive    = @active,
                            UpdatedAt   = GETDATE(),
                            UpdatedBy   = @by
                          WHERE CategoryId = @id",
                        new[]
                        {
                            new SqlParameter("@name",   txtName.Text.Trim()),
                            new SqlParameter("@desc",   txtDescription.Text.Trim()),
                            new SqlParameter("@img",    imageUrl ?? ""),
                            new SqlParameter("@sort",   int.Parse(txtSortOrder.Text.Trim())),
                            new SqlParameter("@active", chkIsActive.Checked),
                            new SqlParameter("@by",     admin),
                            new SqlParameter("@id",     categoryId)
                        });

                    Response.Redirect("Categories.aspx?msg=updated");
                }
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Error saving category: " + ex.Message;
            }
        }

        private string UploadImage()
        {
            // Validate file type
            string[] allowed = { ".jpg", ".jpeg", ".png", ".webp" };
            string ext = Path.GetExtension(fuImage.FileName).ToLower();

            if (Array.IndexOf(allowed, ext) < 0)
            {
                pnlError.Visible = true;
                litError.Text = "Invalid file type. Only JPG, PNG, and WEBP allowed.";
                return null;
            }

            // Validate file size (2MB)
            if (fuImage.PostedFile.ContentLength > 10 * 1024 * 1024)
            {
                pnlError.Visible = true;
                litError.Text = "Image must be less than 10MB.";
                return null;
            }

            // Generate unique filename to avoid collisions
            string fileName = Guid.NewGuid().ToString("N") + ext;
            string folderPath = Server.MapPath("~/Images/categories/");
            string fullPath = Path.Combine(folderPath, fileName);

            // Ensure folder exists
            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            fuImage.SaveAs(fullPath);

            // Return relative path stored in DB
            return "Images/categories/" + fileName;
        }

        private void DeleteImageFile(string relativePath)
        {
            if (string.IsNullOrEmpty(relativePath)) return;
            try
            {
                string fullPath = Server.MapPath("~/" + relativePath);
                if (File.Exists(fullPath))
                    File.Delete(fullPath);
            }
            catch { /* silently ignore */ }
        }
    }
}