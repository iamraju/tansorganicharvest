using System;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class ProduceBoxForm : Page
    {
        private bool IsEditMode
        {
            get
            {
                int id;
                return int.TryParse(Request.QueryString["id"], out id) && id > 0;
            }
        }

        private int BoxId
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
            {
                if (IsEditMode)
                    LoadBoxForEdit();
                else
                    SetAddMode();
            }
        }

        private void SetAddMode()
        {
            litPageTitle.Text = "Add Produce Box";
            litPageSubtitle.Text = "Fill in the details to create a new produce box.";
            hfBoxId.Value = "0";
        }

        private void LoadBoxForEdit()
        {
            var dt = DatabaseHelper.ExecuteQuery(
                "SELECT * FROM ProduceBoxes WHERE BoxId = @id",
                new[] { new SqlParameter("@id", BoxId) });

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("ProduceBoxes.aspx");
                return;
            }

            var row = dt.Rows[0];

            litPageTitle.Text = "Edit Produce Box";
            litPageSubtitle.Text = "Update the produce box details below.";
            hfBoxId.Value = BoxId.ToString();

            txtName.Text = row["Name"].ToString();
            txtDescription.Text = row["Description"].ToString();
            txtPrice.Text = ((decimal)row["Price"]).ToString("F2");
            txtContents.Text = row["Contents"] != DBNull.Value
                                    ? row["Contents"].ToString() : "";
            chkIsActive.Checked = (bool)row["IsActive"];

            string existingImg = row["ImageUrl"] != DBNull.Value
                                    ? row["ImageUrl"].ToString() : "";
            hfExistingImage.Value = existingImg;

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

                int boxId = int.Parse(hfBoxId.Value);
                string admin = AdminAuth.GetUsername();
                decimal price = decimal.Parse(txtPrice.Text.Trim());

                if (boxId == 0)
                {
                    DatabaseHelper.ExecuteNonQuery(
                        @"INSERT INTO ProduceBoxes
                            (Name, Description, Price, Contents,
                             ImageUrl, IsActive, CreatedBy)
                          VALUES
                            (@name, @desc, @price, @contents,
                             @img, @active, @by)",
                        new[]
                        {
                            new SqlParameter("@name",     txtName.Text.Trim()),
                            new SqlParameter("@desc",     txtDescription.Text.Trim()),
                            new SqlParameter("@price",    price),
                            new SqlParameter("@contents", txtContents.Text.Trim()),
                            new SqlParameter("@img",      imageUrl ?? ""),
                            new SqlParameter("@active",   chkIsActive.Checked),
                            new SqlParameter("@by",       admin)
                        });

                    Response.Redirect("ProduceBoxes.aspx?msg=added");
                }
                else
                {
                    DatabaseHelper.ExecuteNonQuery(
                        @"UPDATE ProduceBoxes SET
                            Name        = @name,
                            Description = @desc,
                            Price       = @price,
                            Contents    = @contents,
                            ImageUrl    = @img,
                            IsActive    = @active,
                            UpdatedAt   = GETDATE(),
                            UpdatedBy   = @by
                          WHERE BoxId = @id",
                        new[]
                        {
                            new SqlParameter("@name",     txtName.Text.Trim()),
                            new SqlParameter("@desc",     txtDescription.Text.Trim()),
                            new SqlParameter("@price",    price),
                            new SqlParameter("@contents", txtContents.Text.Trim()),
                            new SqlParameter("@img",      imageUrl ?? ""),
                            new SqlParameter("@active",   chkIsActive.Checked),
                            new SqlParameter("@by",       admin),
                            new SqlParameter("@id",       boxId)
                        });

                    Response.Redirect("ProduceBoxes.aspx?msg=updated");
                }
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Error saving produce box: " + ex.Message;
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

            string folderPath = Server.MapPath("~/Images/boxes/");
            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            string fileName = Guid.NewGuid().ToString("N") + ext;
            fuImage.SaveAs(Path.Combine(folderPath, fileName));
            return "Images/boxes/" + fileName;
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