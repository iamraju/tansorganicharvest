<%@ Page Title="Weekly Produce Boxes" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ProduceBoxes.aspx.cs"
    Inherits="TansOrganicHarvest.ProduceBoxes" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    @keyframes fadeUp {
        from { opacity:0; transform:translateY(20px); }
        to   { opacity:1; transform:translateY(0); }
    }
    .fade-up { animation: fadeUp 0.5s ease forwards; }
</style>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<!-- Hero -->
<div class="bg-forest py-20 px-6 text-white text-center relative overflow-hidden">
    <div class="relative z-10 max-w-2xl mx-auto">
        <p class="text-sage text-sm uppercase tracking-widest mb-3">
            Fresh Every Week
        </p>
        <h1 class="font-display text-5xl font-bold mb-4">
            Weekly Produce Boxes
        </h1>
        <p class="text-white/70 text-lg leading-relaxed">
            A handpicked selection of the freshest seasonal produce 
            delivered to your door every week. No hassle, just freshness.
        </p>
    </div>
    <div class="absolute right-0 top-0 w-64 h-64 bg-white/5 
                rounded-full -mr-20 -mt-20"></div>
</div>

<!-- Benefits bar -->
<div class="bg-white border-b border-sage/20">
    <div class="max-w-5xl mx-auto px-6 py-5 flex flex-wrap 
                justify-center gap-8 text-sm text-gray-600">
        <span class="flex items-center gap-2">
            <span class="text-forest text-lg">🌱</span>
            100% Organic
        </span>
        <span class="flex items-center gap-2">
            <span class="text-forest text-lg">🚚</span>
            Free delivery over $50
        </span>
        <span class="flex items-center gap-2">
            <span class="text-forest text-lg">📅</span>
            Delivered weekly
        </span>
        <span class="flex items-center gap-2">
            <span class="text-forest text-lg">✂️</span>
            Cancel anytime
        </span>
    </div>
</div>

<!-- Boxes grid -->
<div class="max-w-7xl mx-auto px-6 py-16">

    <div class="text-center mb-12">
        <h2 class="font-display text-4xl font-bold text-gray-800">
            Choose Your Box
        </h2>
        <p class="text-gray-500 mt-3 max-w-md mx-auto">
            Each box is carefully packed with the freshest seasonal produce, 
            harvested within 48 hours of delivery.
        </p>
    </div>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false"
        CssClass="text-center py-16">
        <div class="text-5xl mb-3">📦</div>
        <p class="text-gray-400">No boxes available at the moment.</p>
    </asp:Panel>

    <asp:Repeater ID="rptBoxes" runat="server">
        <HeaderTemplate>
            <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-8">
        </HeaderTemplate>
        <ItemTemplate>
            <div class="bg-white rounded-3xl overflow-hidden border border-sage/20 
                        shadow-sm product-card-hover flex flex-col">

                <!-- Image -->
                <div class="h-56 bg-sage/10 overflow-hidden relative">
                    <asp:Image ID="imgBox" runat="server"
                        ImageUrl='<%# ViewHelpers.GetImageUrl(Eval("ImageUrl")) %>'
                        AlternateText='<%# Eval("Name") %>'
                        CssClass="w-full h-full object-cover" />
                    <div class="absolute inset-0 bg-gradient-to-t 
                                from-black/30 to-transparent"></div>
                    <div class="absolute bottom-4 left-4">
                        <span class="bg-white text-forest font-bold text-xl px-3 
                                     py-1 rounded-xl shadow">
                            $<%# Eval("Price", "{0:F2}") %>
                        </span>
                        <span class="text-white text-xs ml-1">/ box</span>
                    </div>
                </div>

                <!-- Content -->
                <div class="p-6 flex flex-col flex-1">
                    <h3 class="font-display text-2xl font-bold text-gray-800 mb-2">
                        <%# Eval("Name") %>
                    </h3>
                    <p class="text-gray-500 text-sm leading-relaxed mb-5">
                        <%# Eval("Description") %>
                    </p>

                    <!-- Contents list -->
                    <asp:Panel ID="pnlContents" runat="server"
                        Visible='<%# !string.IsNullOrEmpty(Eval("Contents") as string) %>'
                        CssClass="bg-sage/10 rounded-2xl p-4 mb-5">
                        <p class="text-xs font-semibold text-forest uppercase 
                                   tracking-wider mb-3">
                            What's Inside:
                        </p>
                        <asp:Repeater ID="rptContents" runat="server"
                            DataSource='<%# GetContents(Eval("Contents")) %>'>
                            <ItemTemplate>
                                <div class="flex items-center gap-2 text-sm 
                                            text-gray-700 mb-1.5">
                                    <span class="text-forest">✓</span>
                                    <%# Container.DataItem %>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </asp:Panel>

                    <!-- CTA -->
                    <div class="mt-auto">
                        <asp:LoginView ID="lvBox" runat="server">
                            <AnonymousTemplate>
                                <a href="/Account/Login.aspx"
                                   class="block w-full bg-forest hover:bg-forest-dark 
                                          text-white font-bold py-3.5 rounded-2xl 
                                          text-center text-sm transition-colors">
                                    Sign In to Order
                                </a>
                            </AnonymousTemplate>
                            <LoggedInTemplate>
                                <a href='<%# "/Shop.aspx" %>'
                                   class="block w-full bg-forest hover:bg-forest-dark 
                                          text-white font-bold py-3.5 rounded-2xl 
                                          text-center text-sm transition-colors">
                                    Add to Cart
                                </a>
                            </LoggedInTemplate>
                        </asp:LoginView>
                        <p class="text-xs text-gray-400 text-center mt-2">
                            Free delivery on orders over $50
                        </p>
                    </div>

                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
            </div>
        </FooterTemplate>
    </asp:Repeater>

