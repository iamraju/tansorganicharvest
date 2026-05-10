using Microsoft.AspNet.Identity;
using Microsoft.Owin;
using Microsoft.Owin.Security.Cookies;
using Owin;
using TansOrganicHarvest.Models;

namespace TansOrganicHarvest
{
    public partial class Startup
    {
        public void ConfigureAuth(IAppBuilder app)
        {
            // Admin uses custom session auth (AdminAuth.cs)
            // Members use Forms Auth via web.config
            // OWIN cookie middleware disabled to avoid redirect conflicts

            // Register ApplicationDbContext per request
            app.CreatePerOwinContext(ApplicationDbContext.Create);

            // Register ApplicationUserManager per request
            app.CreatePerOwinContext<ApplicationUserManager>(
                ApplicationUserManager.Create);

            // Register ApplicationSignInManager per request
            app.CreatePerOwinContext<ApplicationSignInManager>(
                ApplicationSignInManager.Create);

            // Cookie auth for members (public site)
            app.UseCookieAuthentication(new CookieAuthenticationOptions
            {
                AuthenticationType = DefaultAuthenticationTypes.ApplicationCookie,
                LoginPath = new PathString("/Account/Login.aspx"),
                Provider = new CookieAuthenticationProvider()
            });
        }
    }
}