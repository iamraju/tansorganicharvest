using System;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) LoadDashboard();
        }

        private void LoadDashboard()
        {
            litName.Text = AdminAuth.GetFullName();

            litProducts.Text = DatabaseHelper
                .ExecuteScalar("SELECT COUNT(*) FROM Products WHERE IsActive=1")
                .ToString();

            litOrders.Text = DatabaseHelper
                .ExecuteScalar("SELECT COUNT(*) FROM Orders")
                .ToString();

            litCustomers.Text = DatabaseHelper
                .ExecuteScalar("SELECT COUNT(*) FROM CustomerProfiles")
                .ToString();

            litFeedback.Text = DatabaseHelper
                .ExecuteScalar("SELECT COUNT(*) FROM Feedback WHERE IsRead=0")
                .ToString();

            var dt = DatabaseHelper.ExecuteQuery(
                @"SELECT TOP 10 OrderId, OrderDate, TotalAmount, 
                         Status, PaymentMethod 
                  FROM Orders ORDER BY OrderDate DESC");

            gvRecentOrders.DataSource = dt;
            gvRecentOrders.DataBind();
        }
    }
}