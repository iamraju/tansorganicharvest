using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Members
{
    public partial class Checkout : Page
    {
        private const decimal DELIVERY_FEE = 5.00m;
        private const decimal FREE_DELIVERY_MIN = 50.00m;

        private string UserId
        {
            get
            {
                object id = DatabaseHelper.ExecuteScalar(
                    "SELECT Id FROM AspNetUsers WHERE UserName = @u",
                    new[] { new SqlParameter("@u", User.Identity.Name) });
                return id?.ToString() ?? "";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Redirect if cart is empty
                string userId = UserId;
                object count = DatabaseHelper.ExecuteScalar(
                    "SELECT COUNT(*) FROM Cart WHERE UserId = @uid",
                    new[] { new SqlParameter("@uid", userId) });

                if (count == null || (int)count == 0)
                {
                    Response.Redirect("~/Members/Cart.aspx");
                    return;
                }

                PreFillFromProfile();
                LoadOrderSummary();
            }
        }

        private void PreFillFromProfile()
        {
            DataTable dt = DatabaseHelper.ExecuteQuery(
                @"SELECT FullName, Phone, Address, City, PostalCode
                  FROM CustomerProfiles WHERE UserId = @uid",
                new[] { new SqlParameter("@uid", UserId) });

            if (dt.Rows.Count == 0) return;
            DataRow row = dt.Rows[0];

            txtFullName.Text = row["FullName"].ToString();
            txtPhone.Text = row["Phone"].ToString();
            txtAddress.Text = row["Address"].ToString();
            txtCity.Text = row["City"].ToString();
            txtPostcode.Text = row["PostalCode"].ToString();
        }

        private void LoadOrderSummary()
        {
            DataTable dt = DatabaseHelper.ExecuteQuery(
                @"SELECT p.Name,
                         c.Quantity,
                         CAST(c.Quantity * p.Price AS DECIMAL(10,2)) AS LineTotal
                  FROM Cart c
                  INNER JOIN Products p ON c.ProductId = p.ProductId
                  WHERE c.UserId = @uid",
                new[] { new SqlParameter("@uid", UserId) });

            rptSummary.DataSource = dt;
            rptSummary.DataBind();

            decimal subtotal = 0;
            foreach (DataRow row in dt.Rows)
                subtotal += (decimal)row["LineTotal"];

            decimal delivery = subtotal >= FREE_DELIVERY_MIN ? 0 : DELIVERY_FEE;
            decimal total = subtotal + delivery;

            litSubtotal.Text = subtotal.ToString("F2");
            litDelivery.Text = delivery == 0
                ? "<span class='text-green-600 font-semibold'>FREE</span>"
                : "$" + delivery.ToString("F2");
            litTotal.Text = total.ToString("F2");

            // Store totals in ViewState for use when placing order
            ViewState["Subtotal"] = subtotal;
            ViewState["Delivery"] = delivery;
            ViewState["Total"] = total;
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string userId = UserId;

            try
            {
                decimal subtotal = (decimal)(ViewState["Subtotal"] ?? 0m);
                decimal delivery = (decimal)(ViewState["Delivery"] ?? 0m);
                decimal total = (decimal)(ViewState["Total"] ?? 0m);

                // Determine payment method
                string paymentMethod = "CashOnDelivery";
                if (rbEsewa.Checked) paymentMethod = "Esewa";

                //if (rbCreditCard.Checked) paymentMethod = "CreditCard";
                //else if (rbPayPal.Checked) paymentMethod = "PayPal";
                //else if (rbEsewa.Checked) paymentMethod = "Esewa";

                string deliveryOption = optDelivery.Checked ? "Delivery" : "Pickup";

                // 1. Create the Order record (status: Pending, PaymentStatus: Unpaid)
                object orderId = DatabaseHelper.ExecuteScalar(
                    @"INSERT INTO Orders
                (UserId, TotalAmount, Status, PaymentMethod,
                 PaymentStatus, Notes, CreatedBy)
              OUTPUT INSERTED.OrderId
              VALUES
                (@uid, @total, 'Pending', @payment,
                 'Unpaid', @notes, @by)",
                    new[]
                    {
                new SqlParameter("@uid",     userId),
                new SqlParameter("@total",   total),
                new SqlParameter("@payment", paymentMethod),
                new SqlParameter("@notes",   txtNotes.Text.Trim()),
                new SqlParameter("@by",      User.Identity.Name)
                    });

                int newOrderId = Convert.ToInt32(orderId);

                // 2. Create OrderItems + reduce stock
                DataTable cartItems = DatabaseHelper.ExecuteQuery(
                    @"SELECT c.ProductId, c.Quantity, p.Price
              FROM Cart c
              INNER JOIN Products p ON c.ProductId = p.ProductId
              WHERE c.UserId = @uid",
                    new[] { new SqlParameter("@uid", userId) });

                foreach (DataRow item in cartItems.Rows)
                {
                    DatabaseHelper.ExecuteNonQuery(
                        @"INSERT INTO OrderItems
                    (OrderId, ProductId, Quantity, UnitPrice, CreatedBy)
                  VALUES (@orderId, @prodId, @qty, @price, @by)",
                        new[]
                        {
                    new SqlParameter("@orderId", newOrderId),
                    new SqlParameter("@prodId",  (int)item["ProductId"]),
                    new SqlParameter("@qty",     (int)item["Quantity"]),
                    new SqlParameter("@price",   (decimal)item["Price"]),
                    new SqlParameter("@by",      User.Identity.Name)
                        });

                    DatabaseHelper.ExecuteNonQuery(
                        "UPDATE Products SET Stock = Stock - @qty WHERE ProductId = @pid AND Stock >= @qty",
                        new[]
                        {
                    new SqlParameter("@qty", (int)item["Quantity"]),
                    new SqlParameter("@pid", (int)item["ProductId"])
                        });
                }

                // 3. Save Delivery
                DateTime? preferredDate = null;
                if (!string.IsNullOrEmpty(txtDeliveryDate.Text))
                    preferredDate = DateTime.Parse(txtDeliveryDate.Text);

                DatabaseHelper.ExecuteNonQuery(
                    @"INSERT INTO Deliveries
                (OrderId, FullName, Phone, Address, City, PostalCode,
                 DeliveryOption, PreferredDate, Status, Notes, CreatedBy)
              VALUES
                (@orderId, @name, @phone, @address, @city, @postcode,
                 @option, @date, 'Pending', @notes, @by)",
                    new[]
                    {
                new SqlParameter("@orderId",  newOrderId),
                new SqlParameter("@name",     txtFullName.Text.Trim()),
                new SqlParameter("@phone",    txtPhone.Text.Trim()),
                new SqlParameter("@address",  txtAddress.Text.Trim()),
                new SqlParameter("@city",     txtCity.Text.Trim()),
                new SqlParameter("@postcode", txtPostcode.Text.Trim()),
                new SqlParameter("@option",   deliveryOption),
                new SqlParameter("@date",     (object)preferredDate ?? DBNull.Value),
                new SqlParameter("@notes",    txtNotes.Text.Trim()),
                new SqlParameter("@by",       User.Identity.Name)
                    });

                // 4. Clear cart
                DatabaseHelper.ExecuteNonQuery(
                    "DELETE FROM Cart WHERE UserId = @uid",
                    new[] { new SqlParameter("@uid", userId) });

                // ── eSewa: redirect to eSewa gateway ─────────────────────
                if (paymentMethod == "Esewa")
                {
                    string transactionUuid = EsewaHelper.GenerateTransactionUuid(newOrderId);

                    // Save a pending payment record with the transactionUuid
                    // so we can match it in the callback
                    DatabaseHelper.ExecuteNonQuery(
                        @"INSERT INTO Payments
                    (OrderId, PaymentMethod, Amount, TransactionRef,
                     Status, CreatedBy)
                  VALUES
                    (@orderId, 'Esewa', @amount, @ref, 'Pending', @by)",
                        new[]
                        {
                    new SqlParameter("@orderId", newOrderId),
                    new SqlParameter("@amount",  total),
                    new SqlParameter("@ref",     transactionUuid),
                    new SqlParameter("@by",      User.Identity.Name)
                        });

                    // Redirect to eSewa payment page
                    string esewaUrl = BuildEsewaRedirectUrl(newOrderId, total, transactionUuid);
                    Response.Redirect(esewaUrl);
                    return;
                }

                // 5. Non-eSewa: create payment record and redirect to confirmation
                string txnRef = "TXN" + DateTime.Now.Ticks.ToString().Substring(0, 12);
                string cardLast4 = "", cardHolder = "";

                if (paymentMethod == "CreditCard" &&
                    txtCardNumber.Text.Replace(" ", "").Length >= 4)
                {
                    string cleaned = txtCardNumber.Text.Replace(" ", "");
                    cardLast4 = cleaned.Substring(cleaned.Length - 4);
                    cardHolder = txtCardName.Text.Trim();
                }

                DatabaseHelper.ExecuteNonQuery(
                    @"INSERT INTO Payments
                (OrderId, PaymentMethod, Amount, CardLastFour,
                 CardHolderName, TransactionRef, Status, CreatedBy)
              VALUES
                (@orderId, @method, @amount, @last4,
                 @holder, @ref, 'Completed', @by)",
                    new[]
                    {
                new SqlParameter("@orderId", newOrderId),
                new SqlParameter("@method",  paymentMethod),
                new SqlParameter("@amount",  total),
                new SqlParameter("@last4",   cardLast4),
                new SqlParameter("@holder",  cardHolder),
                new SqlParameter("@ref",     txnRef),
                new SqlParameter("@by",      User.Identity.Name)
                    });

                if (paymentMethod != "CashOnDelivery")
                {
                    DatabaseHelper.ExecuteNonQuery(
                        "UPDATE Orders SET PaymentStatus='Paid' WHERE OrderId=@id",
                        new[] { new SqlParameter("@id", newOrderId) });
                }

                Response.Redirect("~/Members/OrderConfirmation.aspx?id=" + newOrderId);
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Error placing order: " + ex.Message;
            }
        }

        /// <summary>
        /// Builds the eSewa gateway URL by constructing the signed form data
        /// and redirecting via GET with Base64 params.
        /// eSewa ePay v2 uses a POST form — we build it as a self-submitting
        /// form on an intermediate page instead.
        /// </summary>
        private string BuildEsewaRedirectUrl(int orderId, decimal total, string transactionUuid)
        {
            // Pass params to EsewaPayment.aspx which will auto-submit the form
            return string.Format(
                "~/Members/EsewaPayment.aspx?orderId={0}&amount={1}&uuid={2}",
                orderId,
                total.ToString("F2"),
                Server.UrlEncode(transactionUuid));
        }
    }


}