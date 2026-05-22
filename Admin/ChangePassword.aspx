<%@ Page Title="Change Password" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="mb-6">
        <h1 class="text-2xl font-bold text-gray-800">Change Password</h1>
        <p class="text-gray-500 text-sm mt-1">Update your admin password</p>
    </div>

    <div class="max-w-lg">
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
                CssClass="bg-green-50 border border-green-200 text-green-700 
                          rounded-lg px-4 py-3 mb-5 text-sm flex items-center gap-2">
                <span>✅</span> Password changed successfully.
            </asp:Panel>
            <asp:Panel ID="pnlError" runat="server" Visible="false"
                CssClass="bg-red-50 border border-red-200 text-red-700 
                          rounded-lg px-4 py-3 mb-5 text-sm flex items-center gap-2">
                <span>⚠️</span><asp:Literal ID="litError" runat="server" />
            </asp:Panel>

            <div class="mb-5">
                <label class="block text-sm font-medium text-gray-700 mb-1.5">
                    Current Password <span class="text-red-500">*</span>
                </label>
                <asp:TextBox ID="txtCurrent" runat="server"
                    TextMode="Password"
                    CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                              text-sm focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f] transition"
                    placeholder="Current password" />
                <asp:RequiredFieldValidator ID="rfvCurrent" runat="server"
                    ControlToValidate="txtCurrent"
                    ErrorMessage="Current password is required."
                    CssClass="text-red-500 text-xs mt-1 block"
                    Display="Dynamic" ValidationGroup="PwdForm" />
            </div>

            <div class="mb-5">
                <label class="block text-sm font-medium text-gray-700 mb-1.5">
                    New Password <span class="text-red-500">*</span>
                </label>
                <asp:TextBox ID="txtNew" runat="server"
                    TextMode="Password"
                    CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                              text-sm focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f] transition"
                    placeholder="Minimum 6 characters" />
                <asp:RequiredFieldValidator ID="rfvNew" runat="server"
                    ControlToValidate="txtNew"
                    ErrorMessage="New password is required."
                    CssClass="text-red-500 text-xs mt-1 block"
                    Display="Dynamic" ValidationGroup="PwdForm" />
                <asp:RegularExpressionValidator ID="revNew" runat="server"
                    ControlToValidate="txtNew"
                    ValidationExpression="^.{6,}$"
                    ErrorMessage="Minimum 6 characters."
                    CssClass="text-red-500 text-xs mt-1 block"
                    Display="Dynamic" ValidationGroup="PwdForm" />
            </div>

            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 mb-1.5">
                    Confirm New Password <span class="text-red-500">*</span>
                </label>
                <asp:TextBox ID="txtConfirm" runat="server"
                    TextMode="Password"
                    CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                              text-sm focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f] transition"
                    placeholder="Repeat new password" />
                <asp:RequiredFieldValidator ID="rfvConfirm" runat="server"
                    ControlToValidate="txtConfirm"
                    ErrorMessage="Please confirm your password."
                    CssClass="text-red-500 text-xs mt-1 block"
                    Display="Dynamic" ValidationGroup="PwdForm" />
                <asp:CompareValidator ID="cvPwd" runat="server"
                    ControlToValidate="txtConfirm"
                    ControlToCompare="txtNew"
                    ErrorMessage="Passwords do not match."
                    CssClass="text-red-500 text-xs mt-1 block"
                    Display="Dynamic" ValidationGroup="PwdForm" />
            </div>

            <div class="flex gap-3">
                <asp:Button ID="btnChange" runat="server"
                    Text="Change Password"
                    OnClick="btnChange_Click"
                    ValidationGroup="PwdForm"
                    CssClass="bg-[#2d6a4f] hover:bg-[#1b4332] text-white font-semibold 
                              px-6 py-2.5 rounded-lg cursor-pointer text-sm" />
                <a href="/Admin/Profile.aspx"
                   class="bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium 
                          px-6 py-2.5 rounded-lg text-sm transition-colors">
                    Cancel
                </a>
            </div>

        </div>
    </div>

</asp:Content>