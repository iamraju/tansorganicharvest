using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TansOrganicHarvest.Admin
{
    public partial class Feedback : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadFeedback();
        }

        private void LoadFeedback()
        {
            // Unread count
            object unread = DatabaseHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Feedback WHERE IsRead = 0");
            litUnreadCount.Text = unread != null ? unread.ToString() : "0";

            var where = new StringBuilder("WHERE 1=1");
            var params_ = new List<SqlParameter>();

            string status = ddlStatus.SelectedValue;
            string category = ddlCategory.SelectedValue;

            if (!string.IsNullOrEmpty(status))
            {
                where.Append(" AND IsRead = @read");
                params_.Add(new SqlParameter("@read", int.Parse(status)));
            }
            if (!string.IsNullOrEmpty(category))
            {
                where.Append(" AND Category = @cat");
                params_.Add(new SqlParameter("@cat", category));
            }

            string sql = string.Format(
                @"SELECT FeedbackId, Name, Email, Subject, Message,
                         Category, IsRead, AdminReply, CreatedAt
                  FROM Feedback {0}
                  ORDER BY IsRead ASC, CreatedAt DESC", where);

            var dt = DatabaseHelper.ExecuteQuery(sql, params_.ToArray());
            rptFeedback.DataSource = dt;
            rptFeedback.DataBind();
        }

        protected void rptFeedback_ItemCommand(object source,
            RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "MarkRead":
                    int fid = int.Parse(e.CommandArgument.ToString());
                    DatabaseHelper.ExecuteNonQuery(
                        "UPDATE Feedback SET IsRead = 1 WHERE FeedbackId = @id",
                        new[] { new SqlParameter("@id", fid) });
                    ShowSuccess("Marked as read.");
                    break;

                case "DeleteFeedback":
                    int did = int.Parse(e.CommandArgument.ToString());
                    DatabaseHelper.ExecuteNonQuery(
                        "DELETE FROM Feedback WHERE FeedbackId = @id",
                        new[] { new SqlParameter("@id", did) });
                    ShowSuccess("Feedback deleted.");
                    break;

                case "OpenReply":
                    // Format: FeedbackId|Name|Email
                    string[] parts = e.CommandArgument.ToString().Split('|');
                    if (parts.Length >= 3)
                    {
                        hfFeedbackId.Value = parts[0];
                        // Open modal via JS
                        string script = string.Format(
                            "openReplyModal('{0}','{1}','{2}');",
                            parts[0],
                            parts[1].Replace("'", "\\'"),
                            parts[2].Replace("'", "\\'"));
                        ScriptManager.RegisterStartupScript(
                            this, GetType(), "openReply", script, true);

                        // Mark as read when opened
                        DatabaseHelper.ExecuteNonQuery(
                            "UPDATE Feedback SET IsRead = 1 WHERE FeedbackId = @id",
                            new[] { new SqlParameter("@id", int.Parse(parts[0])) });
                    }
                    break;
            }

            LoadFeedback();
        }

        protected void btnSendReply_Click(object sender, EventArgs e)
        {
            int fid = int.Parse(hfFeedbackId.Value);
            if (fid == 0 || string.IsNullOrEmpty(txtReply.Text.Trim()))
                return;

            DatabaseHelper.ExecuteNonQuery(
                @"UPDATE Feedback SET
                    AdminReply = @reply,
                    IsRead     = 1,
                    UpdatedAt  = GETDATE(),
                    UpdatedBy  = @by
                  WHERE FeedbackId = @id",
                new[]
                {
                    new SqlParameter("@reply", txtReply.Text.Trim()),
                    new SqlParameter("@by",    AdminAuth.GetUsername()),
                    new SqlParameter("@id",    fid)
                });

            txtReply.Text = "";
            ShowSuccess("Reply saved successfully.");
            LoadFeedback();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadFeedback();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlStatus.SelectedIndex = 0;
            ddlCategory.SelectedIndex = 0;
            LoadFeedback();
        }

        private void ShowSuccess(string msg)
        {
            pnlSuccess.Visible = true;
            litSuccess.Text = msg;
        }
    }
}