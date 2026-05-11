using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest.Members
{
    public partial class OrderHistory : Page
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
                LoadOrders();
        }

        private void LoadOrders()
        {
            DataTable dt = DatabaseHelper.ExecuteQuery(
                @"SELECT o.OrderId, o.OrderDate, o.TotalAmount,
                         o.Status, o.PaymentMethod, o.PaymentStatus,
                         ISNULL(p.TransactionRef, 'N/A') AS TransactionRef
                  FROM Orders o
                  LEFT JOIN Payments p ON o.OrderId = p.OrderId
                  WHERE o.UserId = @uid
                  ORDER BY o.OrderDate DESC",
                new[] { new SqlParameter("@uid", UserId) });

            if (dt.Rows.Count == 0)
            {
                pnlEmpty.Visible = true;
                pnlOrders.Visible = false;
                return;
            }

            pnlOrders.Visible = true;
            pnlEmpty.Visible = false;

            rptOrders.DataSource = dt;
            rptOrders.DataBind();
        }

        // Use ItemDataBound to bind nested repeater — avoids scope issues
        protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            DataRowView row = (DataRowView)e.Item.DataItem;
            int orderId = (int)row["OrderId"];

            // Find nested repeater
            Repeater rptItems = e.Item.FindControl("rptOrderItems") as Repeater;
            if (rptItems == null) return;

            DataTable items = DatabaseHelper.ExecuteQuery(
                @"SELECT oi.Quantity, oi.UnitPrice,
                         p.Name, p.ImageUrl,
                         CAST(oi.Quantity * oi.UnitPrice AS DECIMAL(10,2)) AS LineTotal
                  FROM OrderItems oi
                  INNER JOIN Products p ON oi.ProductId = p.ProductId
                  WHERE oi.OrderId = @id",
                new[] { new SqlParameter("@id", orderId) });

            rptItems.DataSource = items;
            rptItems.DataBind();
        }

        protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetail")
                Response.Redirect("~/Members/OrderConfirmation.aspx?id=" +
                    e.CommandArgument.ToString());
        }
    }
}