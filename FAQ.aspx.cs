using System;
using System.Web.UI;

namespace TansOrganicHarvest
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
                @"SELECT FAQId, Question, Answer
                  FROM FAQ
                  WHERE IsActive = 1
                  ORDER BY SortOrder, FAQId");

            rptFAQ.DataSource = dt;
            rptFAQ.DataBind();
        }
    }
}