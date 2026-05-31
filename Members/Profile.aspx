<%@ Page Title="My Profile" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Profile.aspx.cs"
    Inherits="TansOrganicHarvest.Members.Profile" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<div class="bg-forest py-12 px-6 text-white text-center">
    <h1 class="font-display text-4xl font-bold">My Profile</h1>
    <p class="text-white/60 mt-2 text-sm">Manage your account details</p>
</div>

<div class="max-w-4xl mx-auto px-6 py-12">

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="bg-green-50 border border-green-200 text-green-700 rounded-xl 
                  px-4 py-3 mb-6 text-sm flex items-center gap-2">
        <span>✅</span><asp:Literal ID="litSuccess" runat="server" />
    </asp:Panel>
    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="bg-red-50 border border-red-200 text-red-700 rounded-xl 
                  px-4 py-3 mb-6 text-sm flex items-center gap-2">
        <span>⚠️</span><asp:Literal ID="litError" runat="server" />
    </asp:Panel>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- Left: Avatar + quick links -->
        <div class="space-y-4">

            <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-6 
                        text-center">
                <div class="w-20 h-20 bg-forest rounded-full flex items-center 
                            justify-center text-3xl font-bold text-white mx-auto mb-4">
                    <asp:Literal ID="litInitial" runat="server" />
                </div>
                <h2 class="font-display text-xl font-bold text-gray-800">
                    <asp:Literal ID="litDisplayName" runat="server" />
                </h2>
                <p class="text-gray-400 text-sm mt-1">
                    <asp:Literal ID="litEmail" runat="server" />
                </p>
                <p class="text-xs text-gray-400 mt-1">
                    Member since <asp:Literal ID="litMemberSince" runat="server" />
                </p>
            </div>

            <!-- Quick links -->
            <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-4">
                <nav class="space-y-1">
                    <a href="/Members/Profile.aspx"
                       class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                              bg-forest/5 text-forest font-medium text-sm">
                        👤 My Profile
                    </a>
                    <a href="/Members/OrderHistory.aspx"
                       class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                              text-gray-600 hover:bg-gray-50 text-sm transition-colors">
                        📋 My Orders
                    </a>
                    <a href="/Members/Subscriptions.aspx"
                       class="flex items-center gap-3 px-3 py-2.5 rounded-xl
                              text-gray-600 hover:bg-gray-50 text-sm transition-colors">
                        📦 My Subscriptions
                    </a>
                    <a href="/Members/Cart.aspx"
                       class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                              text-gray-600 hover:bg-gray-50 text-sm transition-colors">
                        🛒 My Cart
                    </a>
                    <a href="/Members/ChangePassword.aspx"
                       class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                              text-gray-600 hover:bg-gray-50 text-sm transition-colors">
                        🔑 Change Password
                    </a>
                </nav>
            </div>

        </div>

        <!-- Right: Edit form -->
        <div class="lg:col-span-2">
            <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-6">

                <h2 class="font-semibold text-gray-800 mb-5 pb-3 
                           border-b border-gray-100">
                    Personal Information
                </h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">

                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Full Name <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtFullName" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="Your full name" />
                        <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                            ControlToValidate="txtFullName"
                            ErrorMessage="Full name is required."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="ProfileForm" />
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Phone Number
                        </label>
                        <asp:TextBox ID="txtPhone" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="+60 12-345 6789" />
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            City
                        </label>
                        <asp:TextBox ID="txtCity" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="Your city" />
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Delivery Address
                        </label>
                        <asp:TextBox ID="txtAddress" runat="server"
                            TextMode="MultiLine" Rows="3"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest 
                                      transition resize-none"
                            placeholder="Your delivery address..." />
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Postal Code
                        </label>
                        <asp:TextBox ID="txtPostalCode" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="12345" />
                    </div>

                </div>

                <div class="pt-4 border-t border-gray-100">
                    <asp:Button ID="btnSave" runat="server"
                        Text="Save Changes"
                        OnClick="btnSave_Click"
                        ValidationGroup="ProfileForm"
                        CssClass="bg-forest hover:bg-forest-dark text-white font-bold 
                                  py-3 px-8 rounded-xl transition-colors cursor-pointer 
                                  text-sm" />
                </div>

            </div>

            <!-- Order summary stats -->
            <div class="grid grid-cols-3 gap-4 mt-5">
                <div class="bg-white rounded-2xl border border-sage/20 shadow-sm 
                            p-5 text-center">
                    <p class="font-display text-3xl font-bold text-forest">
                        <asp:Literal ID="litTotalOrders" runat="server" />
                    </p>
                    <p class="text-xs text-gray-400 mt-1">Total Orders</p>
                </div>
                <div class="bg-white rounded-2xl border border-sage/20 shadow-sm 
                            p-5 text-center">
                    <p class="font-display text-3xl font-bold text-forest">
                        $<asp:Literal ID="litTotalSpent" runat="server" />
                    </p>
                    <p class="text-xs text-gray-400 mt-1">Total Spent</p>
                </div>
                <div class="bg-white rounded-2xl border border-sage/20 shadow-sm 
                            p-5 text-center">
                    <p class="font-display text-3xl font-bold text-forest">
                        <asp:Literal ID="litCartItems" runat="server" />
                    </p>
                    <p class="text-xs text-gray-400 mt-1">In Cart</p>
                </div>

                <!-- Add as 4th stat card -->
                <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-5 text-center">
                    <p class="font-display text-3xl font-bold text-forest">
                        <asp:Literal ID="litPoints" runat="server" Text="0" />
                    </p>
                    <p class="text-xs text-gray-400 mt-1">Loyalty Points</p>
                    <p class="text-xs text-green-600 mt-1">= $<asp:Literal ID="litPointsValue" runat="server" Text="0.00" /></p>
                </div>
            </div>
        </div>

    </div>
</div>

</asp:Content>