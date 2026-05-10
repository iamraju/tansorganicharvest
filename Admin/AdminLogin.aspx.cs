using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class AdminLogin : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //lblDebug.Text = "Code-behind: TansOrganicHarvest.Admin.AdminLogin | " + DateTime.Now;

            if (!IsPostBack && AdminAuth.IsLoggedIn())
                Response.Redirect("~/Admin/Dashboard.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            try
            {
                bool isValid = AdminAuth.ValidateLogin(username, password);

                if (isValid)
                {
                    string sql = @"SELECT FullName FROM AdminUsers 
                                   WHERE Username = @u AND IsActive = 1";

                    var dt = DatabaseHelper.ExecuteQuery(sql, new[]
                    {
                        new SqlParameter("@u", username)
                    });

                    string fullName = dt.Rows.Count > 0
                        ? dt.Rows[0]["FullName"].ToString()
                        : username;

                    AdminAuth.SetAdminSession(username, fullName);
                    Response.Redirect("~/Admin/Dashboard.aspx");
                }
                else
                {
                    pnlError.Visible = true;
                    litError.Text = "Invalid username or password.";
                }
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Error: " + ex.Message;
            }
        }
    }
}