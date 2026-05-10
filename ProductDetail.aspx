<%@ Page Title="Product Detail" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ProductDetail.aspx.cs"
    Inherits="TansOrganicHarvest.ProductDetail" %>

<%-- ONE HeadContent block containing both styles and script --%>
<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    @keyframes fadeUp {
        from { opacity:0; transform:translateY(20px); }
        to   { opacity:1; transform:translateY(0); }
    }
    .fade-up   { animation: fadeUp 0.5s ease forwards; }
    .fade-up-2 { animation: fadeUp 0.5s 0.1s ease both; }
    .fade-up-3 { animation: fadeUp 0.5s 0.2s ease both; }
</style>

<script>
    function changeQty(delta) {
        var input = document.querySelector('.qty-input');
        if (!input) return;
        var val = parseInt(input.value) + delta;
        if (val < 1) val = 1;
        if (val > 99) val = 99;
        input.value = val;
    }
</script>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Breadcrumb -->
    <div class="max-w-7xl mx-auto px-6 pt-8 pb-2">
        <nav class="flex items-center gap-2 text-sm text-gray-400">
            <a href="/Default.aspx" class="hover:text-forest transition-colors">
                Home
            </a>
            <span>›</span>
            <a href="/Shop.aspx" class="hover:text-forest transition-colors">
                Shop
            </a>
            <span>›</span>
            <asp:Literal ID="litBreadcrumb" runat="server" />
        </nav>
    </div>

    <!-- Not found panel -->
    <asp:Panel ID="pnlNotFound" runat="server" Visible="false"
        CssClass="max-w-2xl mx-auto px-6 py-20 text-center">
        <div class="text-6xl mb-4">🔍</div>
        <h2 class="font-display text-3xl font-bold text-gray-700 mb-3">
            Product Not Found
        </h2>
        <p class="text-gray-400 mb-8">
            This product may have been removed or is no longer available.
        </p>
        <a href="/Shop.aspx"
           class="bg-forest text-white font-semibold px-8 py-3 
                  rounded-xl hover:bg-forest-dark transition-colors inline-block">
            Back to Shop
        </a>
    </asp:Panel>

    <!-- Product detail panel -->
    <asp:Panel ID="pnlProduct" runat="server" Visible="false">
    <div class="max-w-7xl mx-auto px-6 py-10">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 mb-20">

            <!-- Left: Image -->
            <div class="fade-up">
                <div class="bg-sage/10 rounded-3xl overflow-hidden aspect-square 
                            max-h-[520px] border border-sage/20">
                    <asp:Image ID="imgProduct" runat="server"
                        CssClass="w-full h-full object-cover" />
                </div>
            </div>

            <!-- Right: Details -->
            <div class="fade-up-2 flex flex-col">

                <!-- Category + badges -->
                <div class="flex items-center gap-2 mb-3">
                    <span class="text-xs text-forest font-semibold uppercase 
                                 tracking-widest bg-sage/20 px-3 py-1 rounded-full">
                        <asp:Literal ID="litCategory" runat="server" />
                    </span>
                    <asp:Panel ID="pnlFeaturedBadge" runat="server" Visible="false"
                        CssClass="bg-earth/20 text-earth text-xs font-semibold 
                                  px-3 py-1 rounded-full">
                        ⭐ Featured
                    </asp:Panel>
                </div>

                <!-- Name -->
                <h1 class="font-display text-4xl font-bold text-gray-800 
                           leading-tight mb-4">
                    <asp:Literal ID="litName" runat="server" />
                </h1>

                <!-- Price -->
                <div class="flex items-end gap-2 mb-6">
                    <p class="font-display text-5xl font-bold text-forest">
                        $<asp:Literal ID="litPrice" runat="server" />
                    </p>
                    <p class="text-gray-400 mb-2 text-sm">
                        <asp:Literal ID="litUnit" runat="server" />
                    </p>
                </div>

                <!-- Description -->
                <div class="prose prose-sm text-gray-600 leading-relaxed mb-8 
                            border-t border-b border-gray-100 py-6">
                    <asp:Literal ID="litDescription" runat="server" />
                </div>

                <!-- Stock indicator -->
                <asp:Panel ID="pnlInStock" runat="server" Visible="false"
                    CssClass="flex items-center gap-2 text-green-600 text-sm 
                              font-medium mb-6">
                    <span class="w-2 h-2 bg-green-500 rounded-full 
                                 animate-pulse inline-block"></span>
                    In Stock — 
                    <asp:Literal ID="litStock" runat="server" /> available
                </asp:Panel>

                <asp:Panel ID="pnlOutOfStock" runat="server" Visible="false"
                    CssClass="flex items-center gap-2 text-red-500 text-sm 
                              font-medium mb-6">
                    <span class="w-2 h-2 bg-red-500 rounded-full inline-block">
                    </span>
                    Out of Stock — check back soon
                </asp:Panel>

                <!-- Add to cart (member only) -->
                <asp:LoginView ID="lvCart" runat="server">

                    <AnonymousTemplate>
                        <div class="bg-sage/10 border border-sage/30 rounded-2xl 
                                    p-5 mb-6 text-center">
                            <p class="text-gray-600 text-sm mb-3">
                                🔒 Sign in to add this product to your cart
                            </p>
                            <div class="flex gap-3 justify-center">
                                <a href='/Account/Login.aspx?ReturnUrl=<%=Request.Url.PathAndQuery %>'
                                   class="bg-forest text-white font-semibold px-6 py-2.5 
                                          rounded-xl text-sm hover:bg-forest-dark transition-colors">
                                    Sign In
                                </a>
                                <a href="/Account/Register.aspx"
                                   class="border-2 border-forest text-forest font-semibold 
                                          px-6 py-2.5 rounded-xl text-sm 
                                          hover:bg-forest hover:text-white transition-all">
                                    Register Free
                                </a>
                            </div>
                        </div>
                    </AnonymousTemplate>

                    <LoggedInTemplate>
                        <asp:Panel ID="pnlAddToCart" runat="server">

                            <asp:Panel ID="pnlCartSuccess" runat="server" Visible="false"
                                CssClass="bg-green-50 border border-green-200 text-green-700 
                                          rounded-xl px-4 py-3 mb-4 text-sm flex 
                                          items-center gap-2">
                                <span>✅</span>
                                <asp:Literal ID="litCartMsg" runat="server" />
                                <a href="/Members/Cart.aspx"
                                   class="underline font-semibold ml-1">
                                    View Cart →
                                </a>
                            </asp:Panel>

                            <asp:Panel ID="pnlCartError" runat="server" Visible="false"
                                CssClass="bg-red-50 border border-red-200 text-red-700 
                                          rounded-xl px-4 py-3 mb-4 text-sm">
                                <asp:Literal ID="litCartError" runat="server" />
                            </asp:Panel>

                            <div class="flex items-center gap-4 mb-4">
                                <div class="flex items-center border border-gray-200 
                                            rounded-xl overflow-hidden">
                                    <button type="button" onclick="changeQty(-1)"
                                            class="px-4 py-3 text-gray-500 
                                                   hover:bg-gray-50 transition-colors 
                                                   text-lg font-bold">
                                        −
                                    </button>
                                    <asp:TextBox ID="txtQty" runat="server" Text="1"
                                        CssClass="w-14 text-center border-x border-gray-200 
                                                  py-3 text-sm font-semibold focus:outline-none"
                                        ReadOnly="true" />
                                    <button type="button" onclick="changeQty(1)"
                                            class="px-4 py-3 text-gray-500 
                                                   hover:bg-gray-50 transition-colors 
                                                   text-lg font-bold">
                                        +
                                    </button>
                                </div>

                                <asp:Button ID="btnAddToCart" runat="server"
                                    Text="🛒 Add to Cart"
                                    OnClick="btnAddToCart_Click"
                                    CssClass="flex-1 bg-forest hover:bg-forest-dark 
                                              text-white font-bold py-3.5 rounded-xl 
                                              transition-colors cursor-pointer text-sm" />
                            </div>

                        </asp:Panel>
                    </LoggedInTemplate>

                </asp:LoginView>

                <!-- Meta info -->
                <div class="grid grid-cols-2 gap-4 mt-2">
                    <div class="bg-gray-50 rounded-xl p-4 text-center">
                        <p class="text-2xl mb-1">🌱</p>
                        <p class="text-xs font-semibold text-gray-700">100% Organic</p>
                        <p class="text-xs text-gray-400">No pesticides</p>
                    </div>
                    <div class="bg-gray-50 rounded-xl p-4 text-center">
                        <p class="text-2xl mb-1">🚚</p>
                        <p class="text-xs font-semibold text-gray-700">Fresh Delivery</p>
                        <p class="text-xs text-gray-400">Within 48 hours</p>
                    </div>
                </div>

            </div>
        </div>

        <!-- Related Products -->
        <asp:Panel ID="pnlRelated" runat="server" Visible="false">
            <div class="border-t border-gray-100 pt-16">
                <h2 class="font-display text-3xl font-bold text-gray-800 mb-8">
                    You Might Also Like
                </h2>
                <asp:Repeater ID="rptRelated" runat="server">
                    <HeaderTemplate>
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-5">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <a href='<%# "ProductDetail.aspx?id=" + Eval("ProductId") %>'
                           class="bg-white rounded-2xl overflow-hidden border 
                                  border-sage/20 product-card-hover group block">
                            <div class="h-44 bg-sage/10 overflow-hidden">
                                <asp:Image ID="imgRelated" runat="server"
                                    ImageUrl='<%# ViewHelpers.GetImageUrl(Eval("ImageUrl")) %>'
                                    AlternateText='<%# Eval("Name") %>'
                                    CssClass="w-full h-full object-cover 
                                              group-hover:scale-105 
                                              transition-transform duration-500" />
                            </div>
                            <div class="p-4">
                                <p class="font-semibold text-gray-800 text-sm 
                                          leading-tight mb-1">
                                    <%# Eval("Name") %>
                                </p>
                                <p class="text-forest font-bold">
                                    $<%# Eval("Price", "{0:F2}") %>
                                </p>
                            </div>
                        </a>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>

    </div>
    </asp:Panel>

</asp:Content>
