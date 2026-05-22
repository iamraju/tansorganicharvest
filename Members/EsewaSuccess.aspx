<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="EsewaSuccess.aspx.cs"
    Inherits="TansOrganicHarvest.Members.EsewaSuccess" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Verifying Payment...</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-green-50 min-h-screen flex items-center justify-center">
    <form runat="server">
        <div class="text-center max-w-md mx-auto p-8">

            <asp:Panel ID="pnlVerifying" runat="server"
                CssClass="text-center">
                <div class="text-6xl mb-4">⏳</div>
                <h2 class="text-xl font-bold text-green-800 mb-2">
                    Verifying your payment...
                </h2>
                <p class="text-green-600 text-sm">
                    Please wait while we confirm your transaction with eSewa.
                </p>
            </asp:Panel>

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                <div class="text-6xl mb-4">✅</div>
                <h2 class="text-2xl font-bold text-green-800 mb-2">
                    Payment Successful!
                </h2>
                <p class="text-green-700 mb-4">
                    Your eSewa payment has been verified and your order is confirmed.
                </p>
                <p class="text-sm text-gray-500 mb-6">
                    Transaction Code:
                    <strong><asp:Literal ID="litTxnCode" runat="server" /></strong>
                </p>
                <a href='<%= ViewState["ConfirmUrl"] %>'
                   class="bg-green-600 text-white font-bold px-8 py-3 rounded-xl
                          hover:bg-green-700 transition-colors inline-block">
                    View Order Confirmation →
                </a>
            </asp:Panel>

            <asp:Panel ID="pnlFailed" runat="server" Visible="false">
                <div class="text-6xl mb-4">❌</div>
                <h2 class="text-2xl font-bold text-red-700 mb-2">
                    Payment Verification Failed
                </h2>
                <p class="text-red-600 mb-2 text-sm">
                    <asp:Literal ID="litError" runat="server" />
                </p>
                <p class="text-gray-500 text-sm mb-6">
                    Your order has been placed but payment could not be verified.
                    Please contact support with your order number.
                </p>
                <a href="/Members/OrderHistory.aspx"
                   class="bg-gray-600 text-white font-semibold px-6 py-2.5
                          rounded-xl hover:bg-gray-700 transition-colors inline-block">
                    View My Orders
                </a>
            </asp:Panel>

        </div>
    </form>
</body>
</html>