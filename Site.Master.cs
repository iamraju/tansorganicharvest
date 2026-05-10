using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace TansOrganicHarvest
{
    public partial class Site : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
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
    }
}