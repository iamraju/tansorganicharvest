using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest.Admin
{
    public partial class FAQ : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadFAQ();
        }

        private void LoadFAQ()
        {
            var dt = DatabaseHelper.ExecuteQuery(
                @"SELECT FAQId, Question, Answer, SortOrder, IsActive
                  FROM FAQ ORDER BY SortOrder, FAQId");
            gvFAQ.DataSource = dt;
            gvFAQ.DataBind();
        }

        protected void btnShowAdd_Click(object sender, EventArgs e)
        {
            ClearForm();
            litFormTitle.Text = "Add FAQ";
            pnlForm.Visible = true;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int faqId = int.Parse(hfFAQId.Value);
            string admin = AdminAuth.GetUsername();
            int sort = 0;
            int.TryParse(txtSortOrder.Text, out sort);

            if (faqId == 0)
            {
                DatabaseHelper.ExecuteNonQuery(
                    @"INSERT INTO FAQ
                        (Question, Answer, SortOrder, IsActive, CreatedBy)
                      VALUES
                        (@q, @a, @sort, @active, @by)",
                    new[]
                    {
                        new SqlParameter("@q",      txtQuestion.Text.Trim()),
                        new SqlParameter("@a",      txtAnswer.Text.Trim()),
                        new SqlParameter("@sort",   sort),
                        new SqlParameter("@active", chkIsActive.Checked),
                        new SqlParameter("@by",     admin)
                    });
                ShowSuccess("FAQ added.");
            }
            else
            {
                DatabaseHelper.ExecuteNonQuery(
                    @"UPDATE FAQ SET
                        Question  = @q,
                        Answer    = @a,
                        SortOrder = @sort,
                        IsActive  = @active,
                        UpdatedAt = GETDATE(),
                        UpdatedBy = @by
                      WHERE FAQId = @id",
                    new[]
                    {
                        new SqlParameter("@q",      txtQuestion.Text.Trim()),
                        new SqlParameter("@a",      txtAnswer.Text.Trim()),
                        new SqlParameter("@sort",   sort),
                        new SqlParameter("@active", chkIsActive.Checked),
                        new SqlParameter("@by",     admin),
                        new SqlParameter("@id",     faqId)
                    });
                ShowSuccess("FAQ updated.");
            }

            pnlForm.Visible = false;
            ClearForm();
            LoadFAQ();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = false;
            ClearForm();
        }

        protected void gvFAQ_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int faqId = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditRow")
            {
                var dt = DatabaseHelper.ExecuteQuery(
                    "SELECT * FROM FAQ WHERE FAQId = @id",
                    new[] { new SqlParameter("@id", faqId) });

                if (dt.Rows.Count == 0) return;
                DataRow row = dt.Rows[0];

                hfFAQId.Value = faqId.ToString();
                txtQuestion.Text = row["Question"].ToString();
                txtAnswer.Text = row["Answer"].ToString();
                txtSortOrder.Text = row["SortOrder"].ToString();
                chkIsActive.Checked = (bool)row["IsActive"];
                litFormTitle.Text = "Edit FAQ";
                pnlForm.Visible = true;
            }
            else if (e.CommandName == "DeleteRow")
            {
                DatabaseHelper.ExecuteNonQuery(
                    "DELETE FROM FAQ WHERE FAQId = @id",
                    new[] { new SqlParameter("@id", faqId) });
                ShowSuccess("FAQ deleted.");
                LoadFAQ();
            }
        }

        private void ClearForm()
        {
            hfFAQId.Value = "0";
            txtQuestion.Text = "";
            txtAnswer.Text = "";
            txtSortOrder.Text = "0";
            chkIsActive.Checked = true;
        }

        private void ShowSuccess(string msg)
        {
            pnlSuccess.Visible = true;
            litSuccess.Text = msg;
        }
    }
}