using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Members
{
    public partial class EsewaFailure : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string orderId = Request.QueryString["orderId"];
            litOrderId.Text = orderId ?? "Unknown";

            // Mark the pending payment as Failed
            if (!string.IsNullOrEmpty(orderId))
            {
                DatabaseHelper.ExecuteNonQuery(
                    @"UPDATE Payments SET
                        Status    = 'Failed',
                        UpdatedAt = GETDATE()
                      WHERE OrderId = @id AND Status = 'Pending'",
                    new[] { new SqlParameter("@id", int.Parse(orderId)) });
            }
        }
    }
}