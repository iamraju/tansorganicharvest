<%@ Page Title="Dashboard" Language="C#" 
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="mb-6">
        <h1 class="text-2xl font-bold text-gray-800">Dashboard</h1>
        <p class="text-gray-500 text-sm mt-1">
            Welcome back, <strong><asp:Literal ID="litName" runat="server"/></strong>. 
            Here's what's happening today.
        </p>
    </div>

    <!-- KPI Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-5 mb-8">

        <div class="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs text-gray-500 uppercase tracking-wide font-medium">
                        Total Products
                    </p>
                    <p class="text-3xl font-bold text-gray-800 mt-1">
                        <asp:Literal ID="litProducts" runat="server" />
                    </p>
                </div>
                <div class="text-3xl">🥦</div>
            </div>
        </div>

        <div class="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs text-gray-500 uppercase tracking-wide font-medium">
                        Total Orders
                    </p>
                    <p class="text-3xl font-bold text-gray-800 mt-1">
                        <asp:Literal ID="litOrders" runat="server" />
                    </p>
                </div>
                <div class="text-3xl">🛒</div>
            </div>
        </div>

        <div class="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs text-gray-500 uppercase tracking-wide font-medium">
                        Total Customers
                    </p>
                    <p class="text-3xl font-bold text-gray-800 mt-1">
                        <asp:Literal ID="litCustomers" runat="server" />
                    </p>
                </div>
                <div class="text-3xl">👥</div>
            </div>
        </div>

        <div class="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs text-gray-500 uppercase tracking-wide font-medium">
                        Unread Feedback
                    </p>
                    <p class="text-3xl font-bold text-gray-800 mt-1">
                        <asp:Literal ID="litFeedback" runat="server" />
                    </p>
                </div>
                <div class="text-3xl">💬</div>
            </div>
        </div>

    </div>

    <!-- Recent Orders -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
        <h2 class="text-base font-semibold text-gray-800 mb-4">Recent Orders</h2>
        <asp:GridView ID="gvRecentOrders" runat="server"
            AutoGenerateColumns="false"
            CssClass="w-full text-sm"
            EmptyDataText="No orders yet."
            GridLines="None">
            <HeaderStyle CssClass="bg-gray-50 text-gray-500 text-xs uppercase 
                                   tracking-wider" />
            <RowStyle CssClass="border-t border-gray-100 hover:bg-gray-50" />
            <Columns>
                <asp:BoundField DataField="OrderId"     HeaderText="Order #"  
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3 font-medium" />
                <asp:BoundField DataField="OrderDate"   HeaderText="Date"     
                    DataFormatString="{0:dd MMM yyyy}"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3 text-gray-600" />
                <asp:BoundField DataField="TotalAmount" HeaderText="Amount"   
                    DataFormatString="${0:F2}"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3" />
                <asp:BoundField DataField="Status"      HeaderText="Status"   
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3" />
                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3 text-gray-600" />
            </Columns>
        </asp:GridView>
    </div>

</asp:Content>