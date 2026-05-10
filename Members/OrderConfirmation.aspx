<%@ Page Title="Order Confirmed" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="OrderConfirmation.aspx.cs"
    Inherits="TansOrganicHarvest.Members.OrderConfirmation" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    @keyframes scaleIn {
        from { transform: scale(0.5); opacity: 0; }
        to   { transform: scale(1);   opacity: 1; }
    }
    .scale-in { animation: scaleIn 0.5s ease forwards; }
    @media print {
        .no-print { display: none !important; }
        body { background: white !important; }
    }
</style>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<div class="max-w-3xl mx-auto px-6 py-16">

    <!-- Success icon -->
    <div class="text-center mb-10">
        <div class="w-24 h-24 bg-green-100 rounded-full flex items-center 
                    justify-center mx-auto mb-6 scale-in">
            <svg class="w-12 h-12 text-green-500" fill="none"
                 stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round"
                      stroke-width="2" d="M5 13l4 4L19 7"/>
            </svg>
        </div>
        <h1 class="font-display text-4xl font-bold text-gray-800 mb-2">
            Order Confirmed! 🎉
        </h1>
        <p class="text-gray-500">
            Thank you for your order. We'll start preparing it right away.
        </p>
    </div>

    <!-- Order details card -->
    <div class="bg-white rounded-2xl border border-sage/20 shadow-sm 
                overflow-hidden mb-6">

        <!-- Header -->
        <div class="bg-forest/5 border-b border-sage/20 px-6 py-4 
                    flex items-center justify-between">
            <div>
                <p class="text-xs text-gray-400 uppercase tracking-wider">Order Number</p>
                <p class="font-bold text-forest text-xl">
                    #<asp:Literal ID="litOrderId" runat="server" />
                </p>
            </div>
            <div class="text-right">
                <p class="text-xs text-gray-400 uppercase tracking-wider">Date</p>
                <p class="font-medium text-gray-700">
                    <asp:Literal ID="litOrderDate" runat="server" />
                </p>
            </div>
        </div>

        <!-- Status badges -->
        <div class="px-6 py-4 flex flex-wrap gap-3 border-b border-gray-100">
            <span class="bg-amber-100 text-amber-700 text-xs font-semibold 
                         px-3 py-1.5 rounded-full">
                📦 Status: <asp:Literal ID="litStatus" runat="server" />
            </span>
            <span class="bg-blue-100 text-blue-700 text-xs font-semibold 
                         px-3 py-1.5 rounded-full">
                💳 <asp:Literal ID="litPaymentMethod" runat="server" />
            </span>
            <span class="text-xs font-semibold px-3 py-1.5 rounded-full"
                  id="paymentStatusBadge" runat="server">
                <asp:Literal ID="litPaymentStatus" runat="server" />
            </span>
        </div>

        <!-- Order Items -->
        <div class="px-6 py-4">
            <h3 class="font-semibold text-gray-700 text-sm mb-4">Items Ordered</h3>
            <asp:Repeater ID="rptItems" runat="server">
                <ItemTemplate>
                    <div class="flex justify-between items-center py-2.5 
                                border-b border-gray-50 last:border-0">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 bg-sage/10 rounded-lg 
                                        overflow-hidden flex-shrink-0">
                                <asp:Image ID="imgItem" runat="server"
                                    ImageUrl='<%# ViewHelpers.GetImageUrl(Eval("ImageUrl")) %>'
                                    CssClass="w-full h-full object-cover" />
                            </div>
                            <div>
                                <p class="font-medium text-gray-800 text-sm">
                                    <%# Eval("Name") %>
                                </p>
                                <p class="text-xs text-gray-400">
                                    <%# Eval("Quantity") %> × 
                                    $<%# Eval("UnitPrice", "{0:F2}") %>
                                </p>
                            </div>
                        </div>
                        <p class="font-semibold text-gray-800">
                            $<%# Eval("LineTotal", "{0:F2}") %>
                        </p>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Totals -->
        <div class="bg-gray-50 px-6 py-4 space-y-2">
            <div class="flex justify-between text-sm text-gray-600">
                <span>Subtotal</span>
                <span>$<asp:Literal ID="litSubtotal" runat="server" /></span>
            </div>
            <div class="flex justify-between text-sm text-gray-600">
                <span>Delivery</span>
                <asp:Literal ID="litDeliveryFee" runat="server" />
            </div>
            <div class="flex justify-between font-bold text-gray-800 text-lg 
                        pt-2 border-t border-gray-200">
                <span>Total Paid</span>
                <span class="text-forest">
                    $<asp:Literal ID="litTotal" runat="server" />
                </span>
            </div>
        </div>

        <!-- Delivery info -->
        <div class="px-6 py-4 border-t border-gray-100">
            <h3 class="font-semibold text-gray-700 text-sm mb-3">
                Delivery Information
            </h3>
            <div class="grid grid-cols-2 gap-3 text-sm">
                <div>
                    <p class="text-xs text-gray-400">Deliver to</p>
                    <p class="font-medium text-gray-700">
                        <asp:Literal ID="litDeliveryName" runat="server" />
                    </p>
                    <p class="text-gray-500 text-xs mt-0.5">
                        <asp:Literal ID="litDeliveryAddress" runat="server" />
                    </p>
                </div>
                <div>
                    <p class="text-xs text-gray-400">Option</p>
                    <p class="font-medium text-gray-700">
                        <asp:Literal ID="litDeliveryOption" runat="server" />
                    </p>
                    <p class="text-xs text-gray-400 mt-0.5">
                        Ref: <asp:Literal ID="litTransactionRef" runat="server" />
                    </p>
                </div>
            </div>
        </div>

    </div>

    <!-- Action buttons -->
    <div class="flex flex-wrap gap-3 justify-center no-print">
        <button onclick="window.print()"
                class="flex items-center gap-2 bg-white border border-gray-200 
                       text-gray-700 font-medium px-6 py-3 rounded-xl 
                       hover:bg-gray-50 transition-colors text-sm">
            🖨️ Print Receipt
        </button>
        <a href="/Members/OrderHistory.aspx"
           class="flex items-center gap-2 bg-white border border-gray-200 
                  text-gray-700 font-medium px-6 py-3 rounded-xl 
                  hover:bg-gray-50 transition-colors text-sm">
            📋 My Orders
        </a>
        <a href="/Shop.aspx"
           class="flex items-center gap-2 bg-forest text-white font-semibold 
                  px-6 py-3 rounded-xl hover:bg-forest-dark transition-colors text-sm">
            🛒 Continue Shopping
        </a>
    </div>

    <!-- What happens next -->
    <div class="bg-sage/10 rounded-2xl p-6 mt-8 no-print">
        <h3 class="font-semibold text-gray-800 mb-4">What happens next?</h3>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div class="flex items-start gap-3">
                <span class="text-2xl">👨‍🌾</span>
                <div>
                    <p class="font-medium text-gray-700 text-sm">We prepare</p>
                    <p class="text-xs text-gray-400 mt-0.5">
                        Our farmers harvest your items fresh
                    </p>
                </div>
            </div>
            <div class="flex items-start gap-3">
                <span class="text-2xl">📦</span>
                <div>
                    <p class="font-medium text-gray-700 text-sm">We pack</p>
                    <p class="text-xs text-gray-400 mt-0.5">
                        Carefully packed to stay fresh
                    </p>
                </div>
            </div>
            <div class="flex items-start gap-3">
                <span class="text-2xl">🚚</span>
                <div>
                    <p class="font-medium text-gray-700 text-sm">We deliver</p>
                    <p class="text-xs text-gray-400 mt-0.5">
                        Right to your door within 48 hours
                    </p>
                </div>
            </div>
        </div>
    </div>

</div>

</asp:Content>