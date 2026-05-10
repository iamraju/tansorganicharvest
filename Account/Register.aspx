<%@ Page Title="Register" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Register.aspx.cs"
    Inherits="TansOrganicHarvest.Account.Register" %>

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

<div class="min-h-screen bg-gradient-to-br from-sage/20 to-cream 
            py-16 px-4 flex items-center justify-center">
    <div class="w-full max-w-lg fade-up">

        <!-- Card -->
        <div class="bg-white rounded-3xl shadow-xl border border-sage/20 
                    overflow-hidden">

            <!-- Header -->
            <div class="bg-forest px-8 py-10 text-center">
                <div class="text-4xl mb-3">🌿</div>
                <h1 class="font-display text-3xl font-bold text-white">
                    Join Our Farm Family
                </h1>
                <p class="text-sage mt-2 text-sm">
                    Create your account to start ordering fresh organic produce
                </p>
            </div>

            <!-- Form -->
            <div class="px-8 py-8">

                <asp:Panel ID="pnlError" runat="server" Visible="false"
                    CssClass="bg-red-50 border border-red-200 text-red-700 
                              rounded-xl px-4 py-3 mb-6 text-sm flex items-start gap-2">
                    <span class="mt-0.5">⚠️</span>
                    <asp:Literal ID="litError" runat="server" />
                </asp:Panel>

                <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
                    CssClass="bg-green-50 border border-green-200 text-green-700 
                              rounded-xl px-4 py-3 mb-6 text-sm flex items-start gap-2">
                    <span>✅</span>
                    <asp:Literal ID="litSuccess" runat="server" />
                </asp:Panel>

                <!-- Full Name -->
                <div class="mb-5">
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">
                        Full Name <span class="text-red-500">*</span>
                    </label>
                    <asp:TextBox ID="txtFullName" runat="server"
                        CssClass="w-full border border-gray-200 rounded-xl px-4 py-3 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-forest/30 focus:border-forest transition"
                        placeholder="Your full name" />
                    <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                        ControlToValidate="txtFullName"
                        ErrorMessage="Full name is required."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="RegisterForm" />
                </div>

                <!-- Email -->
                <div class="mb-5">
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">
                        Email Address <span class="text-red-500">*</span>
                    </label>
                    <asp:TextBox ID="txtEmail" runat="server"
                        TextMode="Email"
                        CssClass="w-full border border-gray-200 rounded-xl px-4 py-3 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-forest/30 focus:border-forest transition"
                        placeholder="you@example.com" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Email is required."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="RegisterForm" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server"
                        ControlToValidate="txtEmail"
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                        ErrorMessage="Enter a valid email address."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="RegisterForm" />
                </div>

                <!-- Phone -->
                <div class="mb-5">
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">
                        Phone Number
                    </label>
                    <asp:TextBox ID="txtPhone" runat="server"
                        CssClass="w-full border border-gray-200 rounded-xl px-4 py-3 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-forest/30 focus:border-forest transition"
                        placeholder="+60 12-345 6789" />
                </div>

                <!-- Password -->
                <div class="mb-5">
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">
                        Password <span class="text-red-500">*</span>
                    </label>
                    <div class="relative">
                        <asp:TextBox ID="txtPassword" runat="server"
                            TextMode="Password"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-3 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="Minimum 6 characters" />
                        <button type="button" onclick="togglePwd('txtPwd')"
                                class="absolute right-3 top-3 text-gray-400 
                                       hover:text-gray-600 text-sm">👁</button>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password is required."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="RegisterForm" />
                    <asp:RegularExpressionValidator ID="revPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ValidationExpression="^.{6,}$"
                        ErrorMessage="Password must be at least 6 characters."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="RegisterForm" />
                </div>

                <!-- Confirm Password -->
                <div class="mb-6">
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">
                        Confirm Password <span class="text-red-500">*</span>
                    </label>
                    <div class="relative">
                        <asp:TextBox ID="txtConfirmPassword" runat="server"
                            TextMode="Password"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-3 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="Repeat your password" />
                        <button type="button" onclick="togglePwd('txtConfirmPwd')"
                                class="absolute right-3 top-3 text-gray-400 
                                       hover:text-gray-600 text-sm">👁</button>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvConfirm" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Please confirm your password."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="RegisterForm" />
                    <asp:CompareValidator ID="cvPassword" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtPassword"
                        ErrorMessage="Passwords do not match."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="RegisterForm" />
                </div>

                <!-- Submit -->
                <asp:Button ID="btnRegister" runat="server"
                    Text="Create My Account"
                    OnClick="btnRegister_Click"
                    ValidationGroup="RegisterForm"
                    CssClass="w-full bg-forest hover:bg-forest-dark text-white 
                              font-bold py-3.5 rounded-xl transition-colors 
                              cursor-pointer text-sm btn-lift" />

                <p class="text-center text-sm text-gray-500 mt-6">
                    Already have an account?
                    <a href="/Account/Login.aspx"
                       class="text-forest font-semibold hover:underline">
                        Sign in here
                    </a>
                </p>

            </div>
        </div>

        <!-- Trust badges -->
        <div class="flex justify-center gap-8 mt-6 text-xs text-gray-400">
            <span>🔒 Secure &amp; Private</span>
            <span>🌿 No Spam Ever</span>
            <span>✅ Free to Join</span>
        </div>

    </div>
</div>

<script>
    function togglePwd(id) {
        var el = document.getElementById(id);
        if (el) el.type = el.type === 'password' ? 'text' : 'password';
    }
</script>

</asp:Content>