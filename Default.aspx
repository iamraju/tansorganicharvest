<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Default.aspx.cs"
    Inherits="TansOrganicHarvest.Default" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    @keyframes fadeUp {
        from { opacity:0; transform:translateY(30px); }
        to   { opacity:1; transform:translateY(0); }
    }
    .fade-up { animation: fadeUp 0.7s ease forwards; }
    .fade-up-2 { animation: fadeUp 0.7s 0.15s ease both; }
    .fade-up-3 { animation: fadeUp 0.7s 0.3s ease both; }

    .hero-bg {
        background: linear-gradient(135deg, #1b4332 0%, #2d6a4f 50%, #40916c 100%);
        position: relative;
        overflow: hidden;
    }
    .hero-bg::before {
        content: '';
        position: absolute;
        inset: 0;
        background: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M50 10 C30 10 10 30 10 50 C10 70 30 90 50 90 C70 90 90 70 90 50 C90 30 70 10 50 10Z' fill='none' stroke='rgba(255,255,255,0.04)' stroke-width='1'/%3E%3C/svg%3E")
                repeat;
        opacity: 0.5;
    }

    .category-pill:hover .category-icon { transform: scale(1.15) rotate(-5deg); }
    .category-icon { transition: transform 0.3s ease; }
</style>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<!-- ══════════════════════════════════════════════
     HERO SECTION
══════════════════════════════════════════════ -->
<section class="hero-bg text-white py-24 md:py-36 px-6">
    <div class="max-w-7xl mx-auto">
        <div class="max-w-2xl">

            <div class="inline-flex items-center gap-2 bg-white/10 backdrop-blur-sm
                        rounded-full px-4 py-1.5 text-sm text-sage mb-6 fade-up">
                🌱 100% Organic · Chemical Free · Farm Fresh
            </div>

            <h1 class="font-display text-5xl md:text-7xl font-bold leading-tight 
                       mb-6 fade-up-2">
                From Our Farm<br/>
                <span class="text-sage italic">to Your Table</span>
            </h1>

            <p class="text-white/70 text-lg md:text-xl leading-relaxed mb-10 
                      max-w-xl fade-up-3">
                The Tan family has been growing fresh fruits, vegetables, and honey
                since 1998 — naturally, lovingly, and sustainably.
            </p>

            <div class="flex flex-wrap gap-4 fade-up-3">
                <a href="Shop.aspx"
                   class="bg-white text-forest font-semibold px-8 py-3.5 rounded-xl 
                          hover:bg-cream transition-colors btn-lift inline-flex 
                          items-center gap-2">
                    Shop Now <span>→</span>
                </a>
                <a href="ProduceBoxes.aspx"
                   class="bg-white/10 backdrop-blur-sm border border-white/20 text-white 
                          font-semibold px-8 py-3.5 rounded-xl hover:bg-white/20 
                          transition-colors btn-lift inline-flex items-center gap-2">
                    📦 Weekly Boxes
                </a>
            </div>

            <!-- Stats -->
            <div class="flex flex-wrap gap-8 mt-14 pt-10 border-t border-white/10">
                <div>
                    <p class="font-display text-3xl font-bold text-earth-light">25+</p>
                    <p class="text-white/50 text-sm mt-0.5">Farm Products</p>
                </div>
                <div>
                    <p class="font-display text-3xl font-bold text-earth-light">1998</p>
                    <p class="text-white/50 text-sm mt-0.5">Est. Year</p>
                </div>
                <div>
                    <p class="font-display text-3xl font-bold text-earth-light">48hr</p>
                    <p class="text-white/50 text-sm mt-0.5">From Harvest to Door</p>
                </div>
                <div>
                    <p class="font-display text-3xl font-bold text-earth-light">0</p>
                    <p class="text-white/50 text-sm mt-0.5">Chemicals Used</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Decorative circle -->
    <div class="absolute right-0 top-1/2 -translate-y-1/2 w-96 h-96 
                bg-white/5 rounded-full -mr-48 hidden lg:block"></div>
    <div class="absolute right-24 top-1/2 -translate-y-1/2 w-64 h-64 
                bg-white/5 rounded-full hidden lg:block"></div>
</section>

<!-- ══════════════════════════════════════════════
     CATEGORY PILLS
══════════════════════════════════════════════ -->
<section class="max-w-7xl mx-auto px-6 -mt-6 relative z-10">
    <div class="bg-white rounded-2xl shadow-xl border border-sage/20 p-6">
        <asp:Repeater ID="rptCategories" runat="server">
            <HeaderTemplate>
                <div class="flex flex-wrap gap-3 justify-center">
            </HeaderTemplate>
            <ItemTemplate>
                <a href='<%# "Shop.aspx?cat=" + Eval("CategoryId") %>'
                   class="category-pill flex items-center gap-2 bg-sage/10 
                          hover:bg-forest hover:text-white text-forest font-medium 
                          px-5 py-2.5 rounded-xl transition-all duration-200 text-sm">
                    <span class="category-icon text-lg">
                        <%# ViewHelpers.GetCategoryIcon(Eval("Name").ToString()) %>
                    </span>
                    <%# Eval("Name") %>
                </a>
            </ItemTemplate>
            <FooterTemplate>
                </div>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</section>

<!-- ══════════════════════════════════════════════
     FEATURED PRODUCTS
══════════════════════════════════════════════ -->
<section class="max-w-7xl mx-auto px-6 py-20">

    <div class="text-center mb-12">
        <p class="text-forest font-medium text-sm uppercase tracking-widest mb-2">
            — Freshly Picked —
        </p>
        <h2 class="font-display text-4xl font-bold text-gray-800">
            Featured Products
        </h2>
    </div>

    <asp:Repeater ID="rptFeatured" runat="server">
        <HeaderTemplate>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        </HeaderTemplate>

        <ItemTemplate>
            <div class="bg-white rounded-2xl overflow-hidden border border-sage/20 
                        product-card-hover group">

                <!-- Image -->
                <div class="relative h-52 bg-sage/10 overflow-hidden">
                    <asp:Image ID="imgProduct" runat="server"
                        ImageUrl='<%# ViewHelpers.GetImageUrl(Eval("ImageUrl")) %>'
                        AlternateText='<%# Eval("Name") %>'
                        CssClass="w-full h-full object-cover group-hover:scale-105 
                                  transition-transform duration-500" />

                    <%-- ✅ Use <%# not <%= inside databound templates --%>
                    <asp:Literal ID="litFeaturedBadge" runat="server"
                        Text='<%# ViewHelpers.GetFeaturedBadge(Eval("IsFeatured")) %>'
                        Mode="PassThrough" />
                </div>

                <!-- Info -->
                <div class="p-5">
                    <p class="text-xs text-gray-400 mb-1"><%# Eval("CategoryName") %></p>
                    <h3 class="font-display font-semibold text-gray-800 text-lg 
                               leading-tight mb-2">
                        <%# Eval("Name") %>
                    </h3>
                    <div class="flex items-end justify-between mt-4">
                        <div>
                            <p class="text-2xl font-bold text-forest">
                                $<%# Eval("Price", "{0:F2}") %>
                            </p>
                            <p class="text-xs text-gray-400"><%# Eval("Unit") %></p>
                        </div>
                        <a href='<%# "ProductDetail.aspx?id=" + Eval("ProductId") %>'
                           class="bg-forest text-white text-sm font-medium px-4 py-2 
                                  rounded-xl hover:bg-forest-dark transition-colors 
                                  btn-lift inline-block">
                            View
                        </a>
                    </div>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
            </div>
        </FooterTemplate>
    </asp:Repeater>

    <div class="text-center mt-10">
        <a href="Shop.aspx"
           class="inline-flex items-center gap-2 border-2 border-forest text-forest 
                  font-semibold px-8 py-3 rounded-xl hover:bg-forest hover:text-white 
                  transition-all duration-200 btn-lift">
            Browse All Products <span>→</span>
        </a>
    </div>
</section>

<!-- ══════════════════════════════════════════════
     WHY CHOOSE US
══════════════════════════════════════════════ -->
<section class="texture-bg bg-sage/10 py-20 px-6">
    <div class="max-w-7xl mx-auto">

        <div class="text-center mb-12 leaf-divider">
            <h2 class="font-display text-4xl font-bold text-gray-800">
                Why Choose Tan's Farm?
            </h2>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <% foreach (var feature in Features) { %>
            <div class="bg-white rounded-2xl p-6 text-center 
                        border border-sage/20 product-card-hover">
                <div class="text-4xl mb-4"><%=feature.Icon%></div>
                <h3 class="font-display font-semibold text-gray-800 text-lg mb-2">
                    <%=feature.Title%>
                </h3>
                <p class="text-gray-500 text-sm leading-relaxed">
                    <%=feature.Description%>
                </p>
            </div>
            <% } %>
        </div>

    </div>
</section>

<!-- ══════════════════════════════════════════════
     WEEKLY BOXES PROMO BANNER
══════════════════════════════════════════════ -->
<section class="max-w-7xl mx-auto px-6 py-20">
    <div class="bg-forest rounded-3xl p-10 md:p-16 text-white 
                flex flex-col md:flex-row items-center justify-between gap-8
                relative overflow-hidden">

        <!-- Background decoration -->
        <div class="absolute right-0 top-0 w-64 h-64 bg-white/5 
                    rounded-full -mr-20 -mt-20"></div>

        <div class="relative z-10 max-w-xl">
            <p class="text-sage text-sm font-medium uppercase tracking-widest mb-3">
                Save time & money
            </p>
            <h2 class="font-display text-4xl font-bold mb-4">
                Subscribe to a Weekly Produce Box
            </h2>
            <p class="text-white/70 leading-relaxed">
                Get a curated selection of the freshest seasonal produce delivered 
                to your door every week. Customise to your taste.
            </p>
        </div>

        <a href="ProduceBoxes.aspx"
           class="relative z-10 bg-white text-forest font-bold px-8 py-4 rounded-xl 
                  hover:bg-cream transition-colors btn-lift whitespace-nowrap 
                  flex-shrink-0 inline-block">
            Explore Boxes →
        </a>
    </div>
</section>

<!-- ══════════════════════════════════════════════
     TESTIMONIALS / TRUST
══════════════════════════════════════════════ -->
<section class="bg-forest-dark text-white py-20 px-6">
    <div class="max-w-4xl mx-auto text-center">
        <p class="text-sage text-sm uppercase tracking-widest mb-6">
            What Our Customers Say
        </p>
        <blockquote class="font-display text-3xl md:text-4xl italic font-light 
                           leading-relaxed text-white/90">
            "The freshest vegetables I've ever tasted. You can tell these were grown 
            with real care — our family won't buy from anywhere else now."
        </blockquote>
        <div class="mt-8 flex items-center justify-center gap-3">
            <div class="w-10 h-10 bg-sage/30 rounded-full flex items-center 
                        justify-center text-sm font-bold">
                S
            </div>
            <div class="text-left">
                <p class="font-semibold text-sm">Sarah Lim</p>
                <p class="text-white/40 text-xs">Weekly Box Subscriber</p>
            </div>
        </div>
    </div>
</section>

</asp:Content>