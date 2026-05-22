<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="EsewaPayment.aspx.cs"
    Inherits="TansOrganicHarvest.Members.EsewaPayment" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Redirecting to eSewa...</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-green-50 min-h-screen flex items-center justify-center">

    <div class="text-center">
        <div class="text-6xl mb-4 animate-bounce">💚</div>
        <h2 class="text-xl font-bold text-green-800 mb-2">
            Redirecting to eSewa...
        </h2>
        <p class="text-green-600 text-sm">
            Please wait while we redirect you to complete your payment.
        </p>
        <div class="mt-4 w-8 h-8 border-4 border-green-500 border-t-transparent
                    rounded-full animate-spin mx-auto"></div>
    </div>

    
    <form id="esewaForm" method="POST" runat="server">
        <asp:HiddenField ID="hfAmount" runat="server" />
        <asp:HiddenField ID="hfTaxAmount" runat="server" />
        <asp:HiddenField ID="hfTotalAmount" runat="server" />
        <asp:HiddenField ID="hfTransactionUuid" runat="server" />
        <asp:HiddenField ID="hfProductCode" runat="server" />
        <asp:HiddenField ID="hfProductServiceCharge" runat="server" />
        <asp:HiddenField ID="hfProductDeliveryCharge" runat="server" />
        <asp:HiddenField ID="hfSuccessUrl" runat="server" />
        <asp:HiddenField ID="hfFailureUrl" runat="server" />
        <asp:HiddenField ID="hfSignedFieldNames" runat="server" />
        <asp:HiddenField ID="hfSignature" runat="server" />
    </form>

    <script>
        setTimeout(function () {
            let form = document.getElementById('esewaForm');

            // Change the form action to eSewa's gateway
            form.action = 'https://rc-epay.esewa.com.np/api/epay/main/v2/form';

            // Build proper input fields from hidden fields
            let fields = {
                'amount': document.getElementById('<%= hfAmount.ClientID %>').value,
                'tax_amount': document.getElementById('<%= hfTaxAmount.ClientID %>').value,
                'total_amount': document.getElementById('<%= hfTotalAmount.ClientID %>').value,
                'transaction_uuid': document.getElementById('<%= hfTransactionUuid.ClientID %>').value,
                'product_code': document.getElementById('<%= hfProductCode.ClientID %>').value,
                'product_service_charge': document.getElementById('<%= hfProductServiceCharge.ClientID %>').value,
                'product_delivery_charge': document.getElementById('<%= hfProductDeliveryCharge.ClientID %>').value,
                'success_url': document.getElementById('<%= hfSuccessUrl.ClientID %>').value,
                'failure_url': document.getElementById('<%= hfFailureUrl.ClientID %>').value,
                'signed_field_names': document.getElementById('<%= hfSignedFieldNames.ClientID %>').value,
                'signature': document.getElementById('<%= hfSignature.ClientID %>').value,
            };

            // Clear existing children and add proper name/value inputs
            while (form.firstChild) form.removeChild(form.firstChild);

            Object.keys(fields).forEach(function (key) {
                if (fields[key]) {  // Only add if value exists
                    let input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = fields[key];
                    form.appendChild(input);
                }
            });

            form.submit();
        }, 800);
    </script>

</body>
</html>