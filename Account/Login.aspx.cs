using System;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using TansOrganicHarvest.Models;

namespace TansOrganicHarvest.Account
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && User.Identity.IsAuthenticated)
                Response.Redirect("~/Default.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim().ToLower();
            string password = txtPassword.Text;

            try
            {
                // Create UserManager directly
                var userStore = new UserStore<ApplicationUser>(
                    new ApplicationDbContext());
                var manager = new ApplicationUserManager(userStore);

                // Find user by email
                var user = manager.FindByEmail(email);
                if (user == null)
                {
                    ShowError("No account found with that email address.");
                    return;
                }

                // Check password
                bool validPassword = manager.CheckPassword(user, password);
                if (!validPassword)
                {
                    ShowError("Incorrect password. Please try again.");
                    return;
                }

                // Sign in
                var identity = manager.CreateIdentity(
                    user, DefaultAuthenticationTypes.ApplicationCookie);

                var authManager = HttpContext.Current.GetOwinContext().Authentication;
                authManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
                authManager.SignIn(
                    new AuthenticationProperties
                    {
                        IsPersistent = chkRemember.Checked
                    },
                    identity);

                // Redirect
                string returnUrl = Request.QueryString["ReturnUrl"];
                if (!string.IsNullOrEmpty(returnUrl) &&
                    returnUrl.StartsWith("/") &&
                    !returnUrl.StartsWith("//"))
                    Response.Redirect(returnUrl);
                else
                    Response.Redirect("~/Default.aspx");
            }
            catch (Exception ex)
            {
                ShowError("Login error: " + ex.Message);
            }
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litError.Text = msg;
        }
    }
}