using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class Reports : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Default: current month
                txtFrom.Text = new DateTime(DateTime.Now.Year,
                    DateTime.Now.Month, 1).ToString("yyyy-MM-dd");
                txtTo.Text = DateTime.Now.ToString("yyyy-MM-dd");
                LoadReports();
            }
        }

        private void LoadReports()
        {
            DateTime from = string.IsNullOrEmpty(txtFrom.Text)
                ? DateTime.MinValue
                : DateTime.Parse(txtFrom.Text);
            DateTime to = string.IsNullOrEmpty(txtTo.Text)
                ? DateTime.MaxValue
                : DateTime.Parse(txtTo.Text).AddDays(1).AddSeconds(-1);

            SqlParameter[] dateParams = new[]
            {
                new SqlParameter("@from", from),
                new SqlParameter("@to",   to)
            };

            // Revenue & order count
            DataTable dtKpi = DatabaseHelper.ExecuteQuery(
                @"SELECT
                    ISNULL(SUM(CASE WHEN PaymentStatus='Paid'
                        THEN TotalAmount ELSE 0 END), 0) AS Revenue,
                    COUNT(*) AS TotalOrders,
                    SUM(CASE WHEN PaymentStatus='Paid' THEN 1 ELSE 0 END)
                        AS PaidOrders,
                    ISNULL(AVG(TotalAmount), 0) AS AvgOrder,
                    SUM(CASE WHEN Status='Pending' THEN 1 ELSE 0 END)
                        AS Pending
                  FROM Orders
                  WHERE OrderDate BETWEEN @from AND @to", dateParams);

            if (dtKpi.Rows.Count > 0)
            {
                DataRow kpi = dtKpi.Rows[0];
                litRevenue.Text = ((decimal)kpi["Revenue"]).ToString("F2");
                litTotalOrders.Text = kpi["TotalOrders"].ToString();
                litPaidOrders.Text = kpi["PaidOrders"].ToString();
                litAvgOrder.Text = ((decimal)kpi["AvgOrder"]).ToString("F2");
                litPending.Text = kpi["Pending"].ToString();
            }

            // New customers in period
            object newCust = DatabaseHelper.ExecuteScalar(
                @"SELECT COUNT(*) FROM CustomerProfiles
                  WHERE CreatedAt BETWEEN @from AND @to", dateParams);
            litNewCustomers.Text = newCust != null ? newCust.ToString() : "0";

            // Top products
            DataTable dtTop = DatabaseHelper.ExecuteQuery(
                @"SELECT TOP 10 p.Name,
                         SUM(oi.Quantity) AS TotalQty,
                         SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
                  FROM OrderItems oi
                  INNER JOIN Products p  ON oi.ProductId = p.ProductId
                  INNER JOIN Orders   o  ON oi.OrderId   = o.OrderId
                  WHERE o.OrderDate BETWEEN @from AND @to
                  GROUP BY p.ProductId, p.Name
                  ORDER BY TotalRevenue DESC", dateParams);
            gvTopProducts.DataSource = dtTop;
            gvTopProducts.DataBind();

            // By category
            DataTable dtCat = DatabaseHelper.ExecuteQuery(
                @"SELECT c.Name AS CategoryName,
                         COUNT(DISTINCT o.OrderId) AS OrderCount,
                         SUM(oi.Quantity * oi.UnitPrice) AS Revenue
                  FROM OrderItems oi
                  INNER JOIN Products    p ON oi.ProductId  = p.ProductId
                  INNER JOIN Categories  c ON p.CategoryId  = c.CategoryId
                  INNER JOIN Orders      o ON oi.OrderId    = o.OrderId
                  WHERE o.OrderDate BETWEEN @from AND @to
                  GROUP BY c.CategoryId, c.Name
                  ORDER BY Revenue DESC", dateParams);
            gvByCategory.DataSource = dtCat;
            gvByCategory.DataBind();

            // Orders by status
            DataTable dtStatus = DatabaseHelper.ExecuteQuery(
                @"SELECT Status, COUNT(*) AS Count
                  FROM Orders
                  WHERE OrderDate BETWEEN @from AND @to
                  GROUP BY Status
                  ORDER BY Count DESC", dateParams);
            rptByStatus.DataSource = dtStatus;
            rptByStatus.DataBind();

            // Low stock
            DataTable dtLow = DatabaseHelper.ExecuteQuery(
                @"SELECT p.ProductId, p.Name, p.Stock,
                         c.Name AS CategoryName
                  FROM Products p
                  INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                  WHERE p.Stock <= 10 AND p.IsActive = 1
                  ORDER BY p.Stock ASC");
            gvLowStock.DataSource = dtLow;
            gvLowStock.DataBind();
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            LoadReports();
        }

        protected void btnAllTime_Click(object sender, EventArgs e)
        {
            txtFrom.Text = "";
            txtTo.Text = "";
            LoadReports();
        }
    }
}