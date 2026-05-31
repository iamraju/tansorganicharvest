using System;
using System.Data;
using System.Data.SqlClient;

namespace TansOrganicHarvest.Members.Controls
{
    public partial class MemberSidebar : System.Web.UI.Page
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
            if (!IsPostBack && User.Identity.IsAuthenticated)
            {
                LoadProfile();
                DataBind(); // Needed for GetActiveClass method
            }
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
        }
    }
}