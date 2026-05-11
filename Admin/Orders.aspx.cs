using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest.Admin
{
    public partial class Orders : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string msg = Request.QueryString["msg"];
                if (msg == "updated") ShowSuccess("Order updated successfully.");
                LoadOrders();
            }
        }

        private void LoadOrders()
        {
            var where = new StringBuilder("WHERE 1=1");
            var params_ = new List<SqlParameter>();

            string search = txtSearch.Text.Trim();
            string status = ddlStatus.SelectedValue;
            string payStatus = ddlPayStatus.SelectedValue;

            if (!string.IsNullOrEmpty(search))
            {
                where.Append(" AND (CAST(o.OrderId AS NVARCHAR) LIKE @s " +
                             "OR u.Email LIKE @s OR cp.FullName LIKE @s)");
                params_.Add(new SqlParameter("@s", "%" + search + "%"));
            }
            if (!string.IsNullOrEmpty(status))
            {
                where.Append(" AND o.Status = @status");
                params_.Add(new SqlParameter("@status", status));
            }
            if (!string.IsNullOrEmpty(payStatus))
            {
                where.Append(" AND o.PaymentStatus = @payStatus");
                params_.Add(new SqlParameter("@payStatus", payStatus));
            }

            string sql = string.Format(
                @"SELECT o.OrderId, o.OrderDate, o.TotalAmount,
                         o.Status, o.PaymentMethod, o.PaymentStatus,
                         u.Email,
                         ISNULL(cp.FullName, u.Email) AS FullName
                  FROM Orders o
                  INNER JOIN AspNetUsers u ON o.UserId = u.Id
                  LEFT JOIN CustomerProfiles cp ON o.UserId = cp.UserId
                  {0}
                  ORDER BY o.OrderDate DESC", where);

            var dt = DatabaseHelper.ExecuteQuery(sql, params_.ToArray());
            gvOrders.DataSource = dt;
            gvOrders.DataBind();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadOrders();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatus.SelectedIndex = 0;
            ddlPayStatus.SelectedIndex = 0;
            LoadOrders();
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Handled via link to OrderDetail page
        }

        private void ShowSuccess(string msg)
        {
            pnlSuccess.Visible = true;
            litSuccess.Text = msg;
        }
    }
}