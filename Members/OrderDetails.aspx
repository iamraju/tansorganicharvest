<%@ Page Title="Order Details" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="OrderDetails.aspx.cs"
    Inherits="TansOrganicHarvest.Members.OrderDetails" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    @media print {
        .no-print { display: none !important; }
        body { background: white !important; }
        .sidebar-print-hide { display: none !important; }
        .main-content-print { width: 100% !important; }
    }
</style>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<div class="bg-forest py-12 px-6 text-white text-center">
    <h1 class="font-display text-4xl font-bold">Order Details</h1>
    <p class="text-white/60 mt-2 text-sm">View your order information</p>
</div>

<div class="max-w-6xl mx-auto px-6 py-12">

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- Left: Sidebar -->
        <div class="space-y-4 sidebar-print-hide">
            <uc:MemberSidebar ID="MemberSidebar1" runat="server" />
        </div>

        <!-- Right: Order Details -->
        <div class="lg:col-span-2 main-content-print">

            <!-- Back button -->
            <div class="mb-4 no-print">
                <a href="/Members/OrderHistory.aspx"
                   class="inline-flex items-center gap-2 text-forest hover:text-forest-dark 
                          text-sm font-medium transition-colors">
                    ← Back to My Orders
                </a>
            </div>

            <!-- Order details card -->
            <div class="bg-white rounded-2xl border border-sage/20 shadow-sm 
                        overflow-hidden">

                <!-- Header -->
                <div class="bg-forest/5 border-b border-sage/20 px-6 py-4 
                            flex flex-wrap items-center justify-between gap-3">
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
                            <div class="flex justify-between items-center py-3 
                                        border-b border-gray-100 last:border-0">
                                <div class="flex items-center gap-3 flex-1">
                                    <div class="w-12 h-12 bg-sage/10 rounded-lg 
                                                overflow-hidden flex-shrink-0">
                                        <asp:Image ID="imgItem" runat="server"
                                            ImageUrl='<%# ViewHelpers.GetImageUrl(Eval("ImageUrl")) %>'
                                            CssClass="w-full h-full object-cover" />
                                    </div>
                                    <div class="flex-1">
                                        <p class="font-medium text-gray-800 text-sm">
                                            <%# Eval("Name") %>
                                        </p>
                                        <p class="text-xs text-gray-400">
                                            Qty: <%# Eval("Quantity") %> × 
                                            $<%# Eval("UnitPrice", "{0:F2}") %>
                                        </p>
                                    </div>
                                </div>
                                <p class="font-semibold text-gray-800 ml-4">
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
                        <span>Delivery Fee</span>
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
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
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
                            <p class="text-xs text-gray-400">Delivery Option</p>
                            <p class="font-medium text-gray-700">
                                <asp:Literal ID="litDeliveryOption" runat="server" />
                            </p>
                            <p class="text-xs text-gray-400 mt-0.5">
                                Transaction Ref: <span class="font-mono">
                                    <asp:Literal ID="litTransactionRef" runat="server" />
                                </span>
                            </p>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>
</div>

</asp:Content>