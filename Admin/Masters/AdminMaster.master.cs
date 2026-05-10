using System;
using System.Web.UI;

namespace TansOrganicHarvest.Admin.Masters
{
    public partial class AdminMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if not authenticated
            if (!AdminAuth.IsLoggedIn())
            {
                Response.Redirect("~/Admin/AdminLogin.aspx");
                return;
            }

            // Populate top bar with admin name
            string fullName = AdminAuth.GetFullName();
            litAdminName.Text = fullName;
            litAdminInitial.Text = fullName.Length > 0
                ? fullName[0].ToString().ToUpper()
                : "A";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            AdminAuth.Logout();
            Response.Redirect("~/Admin/AdminLogin.aspx");
        }
    }
}