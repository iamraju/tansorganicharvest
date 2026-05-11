using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class OrderDetail : Page
    {
        private int OrderId
        {
            get
            {
                int id;
                return int.TryParse(Request.QueryString["id"], out id) ? id : 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadOrder();
        }

        private void LoadOrder()
        {
            if (OrderId == 0)
            {
                Response.Redirect("Orders.aspx");
                return;
            }

            // Load order + customer
            DataTable dtOrder = DatabaseHelper.ExecuteQuery(
                @"SELECT o.OrderId, o.OrderDate, o.TotalAmount,
                         o.Status, o.PaymentMethod, o.PaymentStatus, o.Notes,
                         u.Email,
                         ISNULL(cp.FullName, u.Email) AS FullName,
                         ISNULL(cp.Phone, '')          AS Phone
                  FROM Orders o
                  INNER JOIN AspNetUsers u     ON o.UserId    = u.Id
                  LEFT  JOIN CustomerProfiles cp ON o.UserId  = cp.UserId
                  WHERE o.OrderId = @id",
                new[] { new SqlParameter("@id", OrderId) });

            if (dtOrder.Rows.Count == 0)
            {
                Response.Redirect("Orders.aspx");
                return;
            }

            DataRow o = dtOrder.Rows[0];

            litOrderId.Text = o["OrderId"].ToString();
            litOrderDate.Text = ((DateTime)o["OrderDate"]).ToString("dd MMM yyyy, h:mm tt");

            litCustomerName.Text = o["FullName"].ToString();
            litCustomerEmail.Text = o["Email"].ToString();
            litCustomerPhone.Text = o["Phone"].ToString();

            // Set status dropdowns to current values
            ddlOrderStatus.SelectedValue = o["Status"].ToString();
            ddlPaymentStatus.SelectedValue = o["PaymentStatus"].ToString();
            txtAdminNotes.Text = o["Notes"].ToString();

            // Load order items
            DataTable dtItems = DatabaseHelper.ExecuteQuery(
                @"SELECT oi.Quantity, oi.UnitPrice,
                         p.Name, p.ImageUrl,
                         c.Name AS CategoryName,
                         CAST(oi.Quantity * oi.UnitPrice AS DECIMAL(10,2)) AS LineTotal
                  FROM OrderItems oi
                  INNER JOIN Products  p ON oi.ProductId  = p.ProductId
                  INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                  WHERE oi.OrderId = @id",
                new[] { new SqlParameter("@id", OrderId) });

            rptItems.DataSource = dtItems;
            rptItems.DataBind();

            // Totals
            decimal subtotal = 0;
            foreach (DataRow row in dtItems.Rows)
                subtotal += (decimal)row["LineTotal"];

            decimal total = (decimal)o["TotalAmount"];
            decimal delivery = total - subtotal;

            litSubtotal.Text = subtotal.ToString("F2");
            litDeliveryFee.Text = delivery <= 0
                ? "<span class='text-green-600 font-semibold'>FREE</span>"
                : "$" + delivery.ToString("F2");
            litTotal.Text = total.ToString("F2");

            // Delivery
            DataTable dtDelivery = DatabaseHelper.ExecuteQuery(
                @"SELECT FullName, Phone, Address, City, PostalCode,
                         DeliveryOption, PreferredDate, Status
                  FROM Deliveries WHERE OrderId = @id",
                new[] { new SqlParameter("@id", OrderId) });

            if (dtDelivery.Rows.Count > 0)
            {
                DataRow d = dtDelivery.Rows[0];
                litDeliveryOption.Text = d["DeliveryOption"].ToString();
                litDeliveryAddress.Text = d["Address"] + ", " +
                                          d["City"] + " " + d["PostalCode"];

                object prefDate = d["PreferredDate"];
                litPreferredDate.Text = prefDate != DBNull.Value
                    ? ((DateTime)prefDate).ToString("dd MMM yyyy")
                    : "Not specified";

                //litDeliveryStatus.Text = ViewHelpers.GetOrderStatusBadge(
                //    d["Status"]);
                // Replace ViewHelpers call with direct string formatting
                string dStatus = d["Status"].ToString();
                litDeliveryStatus.Text = GetStatusBadgeHtml(dStatus);

                ddlDeliveryStatus.SelectedValue = d["Status"].ToString();
            }

            // Payment
            DataTable dtPay = DatabaseHelper.ExecuteQuery(
                @"SELECT PaymentMethod, Amount, TransactionRef,
                         CardLastFour, CardHolderName
                  FROM Payments WHERE OrderId = @id",
                new[] { new SqlParameter("@id", OrderId) });

            if (dtPay.Rows.Count > 0)
            {
                DataRow p = dtPay.Rows[0];
                litPayMethod.Text = p["PaymentMethod"].ToString();
                litPayAmount.Text = ((decimal)p["Amount"]).ToString("F2");
                litPayRef.Text = p["TransactionRef"].ToString();

                string last4 = p["CardLastFour"].ToString();
                if (!string.IsNullOrEmpty(last4))
                {
                    pnlCardInfo.Visible = true;
                    litCardLast4.Text = last4;
                }
            }
        }

        protected void btnUpdateStatus_Click(object sender, EventArgs e)
        {
            try
            {
                DatabaseHelper.ExecuteNonQuery(
                    @"UPDATE Orders SET
                        Status        = @status,
                        PaymentStatus = @payStatus,
                        Notes         = @notes,
                        UpdatedAt     = GETDATE(),
                        UpdatedBy     = @by
                      WHERE OrderId = @id",
                    new[]
                    {
                        new SqlParameter("@status",    ddlOrderStatus.SelectedValue),
                        new SqlParameter("@payStatus", ddlPaymentStatus.SelectedValue),
                        new SqlParameter("@notes",     txtAdminNotes.Text.Trim()),
                        new SqlParameter("@by",        AdminAuth.GetUsername()),
                        new SqlParameter("@id",        OrderId)
                    });

                // Also update payment record if marking as Paid
                if (ddlPaymentStatus.SelectedValue == "Paid")
                {
                    DatabaseHelper.ExecuteNonQuery(
                        @"UPDATE Payments SET Status = 'Completed'
                          WHERE OrderId = @id",
                        new[] { new SqlParameter("@id", OrderId) });
                }

                ShowSuccess("Order status updated successfully.");
                LoadOrder();
            }
            catch (Exception ex)
            {
                ShowSuccess("Error: " + ex.Message);
            }
        }

        protected void btnUpdateDelivery_Click(object sender, EventArgs e)
        {
            try
            {
                DatabaseHelper.ExecuteNonQuery(
                    @"UPDATE Deliveries SET
                        Status    = @status,
                        UpdatedAt = GETDATE(),
                        UpdatedBy = @by
                      WHERE OrderId = @id",
                    new[]
                    {
                        new SqlParameter("@status", ddlDeliveryStatus.SelectedValue),
                        new SqlParameter("@by",     AdminAuth.GetUsername()),
                        new SqlParameter("@id",     OrderId)
                    });

                ShowSuccess("Delivery status updated.");
                LoadOrder();
            }
            catch (Exception ex)
            {
                ShowSuccess("Error: " + ex.Message);
            }
        }

        private void ShowSuccess(string msg)
        {
            pnlSuccess.Visible = true;
            litSuccess.Text = msg;
        }

        // Local helper — mirrors ViewHelpers but usable in code-behind
        private string GetStatusBadgeHtml(string status)
        {
            string css;
            string icon;
            switch (status)
            {
                case "Pending":
                    css = "bg-amber-100 text-amber-700"; icon = "⏳"; break;
                case "Processing":
                case "Preparing":
                    css = "bg-blue-100 text-blue-700"; icon = "⚙️"; break;
                case "Shipped":
                    css = "bg-purple-100 text-purple-700"; icon = "🚚"; break;
                case "Delivered":
                    css = "bg-green-100 text-green-700"; icon = "✅"; break;
                case "Cancelled":
                case "Failed":
                    css = "bg-red-100 text-red-700"; icon = "❌"; break;
                default:
                    css = "bg-gray-100 text-gray-600"; icon = "📋"; break;
            }
            return string.Format(
                "<span class='{0} text-xs font-semibold px-2.5 py-1 rounded-full'>" +
                "{1} {2}</span>", css, icon, status);
        }
    }
}