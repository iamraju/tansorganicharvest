<%@ Page Title="Sign In" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Login.aspx.cs"
    Inherits="TansOrganicHarvest.Account.Login" %>

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
    <div class="w-full max-w-md fade-up">

        <div class="bg-white rounded-3xl shadow-xl border border-sage/20 overflow-hidden">

            <!-- Header -->
            <div class="bg-forest px-8 py-10 text-center">
                <div class="text-4xl mb-3">🌿</div>
                <h1 class="font-display text-3xl font-bold text-white">
                    Welcome Back
                </h1>
                <p class="text-sage mt-2 text-sm">
                    Sign in to your Tan's Organic Harvest account
                </p>
            </div>

            <div class="px-8 py-8">

                <asp:Panel ID="pnlError" runat="server" Visible="false"
                    CssClass="bg-red-50 border border-red-200 text-red-700 
                              rounded-xl px-4 py-3 mb-6 text-sm flex items-center gap-2">
                    <span>⚠️</span>
                    <asp:Literal ID="litError" runat="server" />
                </asp:Panel>

                <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
                    CssClass="bg-green-50 border border-green-200 text-green-700 
                              rounded-xl px-4 py-3 mb-6 text-sm flex items-center gap-2">
                    <span>✅</span>
                    <asp:Literal ID="litSuccess" runat="server" />
                </asp:Panel>

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
                        Display="Dynamic" ValidationGroup="LoginForm" />
                </div>

                <!-- Password -->
                <div class="mb-3">
                    <label class="block text-sm font-semibold text-gray-700 mb-1.5">
                        Password <span class="text-red-500">*</span>
                    </label>
                    <div class="relative">
                        <asp:TextBox ID="txtPassword" runat="server"
                            TextMode="Password"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-3 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="Your password" />
                        <button type="button" onclick="togglePwd()"
                                class="absolute right-3 top-3 text-gray-400 
                                       hover:text-gray-600">👁</button>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password is required."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="LoginForm" />
                </div>

                <!-- Remember me -->
                <div class="flex items-center justify-between mb-6">
                    <label class="flex items-center gap-2 cursor-pointer">
                        <asp:CheckBox ID="chkRemember" runat="server" />
                        <span class="text-sm text-gray-600">Remember me</span>
                    </label>
                </div>

                <!-- Submit -->
                <asp:Button ID="btnLogin" runat="server"
                    Text="Sign In"
                    OnClick="btnLogin_Click"
                    ValidationGroup="LoginForm"
                    CssClass="w-full bg-forest hover:bg-forest-dark text-white 
                              font-bold py-3.5 rounded-xl transition-colors 
                              cursor-pointer text-sm" />

                <p class="text-center text-sm text-gray-500 mt-6">
                    Don't have an account?
                    <a href="/Account/Register.aspx"
                       class="text-forest font-semibold hover:underline">
                        Join for free
                    </a>
                </p>

            </div>
        </div>

    </div>
</div>

<script>
    function togglePwd() {
        var el = document.getElementById('<%= txtPassword.ClientID %>');
        if (el) el.type = el.type === 'password' ? 'text' : 'password';
    }
</script>

</asp:Content>