<%@ Page Title="Our Farm" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="About.aspx.cs"
    Inherits="TansOrganicHarvest.About" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    @keyframes fadeUp {
        from { opacity:0; transform:translateY(24px); }
        to   { opacity:1; transform:translateY(0); }
    }
    .fade-up   { animation: fadeUp 0.6s ease forwards; }
    .fade-up-2 { animation: fadeUp 0.6s 0.15s ease both; }
</style>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<!-- Hero -->
<section class="bg-forest-dark text-white py-24 px-6 relative overflow-hidden">
    <div class="max-w-7xl mx-auto relative z-10">
        <div class="max-w-2xl fade-up">
            <p class="text-sage text-sm uppercase tracking-widest mb-3">
                Est. 1998
            </p>
            <h1 class="font-display text-6xl font-bold leading-tight mb-6">
                Our Farm,<br/>
                <span class="text-sage italic">Our Story</span>
            </h1>
            <p class="text-white/70 text-lg leading-relaxed">
                For over 25 years, the Tan family has been nurturing the land 
                and growing food the way nature intended — without shortcuts, 
                without chemicals, with plenty of love.
            </p>
        </div>
    </div>
    <div class="absolute right-0 top-0 w-96 h-96 bg-white/5 
                rounded-full -mr-48 -mt-24"></div>
</section>

<!-- Story Section -->
<section class="max-w-7xl mx-auto px-6 py-20">
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">

        <div>
            <p class="text-forest font-medium text-sm uppercase 
                       tracking-widest mb-3">
                — How It Started —
            </p>
            <h2 class="font-display text-4xl font-bold text-gray-800 
                        leading-tight mb-6">
                A Family Farm Built on Trust
            </h2>
            <div class="space-y-4 text-gray-600 leading-relaxed">
                <p>
                    In 1998, Mr. and Mrs. Tan planted their first crop of 
                    vegetables on a small plot of land in Green Valley. What 
                    began as a way to feed their own family soon grew into 
                    something much bigger.
                </p>
                <p>
                    Word spread among neighbours about the exceptional quality 
                    of the Tan's produce — tomatoes that actually tasted like 
                    tomatoes, honey that was raw and unfiltered, vegetables 
                    harvested the same morning they were sold.
                </p>
                <p>
                    Today, three generations of the Tan family tend to over 
                    15 acres of certified organic farmland, growing more than 
                    30 varieties of fruits, vegetables, and honey.
                </p>
            </div>
        </div>

        <!-- Farm stats -->
        <div class="grid grid-cols-2 gap-5">
            <div class="bg-forest rounded-2xl p-6 text-white text-center">
                <p class="font-display text-5xl font-bold">25+</p>
                <p class="text-sage text-sm mt-1">Years Farming</p>
            </div>
            <div class="bg-sage/20 rounded-2xl p-6 text-forest text-center">
                <p class="font-display text-5xl font-bold">15</p>
                <p class="text-forest/70 text-sm mt-1">Acres of Land</p>
            </div>
            <div class="bg-sage/20 rounded-2xl p-6 text-forest text-center">
                <p class="font-display text-5xl font-bold">30+</p>
                <p class="text-forest/70 text-sm mt-1">Varieties Grown</p>
            </div>
            <div class="bg-forest rounded-2xl p-6 text-white text-center">
                <p class="font-display text-5xl font-bold">0</p>
                <p class="text-sage text-sm mt-1">Chemicals Used</p>
            </div>
        </div>

    </div>
</section>

