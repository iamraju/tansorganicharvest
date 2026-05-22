<%@ Page Title="Change Password" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs"
    Inherits="TansOrganicHarvest.Members.ChangePassword" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<div class="bg-forest py-12 px-6 text-white text-center">
    <h1 class="font-display text-4xl font-bold">Change Password</h1>
    <p class="text-white/60 mt-2 text-sm">Keep your account secure</p>
</div>

<div class="max-w-lg mx-auto px-6 py-12">

    <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-8">

        <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
            CssClass="bg-green-50 border border-green-200 text-green-700 rounded-xl 
                      px-4 py-3 mb-6 text-sm flex items-center gap-2">
            <span>✅</span>
            Password changed successfully.
            <a href="/Members/Profile.aspx"
               class="underline font-semibold ml-1">
                Back to Profile
            </a>
        </asp:Panel>

        <asp:Panel ID="pnlError" runat="server" Visible="false"
            CssClass="bg-red-50 border border-red-200 text-red-700 rounded-xl 
                      px-4 py-3 mb-6 text-sm flex items-center gap-2">
            <span>⚠️</span><asp:Literal ID="litError" runat="server" />
        </asp:Panel>

        <asp:Panel ID="pnlForm" runat="server">

            <div class="mb-5">
                <label class="block text-sm font-medium text-gray-700 mb-1.5">
                    Current Password <span class="text-red-500">*</span>
                </label>
                <asp:TextBox ID="txtCurrentPassword" runat="server"
                    TextMode="Password"
                    CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                              text-sm focus:outline-none focus:ring-2 
                              focus:ring-forest/30 focus:border-forest transition"
                    placeholder="Enter current password" />
                <asp:RequiredFieldValidator ID="rfvCurrent" runat="server"
                    ControlToValidate="txtCurrentPassword"
                    ErrorMessage="Current password is required."
                    CssClass="text-red-500 text-xs mt-1 block"
                    Display="Dynamic" ValidationGroup="PwdForm" />
            </div>

            <div class="mb-5">
                <label class="block text-sm font-medium text-gray-700 mb-1.5">
                    New Password <span class="text-red-500">*</span>
                </label>
                <asp:TextBox ID="txtNewPassword" runat="server"
                    TextMode="Password"
                    CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                              text-sm focus:outline-none focus:ring-2 
                              focus:ring-forest/30 focus:border-forest transition"
                    placeholder="Minimum 6 characters" />
                <asp:RequiredFieldValidator ID="rfvNew" runat="server"
                    ControlToValidate="txtNewPassword"
                    ErrorMessage="New password is required."
                    CssClass="text-red-500 text-xs mt-1 block"
                    Display="Dynamic" ValidationGroup="PwdForm" />
                <asp:RegularExpressionValidator ID="revNew" runat="server"
                    ControlToValidate="txtNewPassword"
                    ValidationExpression="^.{6,}$"
                    ErrorMessage="Password must be at least 6 characters."
                    CssClass="text-red-500 text-xs mt-1 block"
                    Display="Dynamic" ValidationGroup="PwdForm" />
            </div>

            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 mb-1.5">
                    Confirm New Password <span class="text-red-500">*</span>
                </label>
                <asp:TextBox ID="txtConfirmPassword" runat="server"
                    TextMode="Password"
                    CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                              text-sm focus:outline-none focus:ring-2 
                              focus:ring-forest/30 focus:border-forest transition"
                    placeholder="Repeat new password" />
                <asp:RequiredFieldValidator ID="rfvConfirm" runat="server"
                    ControlToValidate="txtConfirmPassword"
                    ErrorMessage="Please confirm your new password."
                    CssClass="text-red-500 text-xs mt-1 block"
                    Display="Dynamic" ValidationGroup="PwdForm" />
                <asp:CompareValidator ID="cvPassword" runat="server"
                    ControlToValidate="txtConfirmPassword"
                    ControlToCompare="txtNewPassword"
                    ErrorMessage="Passwords do not match."
                    CssClass="text-red-500 text-xs mt-1 block"
                    Display="Dynamic" ValidationGroup="PwdForm" />
            </div>

            <div class="flex gap-3">
                <asp:Button ID="btnChange" runat="server"
                    Text="Change Password"
                    OnClick="btnChange_Click"
                    ValidationGroup="PwdForm"
                    CssClass="flex-1 bg-forest hover:bg-forest-dark text-white 
                              font-bold py-3 rounded-xl transition-colors 
                              cursor-pointer text-sm" />
                <a href="/Members/Profile.aspx"
                   class="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 
                          font-medium py-3 rounded-xl text-center text-sm 
                          transition-colors">
                    Cancel
                </a>
            </div>

        </asp:Panel>
    </div>
</div>

</asp:Content>