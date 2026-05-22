<%@ Page Title="Customers" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="Customers.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.Customers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="flex items-center justify-between mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Customers</h1>
            <p class="text-gray-500 text-sm mt-1">
                View and manage registered members
            </p>
        </div>
        <span class="bg-forest/10 text-forest text-sm font-semibold 
                     px-4 py-2 rounded-lg">
            <asp:Literal ID="litTotal" runat="server" /> members
        </span>
    </div>

    <!-- Search -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-4 mb-5">
        <div class="flex gap-4 items-end">
            <div class="flex-1">
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    Search
                </label>
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="w-full border border-gray-300 rounded-lg px-3 py-2 
                              text-sm focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f]"
                    placeholder="Name or email..." />
            </div>
            <asp:Button ID="btnSearch" runat="server" Text="Search"
                OnClick="btnSearch_Click"
                CssClass="bg-[#2d6a4f] hover:bg-[#1b4332] text-white text-sm 
                          font-medium px-4 py-2 rounded-lg cursor-pointer" />
            <asp:Button ID="btnReset" runat="server" Text="Reset"
                OnClick="btnReset_Click" CausesValidation="false"
                CssClass="bg-gray-100 hover:bg-gray-200 text-gray-600 text-sm 
                          font-medium px-4 py-2 rounded-lg cursor-pointer" />
        </div>
    </div>

    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <asp:GridView ID="gvCustomers" runat="server"
            AutoGenerateColumns="false"
            CssClass="w-full text-sm"
            GridLines="None"
            EmptyDataText="No customers found.">
            <EmptyDataRowStyle CssClass="text-center text-gray-400 py-12 text-sm" />
            <HeaderStyle CssClass="bg-gray-50 text-gray-500 text-xs 
                                   uppercase tracking-wider" />
            <RowStyle CssClass="border-t border-gray-100 hover:bg-gray-50 transition-colors" />
            <AlternatingRowStyle CssClass="border-t border-gray-100 
                                           bg-gray-50/30 hover:bg-gray-100" />
            <Columns>

                <asp:TemplateField HeaderText="Customer"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-[#2d6a4f] rounded-full 
                                        flex items-center justify-center 
                                        text-white font-bold text-sm flex-shrink-0">
                                <%# GetInitial(Eval("FullName"), Eval("Email")) %>
                            </div>
                            <div>
                                <p class="font-medium text-gray-800">
                                    <%# Eval("FullName") %>
                                </p>
                                <p class="text-xs text-gray-400">
                                    <%# Eval("Email") %>
                                </p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Phone" HeaderText="Phone"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-36"
                    ItemStyle-CssClass="px-4 py-3 text-gray-600 text-sm" />

                <asp:TemplateField HeaderText="Location"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-40"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <p class="text-sm text-gray-700"><%# Eval("City") %></p>
                        <p class="text-xs text-gray-400"><%# Eval("PostalCode") %></p>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Orders"
                    HeaderStyle-CssClass="px-4 py-3 text-center w-20"
                    ItemStyle-CssClass="px-4 py-3 text-center">
                    <ItemTemplate>
                        <span class="bg-forest/10 text-forest font-bold text-sm 
                                     px-2.5 py-1 rounded-lg">
                            <%# Eval("OrderCount") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Total Spent"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-28"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <p class="font-bold text-gray-800">
                            $<%# Eval("TotalSpent", "{0:F2}") %>
                        </p>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="JoinedAt" HeaderText="Joined"
                    DataFormatString="{0:dd MMM yyyy}"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-28"
                    ItemStyle-CssClass="px-4 py-3 text-gray-400 text-xs" />

            </Columns>
        </asp:GridView>
    </div>

</asp:Content>