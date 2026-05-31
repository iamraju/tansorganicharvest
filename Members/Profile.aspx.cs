using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Members
{
    public partial class Profile : Page
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
                LoadProfile();
        }

        private void LoadProfile()
        {
            string userId = UserId;
            string email = User.Identity.Name;

            // Get or create profile
            DataTable dt = DatabaseHelper.ExecuteQuery(
                "SELECT * FROM CustomerProfiles WHERE UserId = @uid",
                new[] { new SqlParameter("@uid", userId) });

            if (dt.Rows.Count == 0)
            {
                // Auto-create profile record if not exists
                DatabaseHelper.ExecuteNonQuery(
                    @"INSERT INTO CustomerProfiles (UserId, FullName, CreatedBy)
                      VALUES (@uid, @name, @by)",
                    new[]
                    {
                        new SqlParameter("@uid",  userId),
                        new SqlParameter("@name", email),
                        new SqlParameter("@by",   email)
                    });
                dt = DatabaseHelper.ExecuteQuery(
                    "SELECT * FROM CustomerProfiles WHERE UserId = @uid",
                    new[] { new SqlParameter("@uid", userId) });
            }

            DataRow row = dt.Rows[0];

            string fullName = row["FullName"].ToString();
            if (string.IsNullOrEmpty(fullName)) fullName = email;

            litInitial.Text = fullName.Substring(0, 1).ToUpper();
            litDisplayName.Text = fullName;
            litEmail.Text = email;
            litMemberSince.Text = ((DateTime)row["CreatedAt"]).ToString("MMM yyyy");

            txtFullName.Text = row["FullName"].ToString();
            txtPhone.Text = row["Phone"].ToString();
            txtAddress.Text = row["Address"].ToString();
            txtCity.Text = row["City"].ToString();
            txtPostalCode.Text = row["PostalCode"].ToString();

            // Stats
            object orders = DatabaseHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Orders WHERE UserId = @uid",
                new[] { new SqlParameter("@uid", userId) });
            litTotalOrders.Text = orders != null ? orders.ToString() : "0";

            object spent = DatabaseHelper.ExecuteScalar(
                "SELECT ISNULL(SUM(TotalAmount),0) FROM Orders WHERE UserId = @uid",
                new[] { new SqlParameter("@uid", userId) });
            litTotalSpent.Text = spent != null
                ? Convert.ToDecimal(spent).ToString("F2") : "0.00";

            object cart = DatabaseHelper.ExecuteScalar(
                "SELECT ISNULL(SUM(Quantity),0) FROM Cart WHERE UserId = @uid",
                new[] { new SqlParameter("@uid", userId) });
            litCartItems.Text = cart != null ? cart.ToString() : "0";

            // Loyalty points
            object points = DatabaseHelper.ExecuteScalar(
                @"SELECT ISNULL(SUM(PointsEarned) - SUM(PointsRedeemed), 0)
                  FROM LoyaltyPoints WHERE UserId = @uid",
                            new[] { new SqlParameter("@uid", userId) });

            int availablePoints = points != null ? Convert.ToInt32(points) : 0;
            litPoints.Text = availablePoints.ToString();
            litPointsValue.Text = (availablePoints / 100m).ToString("F2");
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                string userId = UserId;
                DatabaseHelper.ExecuteNonQuery(
                    @"UPDATE CustomerProfiles SET
                        FullName   = @name,
                        Phone      = @phone,
                        Address    = @address,
                        City       = @city,
                        PostalCode = @postal,
                        UpdatedAt  = GETDATE(),
                        UpdatedBy  = @by
                      WHERE UserId = @uid",
                    new[]
                    {
                        new SqlParameter("@name",   txtFullName.Text.Trim()),
                        new SqlParameter("@phone",  txtPhone.Text.Trim()),
                        new SqlParameter("@address",txtAddress.Text.Trim()),
                        new SqlParameter("@city",   txtCity.Text.Trim()),
                        new SqlParameter("@postal", txtPostalCode.Text.Trim()),
                        new SqlParameter("@by",     User.Identity.Name),
                        new SqlParameter("@uid",    userId)
                    });

                pnlSuccess.Visible = true;
                litSuccess.Text = "Profile updated successfully.";
                LoadProfile();
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Error: " + ex.Message;
            }
        }
    }
}