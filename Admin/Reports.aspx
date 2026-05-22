<%@ Page Title="Reports" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="Reports.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="mb-6">
        <h1 class="text-2xl font-bold text-gray-800">Reports</h1>
        <p class="text-gray-500 text-sm mt-1">
            Sales, inventory and customer analytics
        </p>
    </div>

    <!-- Date range filter -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-4 mb-6">
        <div class="flex flex-wrap items-end gap-4">
            <div>
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    From Date
                </label>
                <asp:TextBox ID="txtFrom" runat="server" TextMode="Date"
                    CssClass="border border-gray-300 rounded-lg px-3 py-2 text-sm 
                              focus:outline-none focus:ring-2 focus:ring-[#2d6a4f]" />
            </div>
            <div>
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    To Date
                </label>
                <asp:TextBox ID="txtTo" runat="server" TextMode="Date"
                    CssClass="border border-gray-300 rounded-lg px-3 py-2 text-sm 
                              focus:outline-none focus:ring-2 focus:ring-[#2d6a4f]" />
            </div>
            <asp:Button ID="btnGenerate" runat="server"
                Text="Generate Report"
                OnClick="btnGenerate_Click"
                CssClass="bg-[#2d6a4f] hover:bg-[#1b4332] text-white text-sm 
                          font-medium px-4 py-2 rounded-lg cursor-pointer" />
            <asp:Button ID="btnAllTime" runat="server"
                Text="All Time"
                OnClick="btnAllTime_Click" CausesValidation="false"
                CssClass="bg-gray-100 hover:bg-gray-200 text-gray-600 text-sm 
                          font-medium px-4 py-2 rounded-lg cursor-pointer" />
        </div>
    </div>

    <!-- KPI Summary -->
    <div class="grid grid-cols-2 xl:grid-cols-4 gap-5 mb-8">

        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
            <p class="text-xs text-gray-400 uppercase tracking-wider font-medium">
                Total Revenue
            </p>
            <p class="font-display text-3xl font-bold text-[#2d6a4f] mt-2">
                $<asp:Literal ID="litRevenue" runat="server" />
            </p>
            <p class="text-xs text-gray-400 mt-1">
                from <asp:Literal ID="litPaidOrders" runat="server" /> paid orders
            </p>
        </div>

        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
            <p class="text-xs text-gray-400 uppercase tracking-wider font-medium">
                Total Orders
            </p>
            <p class="font-display text-3xl font-bold text-gray-800 mt-2">
                <asp:Literal ID="litTotalOrders" runat="server" />
            </p>
            <p class="text-xs text-gray-400 mt-1">
                avg $<asp:Literal ID="litAvgOrder" runat="server" /> per order
            </p>
        </div>

        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
            <p class="text-xs text-gray-400 uppercase tracking-wider font-medium">
                New Customers
            </p>
            <p class="font-display text-3xl font-bold text-gray-800 mt-2">
                <asp:Literal ID="litNewCustomers" runat="server" />
            </p>
            <p class="text-xs text-gray-400 mt-1">registered in period</p>
        </div>

        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
            <p class="text-xs text-gray-400 uppercase tracking-wider font-medium">
                Pending Orders
            </p>
            <p class="font-display text-3xl font-bold text-amber-500 mt-2">
                <asp:Literal ID="litPending" runat="server" />
            </p>
            <p class="text-xs text-gray-400 mt-1">awaiting processing</p>
        </div>

    </div>

    <div class="grid grid-cols-1 xl:grid-cols-2 gap-6 mb-6">

        <!-- Top Products -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
            <h2 class="font-semibold text-gray-800 mb-4 pb-3 border-b border-gray-100">
                🥦 Top Selling Products
            </h2>
            <asp:GridView ID="gvTopProducts" runat="server"
                AutoGenerateColumns="false"
                CssClass="w-full text-sm"
                GridLines="None"
                EmptyDataText="No sales data yet.">
                <EmptyDataRowStyle CssClass="text-gray-400 text-sm py-4 text-center" />
                <HeaderStyle CssClass="text-gray-400 text-xs uppercase tracking-wider" />
                <RowStyle CssClass="border-t border-gray-50 hover:bg-gray-50" />
                <Columns>
                    <asp:TemplateField HeaderText="Rank"
                        HeaderStyle-CssClass="py-2 text-left w-10"
                        ItemStyle-CssClass="py-3 text-center">
                        <ItemTemplate>
                            <span class="text-gray-400 font-bold text-xs">
                                <%# Container.DataItemIndex + 1 %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Name" HeaderText="Product"
                        HeaderStyle-CssClass="py-2 text-left"
                        ItemStyle-CssClass="py-3 font-medium text-gray-800" />
                    <asp:BoundField DataField="TotalQty" HeaderText="Units Sold"
                        HeaderStyle-CssClass="py-2 text-center w-24"
                        ItemStyle-CssClass="py-3 text-center text-gray-600" />
                    <asp:TemplateField HeaderText="Revenue"
                        HeaderStyle-CssClass="py-2 text-right w-28"
                        ItemStyle-CssClass="py-3 text-right">
                        <ItemTemplate>
                            <span class="font-bold text-[#2d6a4f]">
                                $<%# Eval("TotalRevenue", "{0:F2}") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <!-- Sales by Category -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
            <h2 class="font-semibold text-gray-800 mb-4 pb-3 border-b border-gray-100">
                🏷️ Sales by Category
            </h2>
            <asp:GridView ID="gvByCategory" runat="server"
                AutoGenerateColumns="false"
                CssClass="w-full text-sm"
                GridLines="None"
                EmptyDataText="No sales data yet.">
                <EmptyDataRowStyle CssClass="text-gray-400 text-sm py-4 text-center" />
                <HeaderStyle CssClass="text-gray-400 text-xs uppercase tracking-wider" />
                <RowStyle CssClass="border-t border-gray-50 hover:bg-gray-50" />
                <Columns>
                    <asp:BoundField DataField="CategoryName" HeaderText="Category"
                        HeaderStyle-CssClass="py-2 text-left"
                        ItemStyle-CssClass="py-3 font-medium text-gray-800" />
                    <asp:BoundField DataField="OrderCount" HeaderText="Orders"
                        HeaderStyle-CssClass="py-2 text-center w-20"
                        ItemStyle-CssClass="py-3 text-center text-gray-600" />
                    <asp:TemplateField HeaderText="Revenue"
                        HeaderStyle-CssClass="py-2 text-right w-28"
                        ItemStyle-CssClass="py-3 text-right">
                        <ItemTemplate>
                            <span class="font-bold text-[#2d6a4f]">
                                $<%# Eval("Revenue", "{0:F2}") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

    </div>

    <!-- Orders by Status -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 mb-6">
        <h2 class="font-semibold text-gray-800 mb-4 pb-3 border-b border-gray-100">
            📊 Orders by Status
        </h2>
        <asp:Repeater ID="rptByStatus" runat="server">
            <HeaderTemplate>
                <div class="grid grid-cols-2 md:grid-cols-5 gap-3">
            </HeaderTemplate>
            <ItemTemplate>
                <div class="bg-gray-50 rounded-xl p-4 text-center">
                    <p class="font-display text-3xl font-bold text-gray-800">
                        <%# Eval("Count") %>
                    </p>
                    <p class="text-xs text-gray-500 mt-1 font-medium">
                        <%# Eval("Status") %>
                    </p>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                </div>
            </FooterTemplate>
        </asp:Repeater>
    </div>

    <!-- Low Stock Alert -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
        <h2 class="font-semibold text-gray-800 mb-4 pb-3 border-b border-gray-100 
                   flex items-center gap-2">
            ⚠️ Low Stock Products
            <span class="text-xs text-amber-600 font-normal">
                (stock ≤ 10 units)
            </span>
        </h2>
        <asp:GridView ID="gvLowStock" runat="server"
            AutoGenerateColumns="false"
            CssClass="w-full text-sm"
            GridLines="None"
            EmptyDataText="✅ All products have sufficient stock.">
            <EmptyDataRowStyle CssClass="text-green-600 text-sm py-4 text-center" />
            <HeaderStyle CssClass="text-gray-400 text-xs uppercase tracking-wider" />
            <RowStyle CssClass="border-t border-gray-50 hover:bg-gray-50" />
            <Columns>
                <asp:BoundField DataField="Name" HeaderText="Product"
                    HeaderStyle-CssClass="py-2 text-left"
                    ItemStyle-CssClass="py-3 font-medium text-gray-800" />
                <asp:BoundField DataField="CategoryName" HeaderText="Category"
                    HeaderStyle-CssClass="py-2 text-left w-32"
                    ItemStyle-CssClass="py-3 text-gray-500 text-xs" />
                <asp:TemplateField HeaderText="Stock"
                    HeaderStyle-CssClass="py-2 text-center w-24"
                    ItemStyle-CssClass="py-3 text-center">
                    <ItemTemplate>
                        <span class='<%# (int)Eval("Stock") == 0
                            ? "bg-red-100 text-red-700 text-xs font-bold px-2.5 py-1 rounded-full"
                            : "bg-amber-100 text-amber-700 text-xs font-bold px-2.5 py-1 rounded-full" %>'>
                            <%# Eval("Stock") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action"
                    HeaderStyle-CssClass="py-2 text-right w-24"
                    ItemStyle-CssClass="py-3 text-right">
                    <ItemTemplate>
                        <a href='<%# "/Admin/ProductForm.aspx?id=" + Eval("ProductId") %>'
                           class="text-blue-600 hover:text-blue-800 text-xs font-medium">
                            Update Stock →
                        </a>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

</asp:Content>