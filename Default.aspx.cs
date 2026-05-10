using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;

namespace TansOrganicHarvest
{
    public partial class Default : Page
    {
        public class Feature
        {
            public string Icon { get; set; }
            public string Title { get; set; }
            public string Description { get; set; }
        }

        public List<Feature> Features = new List<Feature>
        {
            new Feature {
                Icon        = "🌱",
                Title       = "100% Organic",
                Description = "No pesticides, herbicides or synthetic fertilisers. Ever."
            },
            new Feature {
                Icon        = "🚚",
                Title       = "Farm Fresh Delivery",
                Description = "Harvested within 48 hours of reaching your door."
            },
            new Feature {
                Icon        = "📦",
                Title       = "Customisable Boxes",
                Description = "Build your own weekly box based on what your family loves."
            },
            new Feature {
                Icon        = "💚",
                Title       = "Family Grown",
                Description = "Three generations of the Tan family tending the same land."
            }
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFeaturedProducts();
                LoadCategories();
            }
        }

        private void LoadFeaturedProducts()
        {
            string sql = @"SELECT TOP 8 p.ProductId, p.Name, p.Price, p.Unit, p.IsFeatured,
                                  p.ImageUrl, c.Name AS CategoryName
                           FROM Products p
                           INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                           WHERE p.IsFeatured = 1 AND p.IsActive = 1
                           ORDER BY p.CreatedAt DESC";

            DataTable dt = DatabaseHelper.ExecuteQuery(sql);
            rptFeatured.DataSource = dt;
            rptFeatured.DataBind();
        }

        private void LoadCategories()
        {
            DataTable dt = DatabaseHelper.ExecuteQuery(
                "SELECT CategoryId, Name FROM Categories " +
                "WHERE IsActive = 1 ORDER BY SortOrder");
            rptCategories.DataSource = dt;
            rptCategories.DataBind();
        }
    }
}