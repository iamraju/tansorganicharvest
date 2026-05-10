using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest.Admin
{
    public partial class Products : Page
    {
        // ── Pagination state stored in ViewState ──────────────────
        private int CurrentPage
        {
            get => ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1;
            set => ViewState["CurrentPage"] = value;
        }
        private int PageSize
        {
            get => ViewState["PageSize"] != null ? (int)ViewState["PageSize"] : 25;
            set => ViewState["PageSize"] = value;
        }
        private int TotalRecords
        {
            get => ViewState["TotalRecords"] != null ? (int)ViewState["TotalRecords"] : 0;
            set => ViewState["TotalRecords"] = value;
        }
        private int TotalPages => (int)Math.Ceiling((double)TotalRecords / PageSize);

        // ── Page Load ─────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string msg = Request.QueryString["msg"];
                if (msg == "added") ShowSuccess("Product added successfully.");
                if (msg == "updated") ShowSuccess("Product updated successfully.");
                if (msg == "deleted") ShowSuccess("Product deleted successfully.");

                LoadCategories();
                PageSize = int.Parse(ddlPageSize.SelectedValue);
                LoadProducts();
            }
        }

        // ── Load category dropdown ─────────────────────────────────
        private void LoadCategories()
        {
            var dt = DatabaseHelper.ExecuteQuery(
                "SELECT CategoryId, Name FROM Categories " +
                "WHERE IsActive = 1 ORDER BY SortOrder, Name");

            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new ListItem("All Categories", ""));
            foreach (DataRow row in dt.Rows)
                ddlCategory.Items.Add(
                    new ListItem(row["Name"].ToString(), row["CategoryId"].ToString()));
        }

        // ── Core load with filters + pagination ───────────────────
        private void LoadProducts()
        {
            // Build WHERE clause dynamically
            var where = new StringBuilder("WHERE 1=1");
            var params_ = new List<SqlParameter>();

            string search = txtSearch.Text.Trim();
            string categoryId = ddlCategory.SelectedValue;
            string status = ddlStatus.SelectedValue;
            string featured = ddlFeatured.SelectedValue;

            if (!string.IsNullOrEmpty(search))
            {
                where.Append(" AND p.Name LIKE @search");
                params_.Add(new SqlParameter("@search", "%" + search + "%"));
            }
            if (!string.IsNullOrEmpty(categoryId))
            {
                where.Append(" AND p.CategoryId = @catId");
                params_.Add(new SqlParameter("@catId", int.Parse(categoryId)));
            }
            if (!string.IsNullOrEmpty(status))
            {
                where.Append(" AND p.IsActive = @status");
                params_.Add(new SqlParameter("@status", int.Parse(status)));
            }
            if (!string.IsNullOrEmpty(featured))
            {
                where.Append(" AND p.IsFeatured = @featured");
                params_.Add(new SqlParameter("@featured", int.Parse(featured)));
            }

            // Total count for pagination
            string countSql = $@"SELECT COUNT(*) FROM Products p 
                                  INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                                  {where}";
            TotalRecords = (int)DatabaseHelper.ExecuteScalar(countSql, params_.ToArray());

            // Clamp current page
            if (CurrentPage > TotalPages && TotalPages > 0) CurrentPage = TotalPages;
            if (CurrentPage < 1) CurrentPage = 1;

            int offset = (CurrentPage - 1) * PageSize;

            // Paged data query
            string dataSql = $@"
                SELECT p.ProductId, p.Name, p.Price, p.Unit, p.Stock,
                       p.ImageUrl, p.IsFeatured, p.IsActive,
                       c.Name AS CategoryName
                FROM Products p
                INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                {where}
                ORDER BY p.CreatedAt DESC
                OFFSET {offset} ROWS FETCH NEXT {PageSize} ROWS ONLY";

            var dt = DatabaseHelper.ExecuteQuery(dataSql, params_.ToArray());
            gvProducts.DataSource = dt;
            gvProducts.DataBind();

            UpdatePaginationUI();
        }

        // ── Pagination UI ─────────────────────────────────────────
        private void UpdatePaginationUI()
        {
            int from = TotalRecords == 0 ? 0 : (CurrentPage - 1) * PageSize + 1;
            int to = Math.Min(CurrentPage * PageSize, TotalRecords);

            litFrom.Text = from.ToString();
            litTo.Text = to.ToString();
            litTotal.Text = TotalRecords.ToString();
            litCurrentPage.Text = CurrentPage.ToString();
            litTotalPages.Text = TotalPages.ToString();

            btnFirst.Enabled = btnPrev.Enabled = CurrentPage > 1;
            btnNext.Enabled = btnLast.Enabled = CurrentPage < TotalPages;

            // Build numbered page buttons
            phPageNumbers.Controls.Clear();
            int startPage = Math.Max(1, CurrentPage - 2);
            int endPage = Math.Min(TotalPages, CurrentPage + 2);

            for (int i = startPage; i <= endPage; i++)
            {
                if (i == CurrentPage)
                {
                    // Current page — highlighted, not clickable
                    var span = new System.Web.UI.HtmlControls.HtmlGenericControl("span");
                    span.Attributes["class"] =
                        "px-3 py-1.5 text-xs border border-[#2d6a4f] rounded-md " +
                        "bg-[#2d6a4f] text-white font-semibold";
                    span.InnerText = i.ToString();
                    phPageNumbers.Controls.Add(span);
                }
                else
                {
                    var btn = new LinkButton
                    {
                        Text = i.ToString(),
                        CommandName = "Page",
                        CommandArgument = i.ToString(),
                        CssClass = "px-3 py-1.5 text-xs border border-gray-300 " +
                                      "rounded-md hover:bg-gray-50 text-gray-600"
                    };
                    btn.Click += btnPager_Click;
                    phPageNumbers.Controls.Add(btn);
                }
            }
        }

        // ── Pager button click ────────────────────────────────────
        protected void btnPager_Click(object sender, EventArgs e)
        {
            var btn = (LinkButton)sender;
            switch (btn.CommandName)
            {
                case "First": CurrentPage = 1; break;
                case "Prev": CurrentPage = Math.Max(1, CurrentPage - 1); break;
                case "Next": CurrentPage = Math.Min(TotalPages, CurrentPage + 1); break;
                case "Last": CurrentPage = TotalPages; break;
                case "Page": CurrentPage = int.Parse(btn.CommandArgument); break;
            }
            LoadProducts();
        }

        // ── Filter buttons ────────────────────────────────────────
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            CurrentPage = 1; // reset to first page on filter
            LoadProducts();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlCategory.SelectedIndex = 0;
            ddlStatus.SelectedIndex = 0;
            ddlFeatured.SelectedIndex = 0;
            CurrentPage = 1;
            LoadProducts();
        }

        // ── Page size changed ─────────────────────────────────────
        protected void ddlPageSize_Changed(object sender, EventArgs e)
        {
            PageSize = int.Parse(ddlPageSize.SelectedValue);
            CurrentPage = 1;
            LoadProducts();
        }

        // ── GridView row commands ─────────────────────────────────
        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "DeleteRow") return;

            int id = int.Parse(e.CommandArgument.ToString());

            // Check if product is in any order
            object count = DatabaseHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM OrderItems WHERE ProductId = @id",
                new[] { new SqlParameter("@id", id) });

            if (count != null && (int)count > 0)
            {
                ShowError("Cannot delete — this product exists in orders. " +
                          "Set it to Inactive instead.");
                return;
            }

            // Delete image from disk
            var dt = DatabaseHelper.ExecuteQuery(
                "SELECT ImageUrl FROM Products WHERE ProductId = @id",
                new[] { new SqlParameter("@id", id) });

            if (dt.Rows.Count > 0)
                DeleteImageFile(dt.Rows[0]["ImageUrl"]?.ToString());

            // Remove from cart first (FK constraint)
            DatabaseHelper.ExecuteNonQuery(
                "DELETE FROM Cart WHERE ProductId = @id",
                new[] { new SqlParameter("@id", id) });

            DatabaseHelper.ExecuteNonQuery(
                "DELETE FROM Products WHERE ProductId = @id",
                new[] { new SqlParameter("@id", id) });

            Response.Redirect("Products.aspx?msg=deleted");
        }

        // ── Helpers ───────────────────────────────────────────────
        protected string GetImageUrl(object imageUrl)
        {
            string url = imageUrl?.ToString();
            return string.IsNullOrEmpty(url) ? "/Images/placeholder.png" : "/" + url;
        }

        protected string GetStockCss(int stock)
        {
            if (stock <= 0) return "bg-red-100 text-red-700 text-xs px-2 py-1 rounded-full font-medium";
            if (stock <= 10) return "bg-yellow-100 text-yellow-700 text-xs px-2 py-1 rounded-full font-medium";
            return "bg-green-100 text-green-700 text-xs px-2 py-1 rounded-full font-medium";
        }

        private void DeleteImageFile(string relativePath)
        {
            if (string.IsNullOrEmpty(relativePath)) return;
            try
            {
                string full = Server.MapPath("~/" + relativePath);
                if (System.IO.File.Exists(full)) System.IO.File.Delete(full);
            }
            catch { }
        }

        private void ShowSuccess(string msg) { pnlSuccess.Visible = true; litSuccess.Text = msg; }
        private void ShowError(string msg) { pnlError.Visible = true; litError.Text = msg; }
    }
}