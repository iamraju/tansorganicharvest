using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class ChangePassword : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnChange_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                string username = AdminAuth.GetUsername();

                // Verify current password
                object check = DatabaseHelper.ExecuteScalar(
                    @"SELECT COUNT(1) FROM AdminUsers
                      WHERE Username = @u AND PasswordHash = @p",
                    new[]
                    {
                        new SqlParameter("@u", username),
                        new SqlParameter("@p", txtCurrent.Text)
                    });

                if (check == null || (int)check == 0)
                {
                    pnlError.Visible = true;
                    litError.Text = "Current password is incorrect.";
                    return;
                }

                // Update password
                DatabaseHelper.ExecuteNonQuery(
                    @"UPDATE AdminUsers SET
                        PasswordHash = @newPwd,
                        UpdatedAt    = GETDATE(),
                        UpdatedBy    = @by
                      WHERE Username = @u",
                    new[]
                    {
                        new SqlParameter("@newPwd", txtNew.Text),
                        new SqlParameter("@by",     username),
                        new SqlParameter("@u",      username)
                    });

                pnlSuccess.Visible = true;
                pnlError.Visible = false;
                txtCurrent.Text = "";
                txtNew.Text = "";
                txtConfirm.Text = "";
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Error: " + ex.Message;
            }
        }
    }
}