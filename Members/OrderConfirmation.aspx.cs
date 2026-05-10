using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Members
{
    public partial class OrderConfirmation : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadOrder();
        }

        private void LoadOrder()
        {
            int orderId;
            if (!int.TryParse(Request.QueryString["id"], out orderId) || orderId == 0)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            // Load order
            DataTable dtOrder = DatabaseHelper.ExecuteQuery(
                @"SELECT o.OrderId, o.OrderDate, o.TotalAmount,
                         o.Status, o.PaymentMethod, o.PaymentStatus
                  FROM Orders o
                  WHERE o.OrderId = @id AND o.UserId = (
                      SELECT Id FROM AspNetUsers WHERE UserName = @u)",
                new[]
                {
                    new SqlParameter("@id", orderId),
                    new SqlParameter("@u",  User.Identity.Name)
                });

            if (dtOrder.Rows.Count == 0)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            DataRow order = dtOrder.Rows[0];
            litOrderId.Text = order["OrderId"].ToString();
            litOrderDate.Text = ((DateTime)order["OrderDate"]).ToString("dd MMM yyyy, h:mm tt");
            litStatus.Text = order["Status"].ToString();
            litPaymentMethod.Text = order["PaymentMethod"].ToString();

            bool paid = order["PaymentStatus"].ToString() == "Paid";
            litPaymentStatus.Text = paid ? "✅ Paid" : "⏳ Pay on Delivery";
            paymentStatusBadge.Attributes["class"] = paid
                ? "bg-green-100 text-green-700 text-xs font-semibold px-3 py-1.5 rounded-full"
                : "bg-amber-100 text-amber-700 text-xs font-semibold px-3 py-1.5 rounded-full";

            // Load order items
            DataTable dtItems = DatabaseHelper.ExecuteQuery(
                @"SELECT oi.Quantity, oi.UnitPrice,
                         p.Name, p.ImageUrl,
                         CAST(oi.Quantity * oi.UnitPrice AS DECIMAL(10,2)) AS LineTotal
                  FROM OrderItems oi
                  INNER JOIN Products p ON oi.ProductId = p.ProductId
                  WHERE oi.OrderId = @id",
                new[] { new SqlParameter("@id", orderId) });

            rptItems.DataSource = dtItems;
            rptItems.DataBind();

            // Calculate subtotal and delivery
            decimal subtotal = 0;
            foreach (DataRow row in dtItems.Rows)
                subtotal += (decimal)row["LineTotal"];

            decimal totalAmt = (decimal)order["TotalAmount"];
            decimal delivery = totalAmt - subtotal;

            litSubtotal.Text = subtotal.ToString("F2");
            litDeliveryFee.Text = delivery <= 0
                ? "<span class='text-green-600 font-semibold'>FREE</span>"
                : "$" + delivery.ToString("F2");
            litTotal.Text = totalAmt.ToString("F2");

            // Load delivery info
            DataTable dtDelivery = DatabaseHelper.ExecuteQuery(
                @"SELECT FullName, Address, City, PostalCode,
                         DeliveryOption, Status
                  FROM Deliveries WHERE OrderId = @id",
                new[] { new SqlParameter("@id", orderId) });

            if (dtDelivery.Rows.Count > 0)
            {
                DataRow d = dtDelivery.Rows[0];
                litDeliveryName.Text = d["FullName"].ToString();
                litDeliveryAddress.Text = d["Address"] + ", " +
                                          d["City"] + " " + d["PostalCode"];
                litDeliveryOption.Text = d["DeliveryOption"].ToString();
            }

            // Transaction ref
            DataTable dtPay = DatabaseHelper.ExecuteQuery(
                "SELECT TransactionRef FROM Payments WHERE OrderId = @id",
                new[] { new SqlParameter("@id", orderId) });

            if (dtPay.Rows.Count > 0)
                litTransactionRef.Text = dtPay.Rows[0]["TransactionRef"].ToString();
        }
    }
}