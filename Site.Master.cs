using Microsoft.AspNet.Identity;
using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest
{
    public partial class Site : MasterPage
    {
        // Add a public property that can be accessed from the .aspx
        public string CustomerFullName { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
                // Find the control and set text directly
                LoginView loginView = FindControl("LoginView1") as LoginView;
                if (loginView != null)
                {
                    Literal litCustomerName = loginView.FindControl("litCustomerName") as Literal;
                    if (litCustomerName != null)
                    {
                        // Load and set the name directly
                        string fullName = GetCustomerFullName();
                        litCustomerName.Text = fullName;
                    }
                }

                try
                {
                    string username = HttpContext.Current.User.Identity.Name;

                    object count = DatabaseHelper.ExecuteScalar(
                        @"SELECT ISNULL(SUM(c.Quantity), 0)
                          FROM Cart c
                          INNER JOIN AspNetUsers u ON c.UserId = u.Id
                          WHERE u.UserName = @username",
                        new[] { new SqlParameter("@username", username) });

                    int cartCount = count != null ? Convert.ToInt32(count) : 0;
                    if (cartCount > 0)
                    {
                        pnlCartBadge.Visible = true;
                        litCartCount.Text = cartCount > 99 ? "99+" : cartCount.ToString();
                    }
                }
                catch { /* cart count is non-critical */ }
            }
        }

        private string GetCustomerFullName()
        {
            try
            {
                string userId = HttpContext.Current.User.Identity.GetUserId();
                string query = @"SELECT FullName FROM CustomerProfiles WHERE UserId = @UserId";
                object result = DatabaseHelper.ExecuteScalar(
                    query,
                    new[] { new SqlParameter("@UserId", userId) });

                return result != null ? result.ToString() : HttpContext.Current.User.Identity.Name;
            }
            catch
            {
                return HttpContext.Current.User.Identity.Name;
            }
        }

        private void LoadCustomerName()
        {
            try
            {
                string userId = HttpContext.Current.User.Identity.GetUserId();

                if (!string.IsNullOrEmpty(userId))
                {
                    // Query the CustomerProfiles table to get the full name
                    string query = @"SELECT FullName FROM CustomerProfiles WHERE UserId = @UserId";

                    object result = DatabaseHelper.ExecuteScalar(
                        query,
                        new[] { new SqlParameter("@UserId", userId) });

                    if (result != null && result != DBNull.Value)
                    {
                        CustomerFullName = result.ToString();
                    }
                    else
                    {
                        // Fallback to email if profile doesn't have name
                        CustomerFullName = HttpContext.Current.User.Identity.Name;
                    }
                }
                else
                {
                    CustomerFullName = HttpContext.Current.User.Identity.Name;
                }
            }
            catch (Exception ex)
            {
                // Log error and fallback to username
                System.Diagnostics.Debug.WriteLine("Error loading customer name: " + ex.Message);
                CustomerFullName = HttpContext.Current.User.Identity.Name;
            }
        }
    }
}