<!-- Values Section -->
<section class="bg-sage/10 py-20 px-6">
    <div class="max-w-7xl mx-auto">
        <div class="text-center mb-12">
            <h2 class="font-display text-4xl font-bold text-gray-800">
                What We Stand For
            </h2>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

            <div class="bg-white rounded-2xl p-8 border border-sage/20 
                        text-center">
                <div class="text-5xl mb-4">🌱</div>
                <h3 class="font-display text-xl font-bold text-gray-800 mb-3">
                    Organic Always
                </h3>
                <p class="text-gray-500 text-sm leading-relaxed">
                    Every seed, every drop of water, every harvest — 
                    completely free from synthetic pesticides and fertilisers. 
                    This is non-negotiable for us.
                </p>
            </div>

            <div class="bg-white rounded-2xl p-8 border border-sage/20 
                        text-center">
                <div class="text-5xl mb-4">🤝</div>
                <h3 class="font-display text-xl font-bold text-gray-800 mb-3">
                    Community First
                </h3>
                <p class="text-gray-500 text-sm leading-relaxed">
                    We partner with local families, offer fair prices, and 
                    believe healthy food should be accessible to everyone 
                    in our community.
                </p>
            </div>

            <div class="bg-white rounded-2xl p-8 border border-sage/20 
                        text-center">
                <div class="text-5xl mb-4">♻️</div>
                <h3 class="font-display text-xl font-bold text-gray-800 mb-3">
                    Sustainable Future
                </h3>
                <p class="text-gray-500 text-sm leading-relaxed">
                    From composting waste to rainwater harvesting, we make 
                    every decision with the next generation in mind.
                </p>
            </div>

        </div>
    </div>
</section>

<!-- Meet the Family -->
<section class="max-w-7xl mx-auto px-6 py-20">
    <div class="text-center mb-12">
        <h2 class="font-display text-4xl font-bold text-gray-800">
            Meet the Tans
        </h2>
        <p class="text-gray-500 mt-3 max-w-md mx-auto">
            Three generations, one mission — growing food you can trust.
        </p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">

        <div class="text-center">
            <div class="w-24 h-24 bg-forest rounded-full flex items-center 
                        justify-center text-4xl mx-auto mb-4">
                👨‍🌾
            </div>
            <h3 class="font-display text-xl font-bold text-gray-800">
                Mr. Tan Wei Liang
            </h3>
            <p class="text-forest text-sm font-medium mt-1">Founder & Head Farmer</p>
            <p class="text-gray-500 text-sm mt-3 leading-relaxed">
                Started the farm in 1998 after leaving corporate life to 
                pursue a healthier way of living and growing food.
            </p>
        </div>

        <div class="text-center">
            <div class="w-24 h-24 bg-sage rounded-full flex items-center 
                        justify-center text-4xl mx-auto mb-4">
                👩‍🍳
            </div>
            <h3 class="font-display text-xl font-bold text-gray-800">
                Mrs. Tan Mei Ling
            </h3>
            <p class="text-forest text-sm font-medium mt-1">Co-Founder & Recipe Creator</p>
            <p class="text-gray-500 text-sm mt-3 leading-relaxed">
                The creative force behind our jams and honey products. 
                Every jar is made with a recipe she has perfected over decades.
            </p>
        </div>

        <div class="text-center">
            <div class="w-24 h-24 bg-earth/30 rounded-full flex items-center 
                        justify-center text-4xl mx-auto mb-4">
                👨‍💻
            </div>
            <h3 class="font-display text-xl font-bold text-gray-800">
                Tan Jun Hao
            </h3>
            <p class="text-forest text-sm font-medium mt-1">Operations & Online Store</p>
            <p class="text-gray-500 text-sm mt-3 leading-relaxed">
                The second generation Tan who brought the farm online and 
                made it possible for customers across the city to enjoy 
                fresh organic produce.
            </p>
        </div>

    </div>
</section>

<!-- CTA -->
<section class="bg-forest py-16 px-6 text-white text-center">
    <h2 class="font-display text-4xl font-bold mb-4">
        Taste the Difference
    </h2>
    <p class="text-white/70 max-w-md mx-auto mb-8">
        Join thousands of families who trust Tan's Organic Harvest 
        for their weekly produce.
    </p>
    <div class="flex flex-wrap justify-center gap-4">
        <a href="/Shop.aspx"
           class="bg-white text-forest font-bold px-8 py-3.5 rounded-xl 
                  hover:bg-cream transition-colors">
            Shop Now →
        </a>
        <a href="/Contact.aspx"
           class="border-2 border-white/40 text-white font-semibold 
                  px-8 py-3.5 rounded-xl hover:bg-white/10 transition-colors">
            Contact Us
        </a>
    </div>
</section>

</asp:Content>