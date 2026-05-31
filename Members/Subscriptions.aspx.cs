using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest.Members
{
    public partial class Subscriptions : Page
    {
        private string UserId
        {
            get
            {
                object id = DatabaseHelper.ExecuteScalar(
                    "SELECT Id FROM AspNetUsers WHERE UserName = @u",
                    new[] { new SqlParameter("@u", User.Identity.Name) });
                return id != null ? id.ToString() : "";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBoxes();
                LoadSubscriptions();
                // Default start date to tomorrow
                txtStartDate.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
            }
        }

        private void LoadBoxes()
        {
            DataTable dt = DatabaseHelper.ExecuteQuery(
                @"SELECT BoxId, Name + ' — $' + CAST(Price AS NVARCHAR) AS DisplayName
                  FROM ProduceBoxes WHERE IsActive = 1 ORDER BY Price");
            ddlBox.Items.Clear();
            ddlBox.Items.Add(new System.Web.UI.WebControls.ListItem(
                "-- Select a Box --", ""));
            foreach (DataRow row in dt.Rows)
                ddlBox.Items.Add(new System.Web.UI.WebControls.ListItem(
                    row["DisplayName"].ToString(), row["BoxId"].ToString()));
        }

        private void LoadSubscriptions()
        {
            DataTable dt = DatabaseHelper.ExecuteQuery(
                @"SELECT s.SubscriptionId, s.Frequency, s.StartDate,
                         s.NextDelivery, s.Status, s.Notes,
                         b.Name AS BoxName, b.Price, b.ImageUrl
                  FROM Subscriptions s
                  INNER JOIN ProduceBoxes b ON s.BoxId = b.BoxId
                  WHERE s.UserId = @uid AND s.Status != 'Cancelled'
                  ORDER BY s.CreatedAt DESC",
                new[] { new SqlParameter("@uid", UserId) });

            if (dt.Rows.Count == 0)
            {
                pnlNoSubs.Visible = true;
                rptSubscriptions.Visible = false;
            }
            else
            {
                pnlNoSubs.Visible = false;
                rptSubscriptions.Visible = true;
                rptSubscriptions.DataSource = dt;
                rptSubscriptions.DataBind();
            }
        }

        protected void btnSubscribe_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                string userId = UserId;
                int boxId = int.Parse(ddlBox.SelectedValue);
                string freq = ddlFrequency.SelectedValue;
                DateTime start = DateTime.Parse(txtStartDate.Text);
                DateTime next = start; // first delivery = start date

                // Check not already subscribed to same box
                object existing = DatabaseHelper.ExecuteScalar(
                    @"SELECT COUNT(*) FROM Subscriptions
                      WHERE UserId = @uid AND BoxId = @bid AND Status = 'Active'",
                    new[]
                    {
                        new SqlParameter("@uid", userId),
                        new SqlParameter("@bid", boxId)
                    });

                if (existing != null && (int)existing > 0)
                {
                    ShowError("You already have an active subscription for this box.");
                    return;
                }

                DatabaseHelper.ExecuteNonQuery(
                    @"INSERT INTO Subscriptions
                        (UserId, BoxId, Frequency, StartDate, NextDelivery,
                         Status, Notes, CreatedBy)
                      VALUES
                        (@uid, @bid, @freq, @start, @next,
                         'Active', @notes, @by)",
                    new[]
                    {
                        new SqlParameter("@uid",   userId),
                        new SqlParameter("@bid",   boxId),
                        new SqlParameter("@freq",  freq),
                        new SqlParameter("@start", start),
                        new SqlParameter("@next",  next),
                        new SqlParameter("@notes", txtNotes.Text.Trim()),
                        new SqlParameter("@by",    User.Identity.Name)
                    });

                // Award 50 bonus points for subscribing
                AwardPoints(userId, null, 50,
                    "Bonus points for new subscription!");

                ShowSuccess("Subscription created! You earned 50 bonus loyalty points.");
                txtNotes.Text = "";
                ddlBox.SelectedIndex = 0;
                LoadSubscriptions();
            }
            catch (Exception ex)
            {
                ShowError("Error creating subscription: " + ex.Message);
            }
        }

        protected void rptSubscriptions_ItemCommand(
            object source, RepeaterCommandEventArgs e)
        {
            int subId = int.Parse(e.CommandArgument.ToString());

            switch (e.CommandName)
            {
                case "Pause":
                    DatabaseHelper.ExecuteNonQuery(
                        @"UPDATE Subscriptions SET Status='Paused',
                          UpdatedAt=GETDATE(), UpdatedBy=@by
                          WHERE SubscriptionId=@id",
                        new[]
                        {
                            new SqlParameter("@by", User.Identity.Name),
                            new SqlParameter("@id", subId)
                        });
                    ShowSuccess("Subscription paused.");
                    break;

                case "Resume":
                    DatabaseHelper.ExecuteNonQuery(
                        @"UPDATE Subscriptions SET Status='Active',
                          UpdatedAt=GETDATE(), UpdatedBy=@by
                          WHERE SubscriptionId=@id",
                        new[]
                        {
                            new SqlParameter("@by", User.Identity.Name),
                            new SqlParameter("@id", subId)
                        });
                    ShowSuccess("Subscription resumed.");
                    break;

                case "Cancel":
                    DatabaseHelper.ExecuteNonQuery(
                        @"UPDATE Subscriptions SET Status='Cancelled',
                          UpdatedAt=GETDATE(), UpdatedBy=@by
                          WHERE SubscriptionId=@id",
                        new[]
                        {
                            new SqlParameter("@by", User.Identity.Name),
                            new SqlParameter("@id", subId)
                        });
                    ShowSuccess("Subscription cancelled.");
                    break;
            }

            LoadSubscriptions();
        }

        // Award loyalty points helper
        private void AwardPoints(string userId, int? orderId,
            int points, string description)
        {
            DatabaseHelper.ExecuteNonQuery(
                @"INSERT INTO LoyaltyPoints
                    (UserId, OrderId, PointsEarned, Description, CreatedBy)
                  VALUES (@uid, @oid, @pts, @desc, @by)",
                new[]
                {
                    new SqlParameter("@uid",  userId),
                    new SqlParameter("@oid",  (object)orderId ?? DBNull.Value),
                    new SqlParameter("@pts",  points),
                    new SqlParameter("@desc", description),
                    new SqlParameter("@by",   User.Identity.Name)
                });
        }

        protected string GetStatusBadge(string status)
        {
            switch (status)
            {
                case "Active":
                    return "<span class='bg-green-100 text-green-700 text-xs font-semibold px-2.5 py-1 rounded-full'>● Active</span>";
                case "Paused":
                    return "<span class='bg-amber-100 text-amber-700 text-xs font-semibold px-2.5 py-1 rounded-full'>⏸ Paused</span>";
                default:
                    return "<span class='bg-gray-100 text-gray-500 text-xs font-semibold px-2.5 py-1 rounded-full'>Cancelled</span>";
            }
        }

        private void ShowSuccess(string msg)
        {
            pnlSuccess.Visible = true;
            litSuccess.Text = msg;
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litError.Text = msg;
        }
    }
}