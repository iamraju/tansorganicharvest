using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Admin
{
    public partial class Customers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadCustomers();
        }

        private void LoadCustomers(string search = null)
        {
            string where = "WHERE 1=1";
            var params_ = new System.Collections.Generic.List<SqlParameter>();

            if (!string.IsNullOrEmpty(search))
            {
                where += " AND (cp.FullName LIKE @s OR u.Email LIKE @s)";
                params_.Add(new SqlParameter("@s", "%" + search + "%"));
            }

            string sql = string.Format(
                @"SELECT cp.ProfileId,
                         ISNULL(cp.FullName, u.Email) AS FullName,
                         u.Email, cp.Phone, cp.City, cp.PostalCode,
                         cp.CreatedAt AS JoinedAt,
                         COUNT(o.OrderId)             AS OrderCount,
                         ISNULL(SUM(o.TotalAmount),0) AS TotalSpent
                  FROM CustomerProfiles cp
                  INNER JOIN AspNetUsers u ON cp.UserId = u.Id
                  LEFT  JOIN Orders o     ON cp.UserId = o.UserId
                  {0}
                  GROUP BY cp.ProfileId, cp.FullName, u.Email,
                           cp.Phone, cp.City, cp.PostalCode, cp.CreatedAt
                  ORDER BY cp.CreatedAt DESC", where);

            var dt = DatabaseHelper.ExecuteQuery(sql, params_.ToArray());

            object total = DatabaseHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM CustomerProfiles");
            litTotal.Text = total != null ? total.ToString() : "0";

            gvCustomers.DataSource = dt;
            gvCustomers.DataBind();
        }

        protected string GetInitial(object fullName, object email)
        {
            string name = fullName != null ? fullName.ToString() : "";
            if (string.IsNullOrEmpty(name))
                name = email != null ? email.ToString() : "?";
            return name.Length > 0 ? name[0].ToString().ToUpper() : "?";
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadCustomers(txtSearch.Text.Trim());
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            LoadCustomers();
        }
    }
}