using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using TansOrganicHarvest.Models;

namespace TansOrganicHarvest.Account
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && User.Identity.IsAuthenticated)
                Response.Redirect("~/Default.aspx");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim().ToLower();
            string password = txtPassword.Text;
            string fullName = txtFullName.Text.Trim();
            string phone = txtPhone.Text.Trim();

            try
            {
                // Create UserManager directly — avoids OWIN context null issues
                var userStore = new UserStore<ApplicationUser>(
                    new ApplicationDbContext());
                var manager = new ApplicationUserManager(userStore);

                // Check duplicate email
                var existingUser = manager.FindByEmail(email);
                if (existingUser != null)
                {
                    ShowError("An account with this email already exists. " +
                              "<a href='/Account/Login.aspx' class='underline'>" +
                              "Sign in here</a>");
                    return;
                }

                // Create new user
                var user = new ApplicationUser
                {
                    UserName = email,
                    Email = email,
                    EmailConfirmed = true
                };

                IdentityResult result = manager.Create(user, password);

                if (result.Succeeded)
                {
                    // Save profile
                    DatabaseHelper.ExecuteNonQuery(
                        @"INSERT INTO CustomerProfiles
                            (UserId, FullName, Phone, CreatedBy)
                          VALUES
                            (@userId, @fullName, @phone, @by)",
                        new[]
                        {
                            new SqlParameter("@userId",   user.Id),
                            new SqlParameter("@fullName", fullName),
                            new SqlParameter("@phone",    phone),
                            new SqlParameter("@by",       email)
                        });

                    // Sign in using OWIN auth manager directly
                    var identity = manager.CreateIdentity(
                        user, DefaultAuthenticationTypes.ApplicationCookie);

                    var authManager = HttpContext.Current.GetOwinContext()
                        .Authentication;
                    authManager.SignIn(
                        new AuthenticationProperties { IsPersistent = false },
                        identity);

                    Response.Redirect("~/Default.aspx");
                }
                else
                {
                    string errors = string.Join("<br/>", result.Errors);
                    ShowError(errors);
                }
            }
            catch (Exception ex)
            {
                ShowError("Registration error: " + ex.Message +
                    (ex.InnerException != null
                        ? " | " + ex.InnerException.Message
                        : ""));
            }
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litError.Text = msg;
        }
    }
}