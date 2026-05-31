<%@ Page Title="My Orders" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="OrderHistory.aspx.cs"
    Inherits="TansOrganicHarvest.Members.OrderHistory" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<div class="bg-forest py-12 px-6 text-white text-center">
    <h1 class="font-display text-4xl font-bold">My Orders</h1>
    <p class="text-white/60 mt-2 text-sm">Track and manage your orders</p>
</div>

<div class="max-w-6xl mx-auto px-6 py-12">

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- Left: Same sidebar as Profile page -->
        <div class="space-y-4">

            <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-6 
                        text-center">
                <div class="w-20 h-20 bg-forest rounded-full flex items-center 
                            justify-center text-3xl font-bold text-white mx-auto mb-4">
                    <asp:Literal ID="litInitial" runat="server" />
                </div>
                <h2 class="font-display text-xl font-bold text-gray-800">
                    <asp:Literal ID="litDisplayName" runat="server" />
                </h2>
                <p class="text-gray-400 text-sm mt-1">
                    <asp:Literal ID="litEmail" runat="server" />
                </p>
                <p class="text-xs text-gray-400 mt-1">
                    Member since <asp:Literal ID="litMemberSince" runat="server" />
                </p>
            </div>

            <!-- Quick links - updated with current page highlighted -->
            <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-4">
                <nav class="space-y-1">
                    <a href="/Members/Profile.aspx"
                       class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                              text-gray-600 hover:bg-gray-50 text-sm transition-colors">
                        👤 My Profile
                    </a>
                    <a href="/Members/OrderHistory.aspx"
                       class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                              bg-forest/5 text-forest font-medium text-sm">
                        📋 My Orders
                    </a>
                    <a href="/Members/Cart.aspx"
                       class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                              text-gray-600 hover:bg-gray-50 text-sm transition-colors">
                        🛒 My Cart
                    </a>
                    <a href="/Members/ChangePassword.aspx"
                       class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                              text-gray-600 hover:bg-gray-50 text-sm transition-colors">
                        🔑 Change Password
                    </a>
                </nav>
            </div>

        </div>

        <!-- Right: Orders list -->
        <div class="lg:col-span-2">

            <!-- Empty state -->
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-12 text-center">
                    <div class="text-7xl mb-6">📋</div>
                    <h2 class="font-display text-3xl font-bold text-gray-700 mb-3">
                        No orders yet
                    </h2>
                    <p class="text-gray-400 mb-8">
                        Start shopping to see your orders here.
                    </p>
                    <a href="/Shop.aspx"
                       class="bg-forest text-white font-semibold px-8 py-3.5 
                              rounded-xl hover:bg-forest-dark transition-colors inline-block">
                        Browse Products
                    </a>
                </div>
            </asp:Panel>

            <!-- Orders list -->
            <asp:Panel ID="pnlOrders" runat="server" Visible="false">
                
                <!-- Orders header -->
                <div class="bg-white rounded-2xl border border-sage/20 shadow-sm overflow-hidden">
                    <div class="px-6 py-4 bg-gray-50 border-b border-gray-100">
                        <h2 class="font-semibold text-gray-800">Order History</h2>
                        <p class="text-xs text-gray-400 mt-1">
                            All your orders are listed below
                        </p>
                    </div>
                    
                    <div class="divide-y divide-gray-100">
                        <asp:Repeater ID="rptOrders" runat="server"
                            OnItemCommand="rptOrders_ItemCommand" 
                            OnItemDataBound="rptOrders_ItemDataBound">
                            <ItemTemplate>
                                
                                <div class="p-6 hover:bg-gray-50 transition-colors">
                                    
                                    <!-- Order header info -->
                                    <div class="flex flex-wrap items-start justify-between gap-4 mb-4">
                                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 flex-1">
                                            <div>
                                                <p class="text-xs text-gray-400 uppercase tracking-wide">
                                                    Order #
                                                </p>
                                                <p class="font-bold text-forest text-lg">
                                                    <%# Eval("OrderId") %>
                                                </p>
                                            </div>
                                            <div>
                                                <p class="text-xs text-gray-400 uppercase tracking-wide">
                                                    Date
                                                </p>
                                                <p class="font-medium text-gray-700 text-sm">
                                                    <%# Eval("OrderDate", "{0:dd MMM yyyy}") %>
                                                </p>
                                            </div>
                                            <div>
                                                <p class="text-xs text-gray-400 uppercase tracking-wide">
                                                    Total
                                                </p>
                                                <p class="font-bold text-gray-800 text-lg">
                                                    $<%# Eval("TotalAmount", "{0:F2}") %>
                                                </p>
                                            </div>
                                            <div>
                                                <p class="text-xs text-gray-400 uppercase tracking-wide">
                                                    Payment
                                                </p>
                                                <p class="font-medium text-gray-700 text-sm">
                                                    <%# Eval("PaymentMethod") %>
                                                </p>
                                            </div>
                                        </div>
                                        
                                        <div class="flex flex-col items-end gap-2">
                                            <div class="flex gap-2">
                                                <asp:Literal ID="litOrderStatus" runat="server"
                                                    Text='<%# ViewHelpers.GetOrderStatusBadge(Eval("Status")) %>'
                                                    Mode="PassThrough" />
                                                <asp:Literal ID="litPayStatus" runat="server"
                                                    Text='<%# ViewHelpers.GetPaymentStatusBadge(Eval("PaymentStatus")) %>'
                                                    Mode="PassThrough" />
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Order items -->
                                    <div class="mt-4 pl-0 md:pl-4 border-l-2 border-forest/20">
                                        <asp:Repeater ID="rptOrderItems" runat="server">
                                            <HeaderTemplate>
                                                <div class="space-y-3">
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div class="flex items-center gap-4">
                                                    <div class="w-12 h-12 rounded-lg overflow-hidden 
                                                                bg-sage/10 flex-shrink-0">
                                                        <asp:Image ID="imgItem" runat="server"
                                                            ImageUrl='<%# ViewHelpers.GetImageUrl(Eval("ImageUrl")) %>'
                                                            CssClass="w-full h-full object-cover" />
                                                    </div>
                                                    <div class="flex-1 min-w-0">
                                                        <p class="font-medium text-gray-800 text-sm truncate">
                                                            <%# Eval("Name") %>
                                                        </p>
                                                        <p class="text-xs text-gray-400 mt-0.5">
                                                            Qty: <%# Eval("Quantity") %> ×
                                                            $<%# Eval("UnitPrice", "{0:F2}") %>
                                                        </p>
                                                    </div>
                                                    <p class="font-semibold text-gray-800 text-sm flex-shrink-0">
                                                        $<%# Eval("LineTotal", "{0:F2}") %>
                                                    </p>
                                                </div>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                </div>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                    
                                    <!-- Footer with transaction ref and detail link -->
                                    <div class="mt-4 pt-3 flex flex-wrap items-center justify-between gap-3 
                                                border-t border-gray-100">
                                        <p class="text-xs text-gray-400 font-mono">
                                            Ref: <%# Eval("TransactionRef") %>
                                        </p>
                                        <asp:LinkButton ID="btnViewDetail" runat="server"
                                            CommandName="ViewDetail"
                                            CommandArgument='<%# Eval("OrderId") %>'
                                            CssClass="text-forest hover:text-forest-dark text-sm 
                                                      font-medium transition-colors inline-flex 
                                                      items-center gap-1">
                                            View Details →
                                        </asp:LinkButton>
                                    </div>
                                    
                                </div>
                                
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
                
            </asp:Panel>
            
        </div>

    </div>
</div>

</asp:Content>