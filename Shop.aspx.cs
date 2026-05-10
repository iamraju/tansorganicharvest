using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest
{
    public partial class Shop : Page
    {
        private int CurrentPage
        {
            get { return ViewState["Page"] != null ? (int)ViewState["Page"] : 1; }
            set { ViewState["Page"] = value; }
        }
        private int PageSize
        {
            get { return ViewState["Size"] != null ? (int)ViewState["Size"] : 12; }
            set { ViewState["Size"] = value; }
        }
        private int TotalRecords
        {
            get { return ViewState["Total"] != null ? (int)ViewState["Total"] : 0; }
            set { ViewState["Total"] = value; }
        }
        private int TotalPages
        {
            get { return (int)Math.Ceiling((double)TotalRecords / PageSize); }
        }
        private string SelectedCategory
        {
            get { return ViewState["SelCat"] != null ? ViewState["SelCat"].ToString() : ""; }
            set { ViewState["SelCat"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string catQs = Request.QueryString["cat"];
                if (!string.IsNullOrEmpty(catQs))
                    SelectedCategory = catQs;

                PageSize = int.Parse(ddlPageSize.SelectedValue);
                LoadCategoryFilters();
                LoadProducts();
            }
        }

        private void LoadCategoryFilters()
        {
            var dt = DatabaseHelper.ExecuteQuery(
                @"SELECT c.CategoryId, c.Name,
                         c.SortOrder,
                         COUNT(p.ProductId) AS ProductCount
                  FROM Categories c
                  LEFT JOIN Products p 
                       ON c.CategoryId = p.CategoryId AND p.IsActive = 1
                  WHERE c.IsActive = 1
                  GROUP BY c.CategoryId, c.Name, c.SortOrder
                  ORDER BY c.SortOrder");

            rptCategoryFilters.DataSource = dt;
            rptCategoryFilters.DataBind();
        }

        private void LoadProducts()
        {
            var where = new StringBuilder("WHERE p.IsActive = 1");
            var paramList = new List<SqlParameter>();

            string search = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(search))
            {
                where.Append(" AND (p.Name LIKE @search OR p.Description LIKE @search)");
                paramList.Add(new SqlParameter("@search", "%" + search + "%"));
            }
            if (!string.IsNullOrEmpty(SelectedCategory))
            {
                where.Append(" AND p.CategoryId = @cat");
                paramList.Add(new SqlParameter("@cat", SelectedCategory));
            }

            // Total count
            string countSql = string.Format(
                "SELECT COUNT(*) FROM Products p {0}", where);
            TotalRecords = (int)DatabaseHelper.ExecuteScalar(countSql, paramList.ToArray());
            litCount.Text = TotalRecords.ToString();

            if (CurrentPage > TotalPages && TotalPages > 0) CurrentPage = TotalPages;
            if (CurrentPage < 1) CurrentPage = 1;
            int offset = (CurrentPage - 1) * PageSize;

            // Sort — use if/else instead of switch expression (C# 7.3 compatible)
            string orderBy;
            string sortVal = ddlSort.SelectedValue;
            if (sortVal == "price_asc") orderBy = "p.Price ASC";
            else if (sortVal == "price_desc") orderBy = "p.Price DESC";
            else if (sortVal == "name_asc") orderBy = "p.Name ASC";
            else orderBy = "p.CreatedAt DESC";

            string dataSql = string.Format(
                @"SELECT p.ProductId, p.Name, p.Description, p.Price, p.Unit,
                         p.ImageUrl, p.IsFeatured, p.Stock, p.IsFeatured,
                         c.Name AS CategoryName
                  FROM Products p
                  INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                  {0}
                  ORDER BY {1}
                  OFFSET {2} ROWS FETCH NEXT {3} ROWS ONLY",
                where, orderBy, offset, PageSize);

            DataTable dt = DatabaseHelper.ExecuteQuery(dataSql, paramList.ToArray());
            dlProducts.DataSource = dt;
            dlProducts.DataBind();

            // Show/hide empty state
            pnlEmpty.Visible = dt.Rows.Count == 0;
            dlProducts.Visible = dt.Rows.Count > 0;

            BuildPagination();
        }

        private void BuildPagination()
        {
            phPages.Controls.Clear();
            btnPrev.Enabled = CurrentPage > 1;
            btnNext.Enabled = CurrentPage < TotalPages;

            int start = Math.Max(1, CurrentPage - 2);
            int end = Math.Min(TotalPages, CurrentPage + 2);

            for (int i = start; i <= end; i++)
            {
                if (i == CurrentPage)
                {
                    var span = new System.Web.UI.HtmlControls.HtmlGenericControl("span");
                    span.Attributes["class"] =
                        "px-4 py-2 bg-forest text-white rounded-xl text-sm font-semibold";
                    span.InnerText = i.ToString();
                    phPages.Controls.Add(span);
                }
                else
                {
                    var btn = new LinkButton
                    {
                        Text = i.ToString(),
                        CommandName = "Page",
                        CommandArgument = i.ToString(),
                        CssClass = "px-4 py-2 border border-gray-200 rounded-xl " +
                                          "text-sm text-gray-600 hover:bg-gray-50"
                    };
                    btn.Click += btnPager_Click;
                    phPages.Controls.Add(btn);
                }
            }
        }

        protected void btnPager_Click(object sender, EventArgs e)
        {
            var btn = (LinkButton)sender;
            switch (btn.CommandName)
            {
                case "Prev": CurrentPage = Math.Max(1, CurrentPage - 1); break;
                case "Next": CurrentPage = Math.Min(TotalPages, CurrentPage + 1); break;
                case "Page": CurrentPage = int.Parse(btn.CommandArgument); break;
            }
            LoadProducts();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            SelectedCategory = "";
            CurrentPage = 1;
            LoadProducts();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            SelectedCategory = "";
            CurrentPage = 1;
            ddlSort.SelectedIndex = 0;
            LoadProducts();
        }

        protected void ddlPageSize_Changed(object sender, EventArgs e)
        {
            PageSize = int.Parse(ddlPageSize.SelectedValue);
            CurrentPage = 1;
            LoadProducts();
        }
    }
}