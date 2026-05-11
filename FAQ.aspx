<%@ Page Title="FAQ" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="FAQ.aspx.cs"
    Inherits="TansOrganicHarvest.FAQ" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .faq-item input[type=checkbox]:checked + label + div {
        display: block;
    }
    .faq-item input[type=checkbox]:checked + label .faq-icon {
        transform: rotate(45deg);
    }
    .faq-icon { transition: transform 0.2s ease; }
</style>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<!-- Hero -->
<div class="bg-forest py-16 px-6 text-white text-center">
    <p class="text-sage text-sm uppercase tracking-widest mb-2">
        Got Questions?
    </p>
    <h1 class="font-display text-5xl font-bold">
        Frequently Asked Questions
    </h1>
    <p class="text-white/60 mt-3 max-w-md mx-auto">
        Everything you need to know about our farm, products, and ordering.
    </p>
</div>

<div class="max-w-3xl mx-auto px-6 py-16">

    <asp:Repeater ID="rptFAQ" runat="server">
        <ItemTemplate>
            <div class="faq-item mb-3">
                <input type="checkbox"
                       id='faq_<%# Eval("FAQId") %>'
                       class="sr-only" />
                <label for='faq_<%# Eval("FAQId") %>'
                       class="flex items-center justify-between w-full 
                              bg-white border border-sage/20 rounded-2xl 
                              px-6 py-5 cursor-pointer hover:border-forest/30 
                              transition-colors shadow-sm">
                    <span class="font-semibold text-gray-800 pr-4">
                        <%# Eval("Question") %>
                    </span>
                    <span class="faq-icon text-forest text-2xl font-light 
                                 flex-shrink-0">+</span>
                </label>
                <div class="hidden bg-sage/5 border border-t-0 border-sage/20 
                            rounded-b-2xl px-6 py-5 -mt-2">
                    <p class="text-gray-600 leading-relaxed text-sm">
                        <%# Eval("Answer") %>
                    </p>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <!-- Still have questions -->
    <div class="bg-forest rounded-2xl p-8 text-white text-center mt-10">
        <div class="text-4xl mb-3">💬</div>
        <h3 class="font-display text-2xl font-bold mb-2">
            Still have questions?
        </h3>
        <p class="text-white/70 text-sm mb-6">
            Can't find what you're looking for? Send us a message.
        </p>
        <a href="/Contact.aspx"
           class="bg-white text-forest font-bold px-8 py-3 rounded-xl 
                  hover:bg-cream transition-colors inline-block">
            Contact Us
        </a>
    </div>

</div>

</asp:Content>