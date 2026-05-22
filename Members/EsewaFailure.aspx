<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="EsewaFailure.aspx.cs"
    Inherits="TansOrganicHarvest.Members.EsewaFailure" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Payment Failed</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-red-50 min-h-screen flex items-center justify-center">
<form runat="server">
    <div class="bg-white rounded-2xl shadow-xl p-10 max-w-md text-center">
        <div class="text-6xl mb-4">❌</div>
        <h2 class="text-2xl font-bold text-red-700 mb-3">Payment Cancelled</h2>
        <p class="text-gray-600 text-sm mb-6">
            Your eSewa payment was cancelled or failed. Your order has been
            saved but is marked as unpaid. You can retry payment from your
            order history.
        </p>
        <p class="text-xs text-gray-400 mb-6">
            Order #<asp:Literal ID="litOrderId" runat="server" />
        </p>
        <div class="flex flex-col gap-3">
            <a href="/Members/OrderHistory.aspx"
               class="bg-gray-800 text-white font-semibold py-3 px-6
                      rounded-xl hover:bg-gray-900 transition-colors block">
                View My Orders
            </a>
            <a href="/Shop.aspx"
               class="bg-green-600 text-white font-semibold py-3 px-6
                      rounded-xl hover:bg-green-700 transition-colors block">
                Continue Shopping
            </a>
        </div>
    </div>
</form>
</body>
</html>