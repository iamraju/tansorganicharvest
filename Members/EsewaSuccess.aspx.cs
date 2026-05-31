using System;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Web.UI;

namespace TansOrganicHarvest.Members
{
    public partial class EsewaSuccess : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Run async verification synchronously in Web Forms
                Task.Run(() => VerifyEsewaPaymentAsync()).GetAwaiter().GetResult();
            }
        }

        private async Task VerifyEsewaPaymentAsync()
        {
            // eSewa sends the response as Base64 JSON in ?data= query param
            string base64Data = Request.QueryString["data"];

            if (string.IsNullOrEmpty(base64Data))
            {
                ShowFailed("No payment data received from eSewa.");
                return;
            }

            // Step 1: Decode the Base64 callback data
            EsewaCallbackData callbackData = EsewaHelper.DecodeCallbackData(base64Data);

            if (callbackData == null)
            {
                ShowFailed("Could not decode payment response from eSewa.");
                return;
            }

            // Step 2: Check that status is COMPLETE
            if (!string.Equals(callbackData.status, "COMPLETE",
                StringComparison.OrdinalIgnoreCase))
            {
                ShowFailed("eSewa reported payment status: " + callbackData.status);
                return;
            }

            // Step 3: Verify signature from callback to prevent tampering
            decimal totalAmount;
            if (!decimal.TryParse(callbackData.total_amount, out totalAmount))
            {
                ShowFailed("Invalid amount in eSewa response.");
                return;
            }

            bool signatureValid = EsewaHelper.VerifySignature(
                totalAmount,
                callbackData.transaction_uuid,
                callbackData.signature);

            if (!signatureValid)
            {
                ShowFailed("Signature verification failed. Payment may have been tampered with.");
                return;
            }

            // Step 4: Cross-verify with eSewa's status API (server-to-server)
            EsewaStatusResponse statusResponse = await EsewaHelper.VerifyTransactionAsync(
                callbackData.transaction_uuid, totalAmount);

            if (statusResponse == null ||
                !string.Equals(statusResponse.status, "COMPLETE",
                    StringComparison.OrdinalIgnoreCase))
            {
                ShowFailed("eSewa server verification failed: " +
                    (statusResponse?.status ?? "No response"));
                return;
            }

            // Step 5: Look up the pending order by transaction_uuid
            var dt = DatabaseHelper.ExecuteQuery(
                @"SELECT p.PaymentId, p.OrderId, p.Amount
                  FROM Payments p
                  WHERE p.TransactionRef = @uuid AND p.Status = 'Pending'",
                new[] { new SqlParameter("@uuid", callbackData.transaction_uuid) });

            if (dt.Rows.Count == 0)
            {
                ShowFailed("Order not found for this transaction. " +
                    "It may have already been processed.");
                return;
            }

            int paymentId = (int)dt.Rows[0]["PaymentId"];
            int orderId = (int)dt.Rows[0]["OrderId"];

            // Add this after fetching orderId from Payments table
            object userIdObj = DatabaseHelper.ExecuteScalar(
                "SELECT UserId FROM Orders WHERE OrderId = @id",
                new[] { new SqlParameter("@id", orderId) });
            string userId = userIdObj != null ? userIdObj.ToString() : "";

            // Step 6: Update the Payment record to Completed
            DatabaseHelper.ExecuteNonQuery(
                @"UPDATE Payments SET
                    Status               = 'Completed',
                    EsewaTransactionCode = @txnCode,
                    EsewaRefId           = @refId,
                    EsewaStatus          = 'COMPLETE',
                    UpdatedAt            = GETDATE()
                  WHERE PaymentId = @id",
                new[]
                {
                    new SqlParameter("@txnCode", callbackData.transaction_code ?? ""),
                    new SqlParameter("@refId",   statusResponse.ref_id ?? ""),
                    new SqlParameter("@id",      paymentId)
                });

            // Step 7: Update the Order to Paid
            DatabaseHelper.ExecuteNonQuery(
                @"UPDATE Orders SET
                    PaymentStatus = 'Paid',
                    UpdatedAt     = GETDATE()
                  WHERE OrderId = @id",
                new[] { new SqlParameter("@id", orderId) });

            // Step 8: Award points for eSewa payment
            int points = (int)Math.Floor(totalAmount);
            if (points > 0)
            {
                DatabaseHelper.ExecuteNonQuery(
                    @"INSERT INTO LoyaltyPoints
                    (UserId, OrderId, PointsEarned, Description, CreatedBy)
                  VALUES (@uid, @oid, @pts, @desc, @by)",
                            new[]
                            {
                    new SqlParameter("@uid",  userId),
                    new SqlParameter("@oid",  orderId),
                    new SqlParameter("@pts",  points),
                    new SqlParameter("@desc", "Points earned on order #" + orderId),
                    new SqlParameter("@by",   "system")
                            });
                    }

            // Step 9: Show success
            pnlVerifying.Visible = false;
            pnlSuccess.Visible = true;
            litTxnCode.Text = callbackData.transaction_code;
            ViewState["ConfirmUrl"] = "/Members/OrderConfirmation.aspx?id=" + orderId;
        }

        private void ShowFailed(string message)
        {
            pnlVerifying.Visible = false;
            pnlFailed.Visible = true;
            litError.Text = message;
        }
    }
}