</div>

<!-- How it works -->
<section class="bg-sage/10 py-20 px-6">
    <div class="max-w-5xl mx-auto">
        <h2 class="font-display text-4xl font-bold text-gray-800 
                    text-center mb-12">
            How It Works
        </h2>
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6">

            <div class="text-center">
                <div class="w-14 h-14 bg-forest rounded-2xl flex items-center 
                            justify-center text-2xl mx-auto mb-4">
                    1️⃣
                </div>
                <h3 class="font-semibold text-gray-800 mb-2">Choose a Box</h3>
                <p class="text-gray-500 text-sm">
                    Pick the box that suits your household size and needs.
                </p>
            </div>

            <div class="text-center">
                <div class="w-14 h-14 bg-forest rounded-2xl flex items-center 
                            justify-center text-2xl mx-auto mb-4">
                    2️⃣
                </div>
                <h3 class="font-semibold text-gray-800 mb-2">We Harvest</h3>
                <p class="text-gray-500 text-sm">
                    Our farmers pick your produce fresh within 48 hours.
                </p>
            </div>

            <div class="text-center">
                <div class="w-14 h-14 bg-forest rounded-2xl flex items-center 
                            justify-center text-2xl mx-auto mb-4">
                    3️⃣
                </div>
                <h3 class="font-semibold text-gray-800 mb-2">We Pack</h3>
                <p class="text-gray-500 text-sm">
                    Carefully packed to keep everything crisp and fresh.
                </p>
            </div>

            <div class="text-center">
                <div class="w-14 h-14 bg-forest rounded-2xl flex items-center 
                            justify-center text-2xl mx-auto mb-4">
                    4️⃣
                </div>
                <h3 class="font-semibold text-gray-800 mb-2">We Deliver</h3>
                <p class="text-gray-500 text-sm">
                    Right to your door, or pick up from our farm.
                </p>
            </div>

        </div>
    </div>
</section>

<!-- FAQ preview -->
<section class="max-w-3xl mx-auto px-6 py-16">
    <h2 class="font-display text-3xl font-bold text-gray-800 
                text-center mb-8">
        Common Questions
    </h2>
    <div class="space-y-3">
        <div class="bg-white rounded-2xl border border-sage/20 px-6 py-4">
            <p class="font-semibold text-gray-800 text-sm">
                Can I customise my box?
            </p>
            <p class="text-gray-500 text-sm mt-1">
                Registered members can request substitutions. Contact us 
                at least 48 hours before your delivery.
            </p>
        </div>
        <div class="bg-white rounded-2xl border border-sage/20 px-6 py-4">
            <p class="font-semibold text-gray-800 text-sm">
                How often are boxes delivered?
            </p>
            <p class="text-gray-500 text-sm mt-1">
                Boxes are delivered once per week on your chosen day. 
                You can pause or cancel anytime.
            </p>
        </div>
        <div class="bg-white rounded-2xl border border-sage/20 px-6 py-4">
            <p class="font-semibold text-gray-800 text-sm">
                What if I'm not home for delivery?
            </p>
            <p class="text-gray-500 text-sm mt-1">
                We'll leave it in a safe spot you specify. Alternatively, 
                choose farm pickup at checkout.
            </p>
        </div>
    </div>
    <div class="text-center mt-8">
        <a href="/FAQ.aspx"
           class="text-forest font-semibold hover:underline text-sm">
            See all FAQs →
        </a>
    </div>
</section>

</asp:Content>