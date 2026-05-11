<%@ Page Title="Orders" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="Orders.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="flex items-center justify-between mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Orders</h1>
            <p class="text-gray-500 text-sm mt-1">Manage and process customer orders</p>
        </div>
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="bg-green-50 border border-green-200 text-green-700 rounded-lg 
                  px-4 py-3 mb-5 text-sm flex items-center gap-2">
        <span>✅</span><asp:Literal ID="litSuccess" runat="server" />
    </asp:Panel>

    <!-- Filters -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-4 mb-5">
        <div class="flex flex-wrap gap-4 items-end">

            <div class="flex-1 min-w-40">
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    Search (Order # or customer)
                </label>
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="w-full border border-gray-300 rounded-lg px-3 py-2 
                              text-sm focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f]"
                    placeholder="Order ID or email..." />
            </div>

            <div>
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    Order Status
                </label>
                <asp:DropDownList ID="ddlStatus" runat="server"
                    CssClass="border border-gray-300 rounded-lg px-3 py-2 text-sm 
                              bg-white focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f]">
                    <asp:ListItem Text="All Status"  Value="" />
                    <asp:ListItem Text="Pending"     Value="Pending" />
                    <asp:ListItem Text="Processing"  Value="Processing" />
                    <asp:ListItem Text="Shipped"     Value="Shipped" />
                    <asp:ListItem Text="Delivered"   Value="Delivered" />
                    <asp:ListItem Text="Cancelled"   Value="Cancelled" />
                </asp:DropDownList>
            </div>

            <div>
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    Payment Status
                </label>
                <asp:DropDownList ID="ddlPayStatus" runat="server"
                    CssClass="border border-gray-300 rounded-lg px-3 py-2 text-sm 
                              bg-white focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f]">
                    <asp:ListItem Text="All"    Value="" />
                    <asp:ListItem Text="Paid"   Value="Paid" />
                    <asp:ListItem Text="Unpaid" Value="Unpaid" />
                </asp:DropDownList>
            </div>

            <div class="flex gap-2">
                <asp:Button ID="btnFilter" runat="server" Text="Filter"
                    OnClick="btnFilter_Click"
                    CssClass="bg-[#2d6a4f] hover:bg-[#1b4332] text-white text-sm 
                              font-medium px-4 py-2 rounded-lg cursor-pointer" />
                <asp:Button ID="btnReset" runat="server" Text="Reset"
                    OnClick="btnReset_Click" CausesValidation="false"
                    CssClass="bg-gray-100 hover:bg-gray-200 text-gray-600 text-sm 
                              font-medium px-4 py-2 rounded-lg cursor-pointer" />
            </div>

        </div>
    </div>

    <!-- Orders Table -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <asp:GridView ID="gvOrders" runat="server"
            AutoGenerateColumns="false"
            DataKeyNames="OrderId"
            OnRowCommand="gvOrders_RowCommand"
            CssClass="w-full text-sm"
            GridLines="None"
            EmptyDataText="No orders found.">
            <EmptyDataRowStyle CssClass="text-center text-gray-400 py-12 text-sm" />
            <HeaderStyle CssClass="bg-gray-50 text-gray-500 text-xs uppercase tracking-wider" />
            <RowStyle CssClass="border-t border-gray-100 hover:bg-gray-50 transition-colors" />
            <AlternatingRowStyle CssClass="border-t border-gray-100 bg-gray-50/30 hover:bg-gray-100" />
            <Columns>

                <asp:BoundField DataField="OrderId" HeaderText="Order #"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-24"
                    ItemStyle-CssClass="px-4 py-3 font-bold text-[#2d6a4f]" />

                <asp:TemplateField HeaderText="Customer"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <p class="font-medium text-gray-800"><%# Eval("FullName") %></p>
                        <p class="text-xs text-gray-400"><%# Eval("Email") %></p>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="OrderDate" HeaderText="Date"
                    DataFormatString="{0:dd MMM yyyy}"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-32"
                    ItemStyle-CssClass="px-4 py-3 text-gray-600 text-xs" />

                <asp:BoundField DataField="TotalAmount" HeaderText="Total"
                    DataFormatString="${0:F2}"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-24"
                    ItemStyle-CssClass="px-4 py-3 font-bold text-gray-800" />

                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-32"
                    ItemStyle-CssClass="px-4 py-3 text-gray-600 text-xs" />

                <asp:TemplateField HeaderText="Order Status"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-36"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <asp:Literal ID="litStatus" runat="server"
                            Text='<%# ViewHelpers.GetOrderStatusBadge(Eval("Status")) %>'
                            Mode="PassThrough" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Payment Status"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-32"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <asp:Literal ID="litPayStatus" runat="server"
                            Text='<%# ViewHelpers.GetPaymentStatusBadge(Eval("PaymentStatus")) %>'
                            Mode="PassThrough" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions"
                    HeaderStyle-CssClass="px-4 py-3 text-right w-24"
                    ItemStyle-CssClass="px-4 py-3 text-right">
                    <ItemTemplate>
                        <a href='<%# "OrderDetail.aspx?id=" + Eval("OrderId") %>'
                           class="text-blue-600 hover:text-blue-800 
                                  text-xs font-medium">
                            View →
                        </a>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>

</asp:Content>