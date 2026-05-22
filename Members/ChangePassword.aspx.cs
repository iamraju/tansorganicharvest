using System;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using TansOrganicHarvest.Models;

namespace TansOrganicHarvest.Members
{
    public partial class ChangePassword : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnChange_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                var userStore = new UserStore<ApplicationUser>(
                    new ApplicationDbContext());
                var manager = new ApplicationUserManager(userStore);

                string email = User.Identity.Name;
                var user = manager.FindByEmail(email);

                if (user == null)
                {
                    ShowError("User not found.");
                    return;
                }

                // Verify current password
                bool valid = manager.CheckPassword(user,
                    txtCurrentPassword.Text);
                if (!valid)
                {
                    ShowError("Current password is incorrect.");
                    return;
                }

                // Change password
                string resetToken = manager.GeneratePasswordResetToken(user.Id);
                IdentityResult result = manager.ResetPassword(
                    user.Id, resetToken, txtNewPassword.Text);

                if (result.Succeeded)
                {
                    pnlSuccess.Visible = true;
                    pnlForm.Visible = false;
                    pnlError.Visible = false;
                }
                else
                {
                    ShowError(string.Join("<br/>", result.Errors));
                }
            }
            catch (Exception ex)
            {
                ShowError("Error: " + ex.Message);
            }
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litError.Text = msg;
        }
    }
}