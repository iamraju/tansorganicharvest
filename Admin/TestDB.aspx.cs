using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class TestDB : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Show connection string (mask password if any)
            litConnStr.Text = ConfigurationManager
                .ConnectionStrings["TansDBContext"]?.ConnectionString
                ?? "CONNECTION STRING NOT FOUND IN WEB.CONFIG";
        }

        protected void btnTest_Click(object sender, EventArgs e)
        {
            litResult.Text = DatabaseHelper.TestConnection();
        }

        protected void btnTestAdmin_Click(object sender, EventArgs e)
        {
            try
            {
                var dt = DatabaseHelper.ExecuteQuery(
                    "SELECT AdminId, Username, FullName, IsActive FROM AdminUsers");

                if (dt.Rows.Count == 0)
                {
                    litResult.Text = "⚠️ AdminUsers table is EMPTY. Run the seed INSERT.";
                    return;
                }

                var sb = new StringBuilder();
                sb.Append($"✅ Found {dt.Rows.Count} admin user(s):<br/><br/>");
                foreach (System.Data.DataRow row in dt.Rows)
                {
                    sb.Append($"ID: {row["AdminId"]} | " +
                              $"Username: {row["Username"]} | " +
                              $"Name: {row["FullName"]} | " +
                              $"Active: {row["IsActive"]}<br/>");
                }
                litResult.Text = sb.ToString();
            }
            catch (Exception ex)
            {
                litResult.Text = "❌ Error: " + ex.Message;
            }
        }

        protected void btnTestLogin_Click(object sender, EventArgs e)
        {
            try
            {
                // Test exact query used by login
                string sql = @"SELECT COUNT(1) FROM AdminUsers 
                               WHERE Username = @u AND PasswordHash = @p AND IsActive = 1";

                var result = DatabaseHelper.ExecuteScalar(sql, new[]
                {
                    new SqlParameter("@u", "admin"),
                    new SqlParameter("@p", "Admin@123")
                });

                int count = result != null ? (int)result : 0;
                litResult.Text = count > 0
                    ? "✅ Login query SUCCESS — admin/Admin@123 is valid."
                    : "❌ Login query returned 0 — username/password not found in DB. " +
                      "Check the AdminUsers table data.";
            }
            catch (Exception ex)
            {
                litResult.Text = "❌ Query error: " + ex.Message;
            }
        }
    }
}