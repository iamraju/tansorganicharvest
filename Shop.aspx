<%@ Page Title="Shop" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Shop.aspx.cs"
    Inherits="TansOrganicHarvest.Shop" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .filter-btn { transition: all 0.2s ease; }
    .filter-btn.active {
        background: #2d6a4f;
        color: white;
        border-color: #2d6a4f;
    }
</style>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<!-- Page Header -->
<div class="bg-forest py-14 px-6 text-white text-center">
    <p class="text-sage text-sm uppercase tracking-widest mb-2">Fresh & Organic</p>
    <h1 class="font-display text-5xl font-bold">Our Shop</h1>
    <p class="text-white/60 mt-3 max-w-md mx-auto">
        Browse our full range of farm-fresh produce, 
        all grown naturally on our family farm.
    </p>
</div>

<div class="max-w-7xl mx-auto px-6 py-12">
    <div class="flex flex-col lg:flex-row gap-8">

        <!-- ── SIDEBAR FILTERS ─────────────────────── -->
        <aside class="lg:w-64 flex-shrink-0">
            <div class="bg-white rounded-2xl border border-sage/20 p-6 
                        sticky top-24">

                <h3 class="font-display font-semibold text-gray-800 text-lg mb-5">
                    Filter Products
                </h3>

                <!-- Search -->
                <div class="mb-6">
                    <label class="block text-xs font-semibold text-gray-500 
                                  uppercase tracking-wider mb-2">
                        Search
                    </label>
                    <div class="relative">
                        <asp:TextBox ID="txtSearch" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl pl-9 pr-3 
                                      py-2.5 text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest"
                            placeholder="Search products..." />
                        <span class="absolute left-3 top-2.5 text-gray-400 text-sm">🔍</span>
                    </div>
                </div>

                <!-- Categories -->
                <div class="mb-6">
                    <label class="block text-xs font-semibold text-gray-500 
                                  uppercase tracking-wider mb-3">
                        Category
                    </label>
                    <div class="space-y-1">
                        <asp:Repeater ID="rptCategoryFilters" runat="server">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbCat" runat="server"
                                    CommandName="FilterCat"
                                    CommandArgument='<%# Eval("CategoryId") %>'
                                    CssClass="w-full flex items-center justify-between 
                                              px-3 py-2 rounded-lg text-sm text-gray-600 
                                              hover:bg-sage/10 hover:text-forest 
                                              transition-colors text-left">
                                    <span><%# Eval("Name") %></span>
                                    <span class="bg-sage/20 text-forest text-xs 
                                                 px-1.5 py-0.5 rounded-md font-medium">
                                        <%# Eval("ProductCount") %>
                                    </span>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- Sort -->
                <div class="mb-6">
                    <label class="block text-xs font-semibold text-gray-500 
                                  uppercase tracking-wider mb-2">
                        Sort By
                    </label>
                    <asp:DropDownList ID="ddlSort" runat="server"
                        CssClass="w-full border border-gray-200 rounded-xl px-3 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-forest/30 bg-white">
                        <asp:ListItem Text="Newest First"       Value="newest" />
                        <asp:ListItem Text="Price: Low to High" Value="price_asc" />
                        <asp:ListItem Text="Price: High to Low" Value="price_desc" />
                        <asp:ListItem Text="Name A–Z"           Value="name_asc" />
                    </asp:DropDownList>
                </div>

                <!-- Filter / Reset buttons -->
                <div class="space-y-2">
                    <asp:Button ID="btnFilter" runat="server" Text="Apply Filters"
                        OnClick="btnFilter_Click"
                        CssClass="w-full bg-forest hover:bg-forest-dark text-white 
                                  font-medium py-2.5 rounded-xl cursor-pointer 
                                  transition-colors text-sm" />
                    <asp:Button ID="btnReset" runat="server" Text="Clear Filters"
                        OnClick="btnReset_Click" CausesValidation="false"
                        CssClass="w-full bg-gray-100 hover:bg-gray-200 text-gray-600 
                                  font-medium py-2.5 rounded-xl cursor-pointer 
                                  transition-colors text-sm" />
                </div>

            </div>
        </aside>

        <!-- ── PRODUCT GRID ────────────────────────── -->
        <div class="flex-1 min-w-0">

            <!-- Toolbar -->
            <div class="flex items-center justify-between mb-6">
                <p class="text-sm text-gray-500">
                    <span class="font-semibold text-gray-800">
                        <asp:Literal ID="litCount" runat="server" />
                    </span>
                    products found
                </p>
                <div class="flex items-center gap-2 text-sm text-gray-500">
                    Per page:
                    <asp:DropDownList ID="ddlPageSize" runat="server"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlPageSize_Changed"
                        CssClass="border border-gray-200 rounded-lg px-2 py-1 
                                  text-sm bg-white">
                        <asp:ListItem Text="12" Value="12" Selected="True" />
                        <asp:ListItem Text="24" Value="24" />
                        <asp:ListItem Text="48" Value="48" />
                    </asp:DropDownList>
                </div>
            </div>

            <!-- DataList Grid -->
            <asp:DataList ID="dlProducts" runat="server"
                RepeatColumns="3"
                RepeatDirection="Horizontal"
                RepeatLayout="Flow"
                CssClass="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-6"
                ItemStyle-CssClass="contents">

                <ItemTemplate>
                    <div class="bg-white rounded-2xl overflow-hidden 
                                border border-sage/20 product-card-hover group flex flex-col">

                        <!-- Image -->
                        <div class="relative h-52 bg-sage/10 overflow-hidden">
                            <asp:Image ID="imgProd" runat="server"
                                ImageUrl='<%# ViewHelpers.GetImageUrl(Eval("ImageUrl")) %>'
                                AlternateText='<%# Eval("Name") %>'
                                CssClass="w-full h-full object-cover 
                                          group-hover:scale-105 transition-transform duration-500" />

                            <%-- PassThrough renders raw HTML from the helper --%>
                            <asp:Literal ID="litFeatured" runat="server"
                                Text='<%# ViewHelpers.GetFeaturedBadge(Eval("IsFeatured")) %>'
                                Mode="PassThrough" />

                            <asp:Literal ID="litStock" runat="server"
                                Text='<%# ViewHelpers.GetStockBadge(Eval("Stock")) %>'
                                Mode="PassThrough" />
                        </div>

                        <!-- Body -->
                        <div class="p-5 flex flex-col flex-1">
                            <p class="text-xs text-gray-400 mb-1"><%# Eval("CategoryName") %></p>
                            <h3 class="font-display font-semibold text-gray-800 
                                       text-lg leading-tight mb-auto">
                                <%# Eval("Name") %>
                            </h3>
                            <p class="text-gray-400 text-xs mt-2 mb-4 line-clamp-2">
                                <%# Eval("Description") %>
                            </p>

                            <div class="flex items-center justify-between mt-auto pt-4 
                                        border-t border-gray-100">
                                <div>
                                    <p class="text-xl font-bold text-forest">
                                        $<%# Eval("Price", "{0:F2}") %>
                                    </p>
                                    <p class="text-xs text-gray-400"><%# Eval("Unit") %></p>
                                </div>
                                <a href='<%# "ProductDetail.aspx?id=" + Eval("ProductId") %>'
                                   class="bg-forest text-white text-sm font-medium 
                                          px-4 py-2 rounded-xl hover:bg-forest-dark 
                                          transition-colors btn-lift">
                                    View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>

            </asp:DataList>

            <%-- Empty state shown from code-behind when no results --%>
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false"
                CssClass="text-center py-20">
                <div class="text-5xl mb-4">🔍</div>
                <h3 class="font-display text-xl font-semibold text-gray-600 mb-2">
                    No products found
                </h3>
                <p class="text-gray-400 text-sm">
                    Try adjusting your filters or search term.
                </p>
            </asp:Panel>

            <!-- Pagination -->
            <div class="flex items-center justify-center gap-2 mt-10">
                <asp:LinkButton ID="btnPrev" runat="server"
                    OnClick="btnPager_Click" CommandName="Prev"
                    CssClass="px-4 py-2 border border-gray-200 rounded-xl text-sm 
                              text-gray-600 hover:bg-gray-50 transition-colors">
                    ← Prev
                </asp:LinkButton>

                <asp:PlaceHolder ID="phPages" runat="server" />

                <asp:LinkButton ID="btnNext" runat="server"
                    OnClick="btnPager_Click" CommandName="Next"
                    CssClass="px-4 py-2 border border-gray-200 rounded-xl text-sm 
                              text-gray-600 hover:bg-gray-50 transition-colors">
                    Next →
                </asp:LinkButton>
            </div>

        </div>
    </div>
</div>

</asp:Content>