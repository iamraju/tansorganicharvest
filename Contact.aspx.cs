using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                DatabaseHelper.ExecuteNonQuery(
                    @"INSERT INTO Feedback
                        (Name, Email, Subject, Message, Category, CreatedBy)
                      VALUES
                        (@name, @email, @subject, @message, @category, @by)",
                    new[]
                    {
                        new SqlParameter("@name",     txtName.Text.Trim()),
                        new SqlParameter("@email",    txtEmail.Text.Trim()),
                        new SqlParameter("@subject",  txtSubject.Text.Trim()),
                        new SqlParameter("@message",  txtMessage.Text.Trim()),
                        new SqlParameter("@category", ddlCategory.SelectedValue),
                        new SqlParameter("@by",       txtEmail.Text.Trim())
                    });

                // Show success, hide form
                pnlSuccess.Visible = true;
                pnlForm.Visible = false;
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Could not send message: " + ex.Message;
            }
        }
    }
}