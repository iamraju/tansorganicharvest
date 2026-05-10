using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest.Admin
{
    public partial class ProduceBoxes : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string msg = Request.QueryString["msg"];
                if (msg == "added") ShowSuccess("Produce box added successfully.");
                if (msg == "updated") ShowSuccess("Produce box updated successfully.");
                if (msg == "deleted") ShowSuccess("Produce box deleted successfully.");

                LoadBoxes();
            }
        }

        private void LoadBoxes()
        {
            var dt = DatabaseHelper.ExecuteQuery(
                @"SELECT BoxId, Name, Description, Price, 
                         ImageUrl, IsActive, CreatedAt
                  FROM ProduceBoxes
                  ORDER BY CreatedAt DESC");

            gvBoxes.DataSource = dt;
            gvBoxes.DataBind();
        }

        protected void gvBoxes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "DeleteRow") return;

            int id = int.Parse(e.CommandArgument.ToString());

            // Delete image from disk
            var dt = DatabaseHelper.ExecuteQuery(
                "SELECT ImageUrl FROM ProduceBoxes WHERE BoxId = @id",
                new[] { new SqlParameter("@id", id) });

            if (dt.Rows.Count > 0)
                DeleteImageFile(dt.Rows[0]["ImageUrl"]?.ToString());

            DatabaseHelper.ExecuteNonQuery(
                "DELETE FROM ProduceBoxes WHERE BoxId = @id",
                new[] { new SqlParameter("@id", id) });

            Response.Redirect("ProduceBoxes.aspx?msg=deleted");
        }

        private void DeleteImageFile(string relativePath)
        {
            if (string.IsNullOrEmpty(relativePath)) return;
            try
            {
                string full = Server.MapPath("~/" + relativePath);
                if (System.IO.File.Exists(full))
                    System.IO.File.Delete(full);
            }
            catch { }
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