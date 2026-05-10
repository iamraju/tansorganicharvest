using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(TansOrganicHarvest.Startup))]
namespace TansOrganicHarvest
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}