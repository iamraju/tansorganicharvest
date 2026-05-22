using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;

namespace TansOrganicHarvest
{
    public partial class ProduceBoxes : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadBoxes();
        }

        private void LoadBoxes()
        {
            DataTable dt = DatabaseHelper.ExecuteQuery(
                @"SELECT BoxId, Name, Description, Price,
                         ImageUrl, Contents
                  FROM ProduceBoxes
                  WHERE IsActive = 1
                  ORDER BY Price ASC");

            if (dt.Rows.Count == 0)
            {
                pnlEmpty.Visible = true;
                rptBoxes.Visible = false;
                return;
            }

            rptBoxes.DataSource = dt;
            rptBoxes.DataBind();
        }

        // Splits Contents text into list for nested Repeater
        public List<string> GetContents(object contents)
        {
            var list = new List<string>();
            if (contents == null || contents == DBNull.Value)
                return list;

            string text = contents.ToString();
            if (string.IsNullOrWhiteSpace(text))
                return list;

            foreach (string line in text.Split('\n'))
            {
                string trimmed = line.Trim();
                if (!string.IsNullOrEmpty(trimmed))
                    list.Add(trimmed);
            }
            return list;
        }
    }
}