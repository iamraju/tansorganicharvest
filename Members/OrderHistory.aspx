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

<div class="max-w-5xl mx-auto px-6 py-12">

    <!-- Empty state -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false"
        CssClass="text-center py-24">
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
    </asp:Panel>

    <!-- Orders list -->
    <asp:Panel ID="pnlOrders" runat="server" Visible="false">

        <asp:Repeater ID="rptOrders" runat="server"
            OnItemCommand="rptOrders_ItemCommand" OnItemDataBound="rptOrders_ItemDataBound">
            <ItemTemplate>

                <div class="bg-white rounded-2xl border border-sage/20 
                            shadow-sm mb-4 overflow-hidden">

                    <!-- Order header -->
                    <div class="px-6 py-4 bg-gray-50 border-b border-gray-100
                                flex flex-wrap items-center justify-between gap-3">
                        <div class="flex flex-wrap gap-6">
                            <div>
                                <p class="text-xs text-gray-400 uppercase tracking-wide">
                                    Order
                                </p>
                                <p class="font-bold text-forest">
                                    #<%# Eval("OrderId") %>
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
                                <p class="font-bold text-gray-800">
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

                        <div class="flex items-center gap-3">
                            <asp:Literal ID="litOrderStatus" runat="server"
                                Text='<%# ViewHelpers.GetOrderStatusBadge(Eval("Status")) %>'
                                Mode="PassThrough" />
                            <asp:Literal ID="litPayStatus" runat="server"
                                Text='<%# ViewHelpers.GetPaymentStatusBadge(Eval("PaymentStatus")) %>'
                                Mode="PassThrough" />
                        </div>
                    </div>

                    <!-- Order items preview -->
                    <div class="px-6 py-4">
                        <%-- Inner repeater: NO DataSource here, bound in code-behind --%>
                        <asp:Repeater ID="rptOrderItems" runat="server">
                            <HeaderTemplate>
                                <div class="divide-y divide-gray-50">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <div class="flex items-center gap-4 py-3">
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

                    <!-- Footer actions -->
                    <div class="px-6 py-3 bg-gray-50 border-t border-gray-100 
                                flex items-center justify-between">
                        <p class="text-xs text-gray-400">
                            Ref: <%# Eval("TransactionRef") %>
                        </p>
                        <div class="flex gap-2">
                            <asp:LinkButton ID="btnViewDetail" runat="server"
                                CommandName="ViewDetail"
                                CommandArgument='<%# Eval("OrderId") %>'
                                CssClass="text-forest hover:text-forest-dark text-xs 
                                          font-medium transition-colors">
                                View Details →
                            </asp:LinkButton>
                        </div>
                    </div>

                </div>

            </ItemTemplate>
        </asp:Repeater>

    </asp:Panel>

</div>

</asp:Content>