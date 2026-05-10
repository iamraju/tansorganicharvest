using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest.Admin
{
    public partial class Categories : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Show toast messages passed via query string after redirect
                string msg = Request.QueryString["msg"];
                if (msg == "added") ShowSuccess("Category added successfully.");
                if (msg == "updated") ShowSuccess("Category updated successfully.");
                if (msg == "deleted") ShowSuccess("Category deleted successfully.");

                LoadCategories();
            }
        }

        private void LoadCategories()
        {
            var dt = DatabaseHelper.ExecuteQuery(
                @"SELECT CategoryId, Name, Description, ImageUrl, 
                         SortOrder, IsActive, CreatedAt
                  FROM Categories 
                  ORDER BY SortOrder, Name");

            gvCategories.DataSource = dt;
            gvCategories.DataBind();
        }

        // Helper used in markup: returns placeholder if no image
        protected string GetImageUrl(object imageUrl)
        {
            string url = imageUrl?.ToString();
            return string.IsNullOrEmpty(url)
                ? "/Images/placeholder.png"
                : "/" + url;
        }

        protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "DeleteRow") return;

            int id = int.Parse(e.CommandArgument.ToString());

            // Check if products are using this category
            object count = DatabaseHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Products WHERE CategoryId = @id",
                new[] { new SqlParameter("@id", id) });

            if (count != null && (int)count > 0)
            {
                ShowError($"Cannot delete — {count} product(s) are assigned to this category. " +
                           "Reassign or delete those products first.");
                return;
            }

            // Delete image file from disk if exists
            var dt = DatabaseHelper.ExecuteQuery(
                "SELECT ImageUrl FROM Categories WHERE CategoryId = @id",
                new[] { new SqlParameter("@id", id) });

            if (dt.Rows.Count > 0)
            {
                string imgUrl = dt.Rows[0]["ImageUrl"]?.ToString();
                DeleteImageFile(imgUrl);
            }

            DatabaseHelper.ExecuteNonQuery(
                "DELETE FROM Categories WHERE CategoryId = @id",
                new[] { new SqlParameter("@id", id) });

            Response.Redirect("Categories.aspx?msg=deleted");
        }

        private void DeleteImageFile(string relativePath)
        {
            if (string.IsNullOrEmpty(relativePath)) return;
            try
            {
                string fullPath = Server.MapPath("~/" + relativePath);
                if (System.IO.File.Exists(fullPath))
                    System.IO.File.Delete(fullPath);
            }
            catch { /* silently ignore file deletion errors */ }
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