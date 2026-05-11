<%@ Page Title="Deliveries" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="Deliveries.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.Deliveries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="mb-6">
        <h1 class="text-2xl font-bold text-gray-800">Deliveries</h1>
        <p class="text-gray-500 text-sm mt-1">
            Track and manage all delivery records
        </p>
    </div>

    <!-- Filter -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-4 mb-5">
        <div class="flex flex-wrap gap-4 items-end">
            <div>
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    Status
                </label>
                <asp:DropDownList ID="ddlStatus" runat="server"
                    CssClass="border border-gray-300 rounded-lg px-3 py-2 text-sm 
                              bg-white focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f]">
                    <asp:ListItem Text="All"       Value="" />
                    <asp:ListItem Text="Pending"   Value="Pending" />
                    <asp:ListItem Text="Preparing" Value="Preparing" />
                    <asp:ListItem Text="Shipped"   Value="Shipped" />
                    <asp:ListItem Text="Delivered" Value="Delivered" />
                    <asp:ListItem Text="Failed"    Value="Failed" />
                </asp:DropDownList>
            </div>
            <div>
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    Option
                </label>
                <asp:DropDownList ID="ddlOption" runat="server"
                    CssClass="border border-gray-300 rounded-lg px-3 py-2 text-sm 
                              bg-white focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f]">
                    <asp:ListItem Text="All"      Value="" />
                    <asp:ListItem Text="Delivery" Value="Delivery" />
                    <asp:ListItem Text="Pickup"   Value="Pickup" />
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

    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <asp:GridView ID="gvDeliveries" runat="server"
            AutoGenerateColumns="false"
            DataKeyNames="DeliveryId"
            CssClass="w-full text-sm"
            GridLines="None"
            EmptyDataText="No deliveries found.">
            <EmptyDataRowStyle CssClass="text-center text-gray-400 py-12 text-sm" />
            <HeaderStyle CssClass="bg-gray-50 text-gray-500 text-xs uppercase tracking-wider" />
            <RowStyle CssClass="border-t border-gray-100 hover:bg-gray-50 transition-colors" />
            <AlternatingRowStyle CssClass="border-t border-gray-100 bg-gray-50/30" />
            <Columns>

                <asp:BoundField DataField="OrderId" HeaderText="Order #"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-20"
                    ItemStyle-CssClass="px-4 py-3 font-bold text-[#2d6a4f]" />

                <asp:TemplateField HeaderText="Customer"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <p class="font-medium text-gray-800"><%# Eval("FullName") %></p>
                        <p class="text-xs text-gray-400"><%# Eval("Phone") %></p>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Address"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <p class="text-sm text-gray-700"><%# Eval("Address") %></p>
                        <p class="text-xs text-gray-400">
                            <%# Eval("City") %> <%# Eval("PostalCode") %>
                        </p>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="DeliveryOption" HeaderText="Option"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-24"
                    ItemStyle-CssClass="px-4 py-3 text-gray-600 text-xs" />

                <asp:TemplateField HeaderText="Preferred Date"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-32"
                    ItemStyle-CssClass="px-4 py-3 text-gray-600 text-xs">
                    <ItemTemplate>
                        <%# Eval("PreferredDate") != DBNull.Value
                            ? ((DateTime)Eval("PreferredDate")).ToString("dd MMM yyyy")
                            : "—" %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-32"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <asp:Literal ID="litStatus" runat="server"
                            Text='<%# ViewHelpers.GetOrderStatusBadge(Eval("Status")) %>'
                            Mode="PassThrough" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions"
                    HeaderStyle-CssClass="px-4 py-3 text-right w-24"
                    ItemStyle-CssClass="px-4 py-3 text-right">
                    <ItemTemplate>
                        <a href='<%# "OrderDetail.aspx?id=" + Eval("OrderId") %>'
                           class="text-blue-600 hover:text-blue-800 text-xs font-medium">
                            View Order →
                        </a>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>

</asp:Content>