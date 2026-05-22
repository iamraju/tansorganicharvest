using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class Profile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadProfile();
        }

        private void LoadProfile()
        {
            string username = AdminAuth.GetUsername();
            DataTable dt = DatabaseHelper.ExecuteQuery(
                "SELECT * FROM AdminUsers WHERE Username = @u",
                new[] { new SqlParameter("@u", username) });

            if (dt.Rows.Count == 0) return;
            DataRow row = dt.Rows[0];

            string fullName = row["FullName"].ToString();
            hfAdminId.Value = row["AdminId"].ToString();
            litInitial.Text = fullName.Length > 0
                ? fullName[0].ToString().ToUpper() : "A";
            litFullName.Text = fullName;
            litUsername.Text = row["Username"].ToString();
            litLastLogin.Text = row["LastLoginAt"] != DBNull.Value
                ? ((DateTime)row["LastLoginAt"]).ToString("dd MMM yyyy, h:mm tt")
                : "Never";

            txtFullName.Text = fullName;
            txtEmail.Text = row["Email"].ToString();
            txtUsernameDisplay.Text = row["Username"].ToString();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                DatabaseHelper.ExecuteNonQuery(
                    @"UPDATE AdminUsers SET
                        FullName  = @name,
                        Email     = @email,
                        UpdatedAt = GETDATE(),
                        UpdatedBy = @by
                      WHERE AdminId = @id",
                    new[]
                    {
                        new SqlParameter("@name",  txtFullName.Text.Trim()),
                        new SqlParameter("@email", txtEmail.Text.Trim()),
                        new SqlParameter("@by",    AdminAuth.GetUsername()),
                        new SqlParameter("@id",    int.Parse(hfAdminId.Value))
                    });

                // Update session name
                AdminAuth.SetAdminSession(
                    AdminAuth.GetUsername(), txtFullName.Text.Trim());

                pnlSuccess.Visible = true;
                litSuccess.Text = "Profile updated successfully.";
                LoadProfile();
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Error: " + ex.Message;
            }
        }
    }
}