<%@ Page Language="C#" AutoEventWireup="true" 
    CodeBehind="TestDB.aspx.cs" 
    Inherits="TansOrganicHarvest.Admin.TestDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>DB Test</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="p-8 bg-gray-100">
<form runat="server">

    <div class="max-w-2xl bg-white rounded-xl shadow p-6">
        <h1 class="text-xl font-bold mb-4">Database Connection Test</h1>

        <asp:Button ID="btnTest" runat="server" Text="Test Connection"
            OnClick="btnTest_Click"
            CssClass="bg-blue-600 text-white px-4 py-2 rounded mb-4 cursor-pointer" />

        <asp:Button ID="btnTestAdmin" runat="server" Text="Check Admin Table"
            OnClick="btnTestAdmin_Click"
            CssClass="bg-green-600 text-white px-4 py-2 rounded mb-4 ml-2 cursor-pointer" />

        <asp:Button ID="btnTestLogin" runat="server" Text="Test Login Query"
            OnClick="btnTestLogin_Click"
            CssClass="bg-purple-600 text-white px-4 py-2 rounded mb-4 ml-2 cursor-pointer" />

        <div class="mt-4 p-4 bg-gray-50 rounded-lg font-mono text-sm">
            <asp:Literal ID="litResult" runat="server" Text="Click a button to test." />
        </div>

        <div class="mt-4">
            <h2 class="font-semibold mb-2">Connection String in use:</h2>
            <div class="p-3 bg-yellow-50 rounded font-mono text-xs break-all">
                <asp:Literal ID="litConnStr" runat="server" />
            </div>
        </div>
    </div>

</form>
</body>
</html>