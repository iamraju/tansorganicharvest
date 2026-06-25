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
            // Safe parsing - handle empty or invalid dates
            DateTime from;
            DateTime to;

            if (string.IsNullOrEmpty(txtFrom.Text))
            {
                // Use a very old date for "all time"
                from = new DateTime(2000, 1, 1); // Or use DateTime.MinValue with adjustment
            }
            else
            {
                from = DateTime.Parse(txtFrom.Text);
            }

            if (string.IsNullOrEmpty(txtTo.Text))
            {
                // Use today's date for "all time"
                to = DateTime.Now;
            }
            else
            {
                to = DateTime.Parse(txtTo.Text).AddDays(1).AddSeconds(-1);
            }

            // Alternative: Use SQL MIN/MAX dates
            // from = DateTime.MinValue; // This will cause error with SQL
            // So we use a reasonable "all time" start date

            // Create date parameters for KPI query
            SqlParameter[] dateParamsKpi = new[]
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
                  WHERE OrderDate BETWEEN @from AND @to", dateParamsKpi);

            if (dtKpi.Rows.Count > 0)
            {
                DataRow kpi = dtKpi.Rows[0];
                litRevenue.Text = ((decimal)kpi["Revenue"]).ToString("F2");
                litTotalOrders.Text = kpi["TotalOrders"].ToString();
                litPaidOrders.Text = kpi["PaidOrders"].ToString();
                litAvgOrder.Text = ((decimal)kpi["AvgOrder"]).ToString("F2");
                litPending.Text = kpi["Pending"].ToString();
            }

            // New customers in period - create fresh parameters
            SqlParameter[] dateParamsNewCust = new[]
            {
                new SqlParameter("@from", from),
                new SqlParameter("@to",   to)
            };
            object newCust = DatabaseHelper.ExecuteScalar(
                @"SELECT COUNT(*) FROM CustomerProfiles
                  WHERE CreatedAt BETWEEN @from AND @to", dateParamsNewCust);
            litNewCustomers.Text = newCust != null ? newCust.ToString() : "0";

            // Top products - create fresh parameters
            SqlParameter[] dateParamsTop = new[]
            {
                new SqlParameter("@from", from),
                new SqlParameter("@to",   to)
            };
            DataTable dtTop = DatabaseHelper.ExecuteQuery(
                @"SELECT TOP 10 p.Name,
                         SUM(oi.Quantity) AS TotalQty,
                         SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
                  FROM OrderItems oi
                  INNER JOIN Products p  ON oi.ProductId = p.ProductId
                  INNER JOIN Orders   o  ON oi.OrderId   = o.OrderId
                  WHERE o.OrderDate BETWEEN @from AND @to
                  GROUP BY p.ProductId, p.Name
                  ORDER BY TotalRevenue DESC", dateParamsTop);
            gvTopProducts.DataSource = dtTop;
            gvTopProducts.DataBind();

            // By category - create fresh parameters
            SqlParameter[] dateParamsCat = new[]
            {
                new SqlParameter("@from", from),
                new SqlParameter("@to",   to)
            };
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
                  ORDER BY Revenue DESC", dateParamsCat);
            gvByCategory.DataSource = dtCat;
            gvByCategory.DataBind();

            // Orders by status - create fresh parameters
            SqlParameter[] dateParamsStatus = new[]
            {
                new SqlParameter("@from", from),
                new SqlParameter("@to",   to)
            };
            DataTable dtStatus = DatabaseHelper.ExecuteQuery(
                @"SELECT Status, COUNT(*) AS Count
                  FROM Orders
                  WHERE OrderDate BETWEEN @from AND @to
                  GROUP BY Status
                  ORDER BY Count DESC", dateParamsStatus);
            rptByStatus.DataSource = dtStatus;
            rptByStatus.DataBind();

            // Low stock - no parameters needed
            DataTable dtLow = DatabaseHelper.ExecuteQuery(
                @"SELECT p.ProductId, p.Name, p.Stock,
                         c.Name AS CategoryName
                  FROM Products p
                  INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                  WHERE p.Stock <= 10 AND p.IsActive = 1
                  ORDER BY p.Stock ASC", null);
            gvLowStock.DataSource = dtLow;
            gvLowStock.DataBind();
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            // Validate dates before loading
            if (!string.IsNullOrEmpty(txtFrom.Text) && !string.IsNullOrEmpty(txtTo.Text))
            {
                try
                {
                    DateTime from = DateTime.Parse(txtFrom.Text);
                    DateTime to = DateTime.Parse(txtTo.Text);

                    if (to < from)
                    {
                        // Show error if date range is invalid
                        ClientScript.RegisterStartupScript(this.GetType(), "alert",
                            "alert('End date must be after start date.');", true);
                        return;
                    }
                }
                catch
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        "alert('Please enter valid dates.');", true);
                    return;
                }
            }

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