<%@ Page Title="My Cart" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Cart.aspx.cs"
    Inherits="TansOrganicHarvest.Members.Cart" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<div class="bg-forest py-12 px-6 text-white text-center">
    <h1 class="font-display text-4xl font-bold">My Cart</h1>
    <p class="text-white/60 mt-2 text-sm">
        Review your items before checkout
    </p>
</div>

<div class="max-w-6xl mx-auto px-6 py-12">

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="bg-green-50 border border-green-200 text-green-700 rounded-xl 
                  px-4 py-3 mb-6 text-sm flex items-center gap-2">
        <span>✅</span><asp:Literal ID="litSuccess" runat="server" />
    </asp:Panel>
    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="bg-red-50 border border-red-200 text-red-700 rounded-xl 
                  px-4 py-3 mb-6 text-sm flex items-center gap-2">
        <span>⚠️</span><asp:Literal ID="litError" runat="server" />
    </asp:Panel>

    <!-- Empty cart -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false"
        CssClass="text-center py-24">
        <div class="text-7xl mb-6">🛒</div>
        <h2 class="font-display text-3xl font-bold text-gray-700 mb-3">
            Your cart is empty
        </h2>
        <p class="text-gray-400 mb-8">
            Add some fresh produce to get started!
        </p>
        <a href="/Shop.aspx"
           class="bg-forest text-white font-semibold px-8 py-3.5 
                  rounded-xl hover:bg-forest-dark transition-colors inline-block">
            Browse Products
        </a>
    </asp:Panel>

    <!-- Cart with items -->
    <asp:Panel ID="pnlCart" runat="server" Visible="false">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

            <!-- Cart items -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-2xl border border-sage/20 
                            overflow-hidden shadow-sm">

                    <div class="px-6 py-4 border-b border-gray-100 flex 
                                items-center justify-between">
                        <h2 class="font-semibold text-gray-800">
                            Cart Items
                            (<asp:Literal ID="litItemCount" runat="server" />)
                        </h2>
                        <asp:LinkButton ID="btnClearCart" runat="server"
                            Text="Clear Cart"
                            OnClick="btnClearCart_Click"
                            OnClientClick="return confirm('Clear entire cart?');"
                            CssClass="text-red-400 hover:text-red-600 
                                      text-sm transition-colors" />
                    </div>

                    <asp:Repeater ID="rptCart" runat="server"
                        OnItemCommand="rptCart_ItemCommand">
                        <ItemTemplate>
                            <div class="flex items-center gap-4 px-6 py-5 
                                        border-b border-gray-50 last:border-0">

                                <!-- Image -->
                                <div class="w-20 h-20 rounded-xl overflow-hidden 
                                            bg-sage/10 flex-shrink-0">
                                    <asp:Image ID="imgCart" runat="server"
                                        ImageUrl='<%# ViewHelpers.GetImageUrl(Eval("ImageUrl")) %>'
                                        AlternateText='<%# Eval("Name") %>'
                                        CssClass="w-full h-full object-cover" />
                                </div>

                                <!-- Details -->
                                <div class="flex-1 min-w-0">
                                    <h3 class="font-semibold text-gray-800 truncate">
                                        <%# Eval("Name") %>
                                    </h3>
                                    <p class="text-xs text-gray-400 mt-0.5">
                                        <%# Eval("CategoryName") %>
                                        · <%# Eval("Unit") %>
                                    </p>
                                    <p class="text-forest font-bold mt-1">
                                        $<%# Eval("Price", "{0:F2}") %> each
                                    </p>
                                </div>

                                <!-- Qty controls -->
                                <div class="flex items-center border border-gray-200 
                                            rounded-xl overflow-hidden flex-shrink-0">
                                    <asp:LinkButton ID="btnDecrease" runat="server"
                                        CommandName="Decrease"
                                        CommandArgument='<%# Eval("CartId") %>'
                                        CssClass="px-3 py-2 text-gray-500 
                                                  hover:bg-gray-50 transition-colors 
                                                  font-bold text-lg leading-none">
                                        −
                                    </asp:LinkButton>
                                    <span class="px-4 py-2 text-sm font-semibold 
                                                 border-x border-gray-200 min-w-[3rem] 
                                                 text-center">
                                        <%# Eval("Quantity") %>
                                    </span>
                                    <asp:LinkButton ID="btnIncrease" runat="server"
                                        CommandName="Increase"
                                        CommandArgument='<%# Eval("CartId") %>'
                                        CssClass="px-3 py-2 text-gray-500 
                                                  hover:bg-gray-50 transition-colors 
                                                  font-bold text-lg leading-none">
                                        +
                                    </asp:LinkButton>
                                </div>

                                <!-- Line total -->
                                <div class="text-right flex-shrink-0 w-24">
                                    <p class="font-bold text-gray-800 text-lg">
                                        $<%# Eval("LineTotal", "{0:F2}") %>
                                    </p>
                                    <asp:LinkButton ID="btnRemove" runat="server"
                                        CommandName="Remove"
                                        CommandArgument='<%# Eval("CartId") %>'
                                        CssClass="text-red-400 hover:text-red-600 
                                                  text-xs transition-colors mt-1 
                                                  inline-block">
                                        Remove
                                    </asp:LinkButton>
                                </div>

                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                </div>

                <a href="/Shop.aspx"
                   class="inline-flex items-center gap-2 text-forest hover:text-forest-dark 
                          font-medium text-sm mt-4 transition-colors">
                    ← Continue Shopping
                </a>
            </div>

            <!-- Order summary -->
            <div>
                <div class="bg-white rounded-2xl border border-sage/20 
                            shadow-sm p-6 sticky top-24">

                    <h2 class="font-semibold text-gray-800 mb-5 pb-4 
                               border-b border-gray-100">
                        Order Summary
                    </h2>

                    <div class="space-y-3 mb-5">
                        <div class="flex justify-between text-sm text-gray-600">
                            <span>Subtotal 
                                (<asp:Literal ID="litSummaryCount" runat="server" /> items)
                            </span>
                            <span>$<asp:Literal ID="litSubtotal" runat="server" /></span>
                        </div>
                        <div class="flex justify-between text-sm text-gray-600">
                            <span>Delivery</span>
                            <asp:Literal ID="litDeliveryFee" runat="server" />
                        </div>
                    </div>

                    <div class="border-t border-gray-100 pt-4 mb-6">
                        <div class="flex justify-between font-bold text-gray-800 text-lg">
                            <span>Total</span>
                            <span class="text-forest">
                                $<asp:Literal ID="litTotal" runat="server" />
                            </span>
                        </div>
                        <p class="text-xs text-gray-400 mt-1">
                            Including all taxes
                        </p>
                    </div>

                    <!-- Free delivery notice -->
                    <asp:Panel ID="pnlFreeDelivery" runat="server" Visible="false"
                        CssClass="bg-green-50 text-green-700 text-xs rounded-xl 
                                  px-3 py-2 mb-4 text-center font-medium">
                        🎉 You qualify for free delivery!
                    </asp:Panel>
                    <asp:Panel ID="pnlDeliveryProgress" runat="server" Visible="false"
                        CssClass="bg-sage/10 text-forest text-xs rounded-xl 
                                  px-3 py-2 mb-4 text-center">
                        <asp:Literal ID="litDeliveryProgress" runat="server" />
                    </asp:Panel>

                    <a href="/Members/Checkout.aspx"
                       class="block w-full bg-forest hover:bg-forest-dark text-white 
                              font-bold py-3.5 rounded-xl text-center transition-colors 
                              text-sm">
                        Proceed to Checkout →
                    </a>

                    <!-- Trust badges -->
                    <div class="mt-4 pt-4 border-t border-gray-100 
                                flex justify-around text-xs text-gray-400">
                        <span>🔒 Secure</span>
                        <span>🌿 Fresh</span>
                        <span>🚚 Fast</span>
                    </div>
                </div>
            </div>

        </div>
    </asp:Panel>
</div>

</asp:Content>