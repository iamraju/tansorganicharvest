<%@ Page Title="Admin Profile" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="Profile.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="mb-6">
        <h1 class="text-2xl font-bold text-gray-800">My Profile</h1>
        <p class="text-gray-500 text-sm mt-1">Manage your admin account</p>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- Avatar card -->
        <div>
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 
                        text-center">
                <div class="w-20 h-20 bg-[#2d6a4f] rounded-full flex items-center 
                            justify-center text-3xl font-bold text-white mx-auto mb-4">
                    <asp:Literal ID="litInitial" runat="server" />
                </div>
                <h2 class="font-semibold text-gray-800 text-lg">
                    <asp:Literal ID="litFullName" runat="server" />
                </h2>
                <p class="text-gray-400 text-sm mt-1">
                    <asp:Literal ID="litUsername" runat="server" />
                </p>
                <span class="inline-block mt-2 bg-green-100 text-green-700 
                             text-xs font-semibold px-3 py-1 rounded-full">
                    Administrator
                </span>
                <div class="mt-4 pt-4 border-t border-gray-100 text-xs text-gray-400">
                    Last login: <asp:Literal ID="litLastLogin" runat="server" />
                </div>
            </div>
        </div>

        <!-- Edit form -->
        <div class="lg:col-span-2">

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
                CssClass="bg-green-50 border border-green-200 text-green-700 
                          rounded-lg px-4 py-3 mb-5 text-sm flex items-center gap-2">
                <span>✅</span><asp:Literal ID="litSuccess" runat="server" />
            </asp:Panel>
            <asp:Panel ID="pnlError" runat="server" Visible="false"
                CssClass="bg-red-50 border border-red-200 text-red-700 
                          rounded-lg px-4 py-3 mb-5 text-sm flex items-center gap-2">
                <span>⚠️</span><asp:Literal ID="litError" runat="server" />
            </asp:Panel>

            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 mb-5">
                <h2 class="font-semibold text-gray-800 mb-5 pb-3 
                           border-b border-gray-100">
                    Profile Information
                </h2>

                <asp:HiddenField ID="hfAdminId" runat="server" />

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Full Name <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtFullName" runat="server"
                            CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-[#2d6a4f] transition"
                            placeholder="Your full name" />
                        <asp:RequiredFieldValidator ID="rfvName" runat="server"
                            ControlToValidate="txtFullName"
                            ErrorMessage="Full name is required."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="AdminProfile" />
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Email
                        </label>
                        <asp:TextBox ID="txtEmail" runat="server"
                            CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-[#2d6a4f] transition"
                            placeholder="admin@example.com" />
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Username
                        </label>
                        <asp:TextBox ID="txtUsernameDisplay" runat="server"
                            ReadOnly="true"
                            CssClass="w-full border border-gray-200 rounded-lg px-3 py-2.5 
                                      text-sm bg-gray-50 text-gray-500 cursor-not-allowed" />
                    </div>
                </div>

                <div class="mt-5 pt-4 border-t border-gray-100">
                    <asp:Button ID="btnSave" runat="server"
                        Text="Save Changes"
                        OnClick="btnSave_Click"
                        ValidationGroup="AdminProfile"
                        CssClass="bg-[#2d6a4f] hover:bg-[#1b4332] text-white 
                                  font-semibold px-6 py-2.5 rounded-lg 
                                  cursor-pointer text-sm transition-colors" />
                </div>
            </div>

            <!-- Change password link -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <h3 class="font-semibold text-gray-800">Password</h3>
                        <p class="text-gray-400 text-sm mt-0.5">
                            Change your admin password
                        </p>
                    </div>
                    <a href="/Admin/ChangePassword.aspx"
                       class="bg-gray-100 hover:bg-gray-200 text-gray-700 
                              font-medium px-4 py-2 rounded-lg text-sm 
                              transition-colors">
                        🔑 Change Password
                    </a>
                </div>
            </div>

        </div>
    </div>

</asp:Content>