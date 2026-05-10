using System;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;

namespace TansOrganicHarvest.Account
{
    public partial class Logout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            HttpContext.Current.GetOwinContext().Authentication
                .SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            Session.Clear();
            Session.Abandon();
            Response.Redirect("/Default.aspx");
        }
    }
}