<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="AdminLogin.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.AdminLogin" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Login — Tan's Organic Harvest</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-[#1b4332] to-[#2d6a4f] 
             min-h-screen flex items-center justify-center">

<%-- ONE form tag, no master page --%>
<form id="LoginForm" runat="server">

    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-8">

        <div class="text-center mb-8">
            <div class="text-5xl mb-3">🌿</div>
            <h1 class="text-2xl font-bold text-[#2d6a4f]">Tan's Organic Harvest</h1>
            <p class="text-gray-500 text-sm mt-1">Admin Panel — Sign In</p>
        </div>

        <asp:Panel ID="pnlError" runat="server" Visible="false"
            CssClass="bg-red-50 border border-red-200 text-red-700 rounded-lg 
                      px-4 py-3 mb-5 text-sm">
            <asp:Literal ID="litError" runat="server" />
        </asp:Panel>

        <div class="mb-5">
            <label class="block text-sm font-medium text-gray-700 mb-1.5">
                Username
            </label>
            <asp:TextBox ID="txtUsername" runat="server"
                CssClass="w-full border border-gray-300 rounded-lg px-4 py-2.5 text-sm
                          focus:outline-none focus:ring-2 focus:ring-[#2d6a4f]"
                placeholder="Enter your username" />
            <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                ControlToValidate="txtUsername"
                ErrorMessage="Username is required."
                CssClass="text-red-500 text-xs mt-1 block"
                Display="Dynamic" />
        </div>

        <div class="mb-6">
            <label class="block text-sm font-medium text-gray-700 mb-1.5">
                Password
            </label>
            <asp:TextBox ID="txtPassword" runat="server"
                TextMode="Password"
                CssClass="w-full border border-gray-300 rounded-lg px-4 py-2.5 text-sm
                          focus:outline-none focus:ring-2 focus:ring-[#2d6a4f]"
                placeholder="Enter your password" />
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                ControlToValidate="txtPassword"
                ErrorMessage="Password is required."
                CssClass="text-red-500 text-xs mt-1 block"
                Display="Dynamic" />
        </div>

        <asp:Button ID="btnLogin" runat="server"
            Text="Sign In"
            OnClick="btnLogin_Click"
            CssClass="w-full bg-[#2d6a4f] hover:bg-[#1b4332] text-white 
                      font-semibold py-2.5 rounded-lg cursor-pointer text-sm" />

    </div>

</form>

<script>
    function togglePassword() {
        var pwd = document.getElementById('<%= txtPassword.ClientID %>');
        pwd.type = pwd.type === 'password' ? 'text' : 'password';
    }
</script>
</body>
</html>