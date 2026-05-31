<%@ Page Title="Subscriptions" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="Subscriptions.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.Subscriptions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="mb-6">
        <h1 class="text-2xl font-bold text-gray-800">Subscriptions</h1>
        <p class="text-gray-500 text-sm mt-1">
            All member produce box subscriptions
        </p>
    </div>

    <!-- Summary cards -->
    <div class="grid grid-cols-3 gap-5 mb-6">
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
            <p class="text-xs text-gray-400 uppercase tracking-wider">Active</p>
            <p class="font-display text-3xl font-bold text-green-600 mt-1">
                <asp:Literal ID="litActive" runat="server" />
            </p>
        </div>
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
            <p class="text-xs text-gray-400 uppercase tracking-wider">Paused</p>
            <p class="font-display text-3xl font-bold text-amber-500 mt-1">
                <asp:Literal ID="litPaused" runat="server" />
            </p>
        </div>
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
            <p class="text-xs text-gray-400 uppercase tracking-wider">Total Points Awarded</p>
            <p class="font-display text-3xl font-bold text-[#2d6a4f] mt-1">
                <asp:Literal ID="litTotalPoints" runat="server" />
            </p>
        </div>
    </div>

    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <asp:GridView ID="gvSubscriptions" runat="server"
            AutoGenerateColumns="false"
            CssClass="w-full text-sm"
            GridLines="None"
            EmptyDataText="No subscriptions yet.">
            <EmptyDataRowStyle CssClass="text-center text-gray-400 py-12 text-sm" />
            <HeaderStyle CssClass="bg-gray-50 text-gray-500 text-xs uppercase tracking-wider" />
            <RowStyle CssClass="border-t border-gray-100 hover:bg-gray-50 transition-colors" />
            <AlternatingRowStyle CssClass="border-t border-gray-100 bg-gray-50/30" />
            <Columns>

                <asp:TemplateField HeaderText="Member"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <p class="font-medium text-gray-800"><%# Eval("FullName") %></p>
                        <p class="text-xs text-gray-400"><%# Eval("Email") %></p>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="BoxName" HeaderText="Box"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3 font-medium text-gray-800" />

                <asp:BoundField DataField="Frequency" HeaderText="Frequency"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-28"
                    ItemStyle-CssClass="px-4 py-3 text-gray-600 text-sm" />

                <asp:BoundField DataField="NextDelivery" HeaderText="Next Delivery"
                    DataFormatString="{0:dd MMM yyyy}"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-32"
                    ItemStyle-CssClass="px-4 py-3 text-gray-600 text-sm" />

                <asp:TemplateField HeaderText="Status"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-24"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <asp:Literal ID="litStatus" runat="server"
                            Text='<%# GetStatusBadge(Eval("Status").ToString()) %>'
                            Mode="PassThrough" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="StartDate" HeaderText="Started"
                    DataFormatString="{0:dd MMM yyyy}"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-28"
                    ItemStyle-CssClass="px-4 py-3 text-gray-400 text-xs" />

            </Columns>
        </asp:GridView>
    </div>

</asp:Content>