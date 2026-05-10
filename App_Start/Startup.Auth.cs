using Microsoft.AspNet.Identity;
using Microsoft.Owin;
using Microsoft.Owin.Security.Cookies;
using Owin;

namespace TansOrganicHarvest
{
    public partial class Startup
    {
        public void ConfigureAuth(IAppBuilder app)
        {
            // Admin uses custom session auth (AdminAuth.cs)
            // Members use Forms Auth via web.config
            // OWIN cookie middleware disabled to avoid redirect conflicts
        }
    }
}