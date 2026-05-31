using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class Subscriptions : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadData();
        }

        private void LoadData()
        {
            // Summary counts
            object active = DatabaseHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Subscriptions WHERE Status='Active'");
            object paused = DatabaseHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Subscriptions WHERE Status='Paused'");
            object totalPts = DatabaseHelper.ExecuteScalar(
                "SELECT ISNULL(SUM(PointsEarned),0) FROM LoyaltyPoints");

            litActive.Text = active != null ? active.ToString() : "0";
            litPaused.Text = paused != null ? paused.ToString() : "0";
            litTotalPoints.Text = totalPts != null ? totalPts.ToString() : "0";

            // Subscription list
            var dt = DatabaseHelper.ExecuteQuery(
                @"SELECT s.SubscriptionId, s.Frequency, s.StartDate,
                         s.NextDelivery, s.Status,
                         b.Name AS BoxName,
                         ISNULL(cp.FullName, u.Email) AS FullName,
                         u.Email
                  FROM Subscriptions s
                  INNER JOIN ProduceBoxes b    ON s.BoxId  = b.BoxId
                  INNER JOIN AspNetUsers u     ON s.UserId = u.Id
                  LEFT  JOIN CustomerProfiles cp ON s.UserId = cp.UserId
                  ORDER BY s.CreatedAt DESC");

            gvSubscriptions.DataSource = dt;
            gvSubscriptions.DataBind();
        }

        protected string GetStatusBadge(string status)
        {
            switch (status)
            {
                case "Active":
                    return "<span class='bg-green-100 text-green-700 text-xs font-semibold px-2.5 py-1 rounded-full'>Active</span>";
                case "Paused":
                    return "<span class='bg-amber-100 text-amber-700 text-xs font-semibold px-2.5 py-1 rounded-full'>Paused</span>";
                default:
                    return "<span class='bg-gray-100 text-gray-500 text-xs font-semibold px-2.5 py-1 rounded-full'>Cancelled</span>";
            }
        }
    }
}