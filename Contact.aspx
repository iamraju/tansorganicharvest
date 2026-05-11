<%@ Page Title="Contact Us" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Contact.aspx.cs"
    Inherits="TansOrganicHarvest.Contact" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<!-- Hero -->
<div class="bg-forest py-16 px-6 text-white text-center">
    <p class="text-sage text-sm uppercase tracking-widest mb-2">Get In Touch</p>
    <h1 class="font-display text-5xl font-bold">Contact Us</h1>
    <p class="text-white/60 mt-3 max-w-md mx-auto">
        We'd love to hear from you — questions, feedback, or just to say hello.
    </p>
</div>

<div class="max-w-6xl mx-auto px-6 py-16">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">

        <!-- Left: Contact Info -->
        <div class="space-y-6">

            <div>
                <h2 class="font-display text-2xl font-bold text-gray-800 mb-6">
                    Find Us
                </h2>
            </div>

            <div class="flex items-start gap-4">
                <div class="w-10 h-10 bg-sage/20 rounded-xl flex items-center 
                            justify-center text-lg flex-shrink-0">📍</div>
                <div>
                    <p class="font-semibold text-gray-800 text-sm">Farm Address</p>
                    <p class="text-gray-500 text-sm mt-1 leading-relaxed">
                        123 Harvest Lane<br/>
                        Green Valley, 50480<br/>
                        Kuala Lumpur, Malaysia
                    </p>
                </div>
            </div>

            <div class="flex items-start gap-4">
                <div class="w-10 h-10 bg-sage/20 rounded-xl flex items-center 
                            justify-center text-lg flex-shrink-0">📞</div>
                <div>
                    <p class="font-semibold text-gray-800 text-sm">Phone</p>
                    <p class="text-gray-500 text-sm mt-1">+60 12-345 6789</p>
                    <p class="text-gray-400 text-xs mt-0.5">Mon–Sat, 8am–5pm</p>
                </div>
            </div>

            <div class="flex items-start gap-4">
                <div class="w-10 h-10 bg-sage/20 rounded-xl flex items-center 
                            justify-center text-lg flex-shrink-0">✉️</div>
                <div>
                    <p class="font-semibold text-gray-800 text-sm">Email</p>
                    <p class="text-gray-500 text-sm mt-1">
                        hello@tansorganic.com
                    </p>
                    <p class="text-gray-400 text-xs mt-0.5">
                        We reply within 24 hours
                    </p>
                </div>
            </div>

            <div class="flex items-start gap-4">
                <div class="w-10 h-10 bg-sage/20 rounded-xl flex items-center 
                            justify-center text-lg flex-shrink-0">🕐</div>
                <div>
                    <p class="font-semibold text-gray-800 text-sm">Farm Pickup Hours</p>
                    <p class="text-gray-500 text-sm mt-1 leading-relaxed">
                        Tuesday – Saturday<br/>
                        8:00 AM – 1:00 PM
                    </p>
                    <p class="text-gray-400 text-xs mt-1">Closed Sunday & Monday</p>
                </div>
            </div>

            <!-- Map placeholder -->
            <div class="bg-sage/10 rounded-2xl h-48 flex items-center 
                        justify-center border border-sage/20 mt-4">
                <div class="text-center text-gray-400">
                    <div class="text-4xl mb-2">🗺️</div>
                    <p class="text-sm">Tan's Organic Farm</p>
                    <p class="text-xs mt-1">Green Valley, KL</p>
                </div>
            </div>

        </div>

        <!-- Right: Feedback Form -->
        <div class="lg:col-span-2">

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
                CssClass="bg-green-50 border border-green-200 rounded-2xl 
                          p-8 text-center mb-6">
                <div class="text-5xl mb-4">✅</div>
                <h3 class="font-display text-2xl font-bold text-green-800 mb-2">
                    Message Sent!
                </h3>
                <p class="text-green-700 text-sm">
                    Thank you for reaching out. We'll get back to you within 24 hours.
                </p>
                <a href="/Contact.aspx"
                   class="inline-block mt-4 text-green-700 font-semibold 
                          hover:underline text-sm">
                    Send another message →
                </a>
            </asp:Panel>

            <asp:Panel ID="pnlForm" runat="server"
                CssClass="bg-white rounded-2xl border border-sage/20 shadow-sm p-8">

                <h2 class="font-display text-2xl font-bold text-gray-800 mb-6">
                    Send Us a Message
                </h2>

                <asp:Panel ID="pnlError" runat="server" Visible="false"
                    CssClass="bg-red-50 border border-red-200 text-red-700 
                              rounded-xl px-4 py-3 mb-5 text-sm flex items-center gap-2">
                    <span>⚠️</span>
                    <asp:Literal ID="litError" runat="server" />
                </asp:Panel>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">

                    <!-- Name -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Your Name <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtName" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="Your full name" />
                        <asp:RequiredFieldValidator ID="rfvName" runat="server"
                            ControlToValidate="txtName"
                            ErrorMessage="Name is required."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="FeedbackForm" />
                    </div>

                    <!-- Email -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Email Address <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtEmail" runat="server"
                            TextMode="Email"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="you@example.com" />
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                            ControlToValidate="txtEmail"
                            ErrorMessage="Email is required."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="FeedbackForm" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server"
                            ControlToValidate="txtEmail"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                            ErrorMessage="Enter a valid email."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="FeedbackForm" />
                    </div>

                </div>

                <!-- Subject -->
                <div class="mb-5">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Subject <span class="text-red-500">*</span>
                    </label>
                    <asp:TextBox ID="txtSubject" runat="server"
                        CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-forest/30 focus:border-forest transition"
                        placeholder="What is your message about?" />
                    <asp:RequiredFieldValidator ID="rfvSubject" runat="server"
                        ControlToValidate="txtSubject"
                        ErrorMessage="Subject is required."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="FeedbackForm" />
                </div>

                <!-- Category -->
                <div class="mb-5">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Category
                    </label>
                    <asp:DropDownList ID="ddlCategory" runat="server"
                        CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-forest/30 focus:border-forest bg-white">
                        <asp:ListItem Text="General Enquiry"    Value="General" />
                        <asp:ListItem Text="Product Quality"    Value="Product Quality" />
                        <asp:ListItem Text="Delivery Issue"     Value="Delivery" />
                        <asp:ListItem Text="Order Problem"      Value="Order" />
                        <asp:ListItem Text="Suggestion"         Value="Suggestion" />
                        <asp:ListItem Text="Other"              Value="Other" />
                    </asp:DropDownList>
                </div>

                <!-- Message -->
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Message <span class="text-red-500">*</span>
                    </label>
                    <asp:TextBox ID="txtMessage" runat="server"
                        TextMode="MultiLine" Rows="6"
                        CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-forest/30 focus:border-forest 
                                  transition resize-none"
                        placeholder="Tell us how we can help you..." />
                    <asp:RequiredFieldValidator ID="rfvMessage" runat="server"
                        ControlToValidate="txtMessage"
                        ErrorMessage="Message is required."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="FeedbackForm" />
                    <asp:RegularExpressionValidator ID="revMessage" runat="server"
                        ControlToValidate="txtMessage"
                        ValidationExpression="[\s\S]{10,}"
                        ErrorMessage="Message must be at least 10 characters."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="FeedbackForm" />
                </div>

                <asp:Button ID="btnSubmit" runat="server"
                    Text="Send Message"
                    OnClick="btnSubmit_Click"
                    ValidationGroup="FeedbackForm"
                    CssClass="w-full bg-forest hover:bg-forest-dark text-white 
                              font-bold py-3.5 rounded-xl transition-colors 
                              cursor-pointer text-sm" />

            </asp:Panel>
        </div>

    </div>
</div>

</asp:Content>