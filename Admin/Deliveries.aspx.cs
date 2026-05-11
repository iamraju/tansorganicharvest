using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class Deliveries : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadDeliveries();
        }

        private void LoadDeliveries()
        {
            var where = new StringBuilder("WHERE 1=1");
            var params_ = new List<SqlParameter>();

            string status = ddlStatus.SelectedValue;
            string option = ddlOption.SelectedValue;

            if (!string.IsNullOrEmpty(status))
            {
                where.Append(" AND d.Status = @status");
                params_.Add(new SqlParameter("@status", status));
            }
            if (!string.IsNullOrEmpty(option))
            {
                where.Append(" AND d.DeliveryOption = @option");
                params_.Add(new SqlParameter("@option", option));
            }

            string sql = string.Format(
                @"SELECT d.DeliveryId, d.OrderId, d.FullName, d.Phone,
                         d.Address, d.City, d.PostalCode,
                         d.DeliveryOption, d.PreferredDate, d.Status
                  FROM Deliveries d
                  {0}
                  ORDER BY d.PreferredDate ASC, d.Status ASC",
                where);

            var dt = DatabaseHelper.ExecuteQuery(sql, params_.ToArray());
            gvDeliveries.DataSource = dt;
            gvDeliveries.DataBind();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadDeliveries();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlStatus.SelectedIndex = 0;
            ddlOption.SelectedIndex = 0;
            LoadDeliveries();
        }
    }
}