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
            get
            {
                if (ViewState["Page"] != null) return (int)ViewState["Page"];
                int page = 1;
                if (!string.IsNullOrEmpty(Request.QueryString["page"]))
                    int.TryParse(Request.QueryString["page"], out page);
                return page;
            }
            set { ViewState["Page"] = value; }
        }

        private int PageSize
        {
            get
            {
                if (ViewState["Size"] != null) return (int)ViewState["Size"];
                int size = 12;
                if (!string.IsNullOrEmpty(Request.QueryString["size"]))
                    int.TryParse(Request.QueryString["size"], out size);
                return size;
            }
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

        private int SelectedCategoryId
        {
            get
            {
                if (ViewState["SelCatId"] != null) return (int)ViewState["SelCatId"];
                int catId = 0;
                if (!string.IsNullOrEmpty(Request.QueryString["catId"]))
                    int.TryParse(Request.QueryString["catId"], out catId);
                return catId;
            }
            set { ViewState["SelCatId"] = value; }
        }

        private string SearchTerm
        {
            get
            {
                if (ViewState["SearchTerm"] != null) return ViewState["SearchTerm"].ToString();
                return Request.QueryString["search"] ?? "";
            }
            set { ViewState["SearchTerm"] = value; }
        }

        private string SortBy
        {
            get
            {
                if (ViewState["SortBy"] != null) return ViewState["SortBy"].ToString();
                return Request.QueryString["sort"] ?? "newest";
            }
            set { ViewState["SortBy"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Load values from query string
                LoadFiltersFromQueryString();

                // Set UI controls from values
                SetUIControls();

                // Load data
                LoadCategoryFilters();
                LoadProducts();
            }
        }

        private void LoadFiltersFromQueryString()
        {
            // Category filter
            if (!string.IsNullOrEmpty(Request.QueryString["catId"]))
            {
                int.TryParse(Request.QueryString["catId"], out int catId);
                SelectedCategoryId = catId;
            }

            // Search term
            if (!string.IsNullOrEmpty(Request.QueryString["search"]))
            {
                SearchTerm = Request.QueryString["search"];
            }

            // Sort by
            if (!string.IsNullOrEmpty(Request.QueryString["sort"]))
            {
                SortBy = Request.QueryString["sort"];
            }

            // Page
            if (!string.IsNullOrEmpty(Request.QueryString["page"]))
            {
                int.TryParse(Request.QueryString["page"], out int page);
                CurrentPage = page;
            }

            // Page size
            if (!string.IsNullOrEmpty(Request.QueryString["size"]))
            {
                int.TryParse(Request.QueryString["size"], out int size);
                PageSize = size;
            }
        }

        private void SetUIControls()
        {
            // Set search textbox
            txtSearch.Text = SearchTerm;

            // Set sort dropdown
            if (!string.IsNullOrEmpty(SortBy))
            {
                ListItem item = ddlSort.Items.FindByValue(SortBy);
                if (item != null)
                    ddlSort.SelectedValue = SortBy;
            }

            // Set page size dropdown
            ddlPageSize.SelectedValue = PageSize.ToString();
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
                  ORDER BY c.SortOrder",
                null);

            rptCategoryFilters.DataSource = dt;
            rptCategoryFilters.DataBind();
        }

        private void LoadProducts()
        {
            var where = new StringBuilder("WHERE p.IsActive = 1");
            var paramList = new List<SqlParameter>();

            // Search filter
            if (!string.IsNullOrEmpty(SearchTerm))
            {
                where.Append(" AND (p.Name LIKE @search OR p.Description LIKE @search)");
                paramList.Add(new SqlParameter("@search", "%" + SearchTerm + "%"));
            }

            // Category filter
            if (SelectedCategoryId > 0)
            {
                where.Append(" AND p.CategoryId = @catId");
                paramList.Add(new SqlParameter("@catId", SelectedCategoryId));
            }

            // Convert to array for parameter cloning
            SqlParameter[] parameters = paramList.ToArray();

            // Total count query
            string countSql = string.Format(
                "SELECT COUNT(*) FROM Products p {0}", where);

            SqlParameter[] countParams = CloneParameters(parameters);
            TotalRecords = (int)DatabaseHelper.ExecuteScalar(countSql, countParams);
            litCount.Text = TotalRecords.ToString();

            if (CurrentPage > TotalPages && TotalPages > 0) CurrentPage = TotalPages;
            if (CurrentPage < 1) CurrentPage = 1;
            int offset = (CurrentPage - 1) * PageSize;

            // Sort logic
            string orderBy;
            if (SortBy == "price_asc") orderBy = "p.Price ASC";
            else if (SortBy == "price_desc") orderBy = "p.Price DESC";
            else if (SortBy == "name_asc") orderBy = "p.Name ASC";
            else orderBy = "p.CreatedAt DESC";

            string dataSql = string.Format(
                @"SELECT p.ProductId, p.Name, p.Description, p.Price, p.Unit,
                         p.ImageUrl, p.IsFeatured, p.Stock,
                         c.Name AS CategoryName
                  FROM Products p
                  INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                  {0}
                  ORDER BY {1}
                  OFFSET {2} ROWS FETCH NEXT {3} ROWS ONLY",
                where, orderBy, offset, PageSize);

            // Create fresh parameters for data query
            SqlParameter[] dataParams = CloneParameters(parameters);
            DataTable dt = DatabaseHelper.ExecuteQuery(dataSql, dataParams);

            // Bind to Repeater
            rptProducts.DataSource = dt;
            rptProducts.DataBind();

            // Show/hide empty state
            pnlEmpty.Visible = dt.Rows.Count == 0;
            rptProducts.Visible = dt.Rows.Count > 0;

            // Update count display
            litCount.Text = TotalRecords.ToString();
            int from = TotalRecords == 0 ? 0 : (CurrentPage - 1) * PageSize + 1;
            int to = Math.Min(CurrentPage * PageSize, TotalRecords);
            litFrom.Text = from.ToString();
            litTo.Text = to.ToString();

            BuildPagination();
        }

        private string BuildFilterUrl()
        {
            var parameters = new List<string>();

            if (SelectedCategoryId > 0)
                parameters.Add($"catId={SelectedCategoryId}");

            if (!string.IsNullOrEmpty(SearchTerm))
                parameters.Add($"search={Server.UrlEncode(SearchTerm)}");

            if (!string.IsNullOrEmpty(SortBy) && SortBy != "newest")
                parameters.Add($"sort={SortBy}");

            if (CurrentPage > 1)
                parameters.Add($"page={CurrentPage}");

            if (PageSize != 12)
                parameters.Add($"size={PageSize}");

            if (parameters.Count == 0)
                return "Shop.aspx";

            return "Shop.aspx?" + string.Join("&", parameters);
        }

        private SqlParameter[] CloneParameters(SqlParameter[] original)
        {
            if (original == null || original.Length == 0) return null;

            SqlParameter[] clone = new SqlParameter[original.Length];
            for (int i = 0; i < original.Length; i++)
            {
                clone[i] = new SqlParameter(original[i].ParameterName, original[i].Value);
                if (original[i].DbType != System.Data.DbType.Object)
                    clone[i].DbType = original[i].DbType;
                if (original[i].Size > 0)
                    clone[i].Size = original[i].Size;
            }
            return clone;
        }

        protected void rptCategoryFilters_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "FilterCat")
            {
                int catId = 0;
                if (int.TryParse(e.CommandArgument.ToString(), out catId))
                {
                    // If clicking the same category, clear the filter
                    if (SelectedCategoryId == catId)
                        catId = 0;

                    SelectedCategoryId = catId;
                }

                // Reset to page 1
                CurrentPage = 1;

                // Redirect with GET parameters
                Response.Redirect(BuildFilterUrl());
            }
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Not currently used but required by OnItemCommand
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

            // Redirect with GET parameters
            Response.Redirect(BuildFilterUrl());
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            // Update search term from textbox
            SearchTerm = txtSearch.Text.Trim();
            CurrentPage = 1;

            // Redirect with GET parameters
            Response.Redirect(BuildFilterUrl());
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            // Clear all filters and redirect to clean URL
            Response.Redirect("Shop.aspx");
        }

        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            SortBy = ddlSort.SelectedValue;
            CurrentPage = 1;

            // Redirect with GET parameters
            Response.Redirect(BuildFilterUrl());
        }

        protected void ddlPageSize_Changed(object sender, EventArgs e)
        {
            PageSize = int.Parse(ddlPageSize.SelectedValue);
            CurrentPage = 1;

            // Redirect with GET parameters
            Response.Redirect(BuildFilterUrl());
        }

        protected string GetCategoryButtonClass(string categoryId)
        {
            if (SelectedCategoryId > 0 && SelectedCategoryId.ToString() == categoryId)
            {
                return "w-full flex items-center justify-between px-3 py-2 rounded-lg text-sm bg-forest/10 text-forest font-medium transition-colors text-left";
            }
            return "w-full flex items-center justify-between px-3 py-2 rounded-lg text-sm text-gray-600 hover:bg-sage/10 hover:text-forest transition-colors text-left";
        }
    }
}