<%@ Control Language="C#" AutoEventWireup="true" 
    CodeBehind="MemberSidebar.aspx.cs" 
    Inherits="TansOrganicHarvest.Members.Controls.MemberSidebar" %>

<div class="space-y-4">
    <!-- User Info Card -->
    <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-6 text-center">
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

    <!-- Navigation Menu -->
    <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-4">
        <nav class="space-y-1">
            <a href="/Members/Profile.aspx"
               class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                      <%# GetActiveClass("Profile.aspx") %> 
                      text-sm transition-colors">
                👤 My Profile
            </a>
            <a href="/Members/OrderHistory.aspx"
               class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                      <%# GetActiveClass("OrderHistory.aspx") %> 
                      text-sm transition-colors">
                📋 My Orders
            </a>
            <a href="/Members/Cart.aspx"
               class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                      <%# GetActiveClass("Cart.aspx") %> 
                      text-sm transition-colors">
                🛒 My Cart
            </a>
            <a href="/Members/Wishlist.aspx"
               class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                      <%# GetActiveClass("Wishlist.aspx") %> 
                      text-sm transition-colors">
                ❤️ Wishlist
            </a>
            <a href="/Members/ChangePassword.aspx"
               class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                      <%# GetActiveClass("ChangePassword.aspx") %> 
                      text-sm transition-colors">
                🔑 Change Password
            </a>
            <hr class="my-2 border-gray-100" />
            <a href="/Account/Logout.aspx"
               class="flex items-center gap-3 px-3 py-2.5 rounded-xl 
                      text-red-600 hover:bg-red-50 text-sm transition-colors">
                🚪 Sign Out
            </a>
        </nav>
    </div>
</div>