using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace TansOrganicHarvest.Members
{
    public partial class EsewaPayment : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            // Read params passed from Checkout
            string orderId = Request.QueryString["orderId"];
            string amountStr = Request.QueryString["amount"];
            string transactionUuid = Request.QueryString["uuid"];

            if (string.IsNullOrEmpty(orderId) ||
                string.IsNullOrEmpty(amountStr) ||
                string.IsNullOrEmpty(transactionUuid))
            {
                Response.Redirect("~/Members/Cart.aspx");
                return;
            }

            decimal total = decimal.Parse(amountStr);

            // Build absolute success/failure URLs
            string baseUrl = Request.Url.GetLeftPart(UriPartial.Authority);
            string successUrl = baseUrl + "/Members/EsewaSuccess.aspx";
            string failureUrl = baseUrl + "/Members/EsewaFailure.aspx?orderId=" + orderId;

            // Generate HMAC-SHA256 signature
            string signature = EsewaHelper.GenerateSignature(total, transactionUuid);

            // Populate hidden fields — JS will use these to submit the form
            hfAmount.Value = total.ToString("F2");
            hfTaxAmount.Value = "0";
            hfTotalAmount.Value = total.ToString("F2");
            hfTransactionUuid.Value = transactionUuid;
            hfProductCode.Value = EsewaHelper.ProductCode;
            hfProductServiceCharge.Value = "0";
            hfProductDeliveryCharge.Value = "0";
            hfSuccessUrl.Value = successUrl;
            hfFailureUrl.Value = failureUrl;
            hfSignedFieldNames.Value = "total_amount,transaction_uuid,product_code";
            hfSignature.Value = signature;
        }
    }
}