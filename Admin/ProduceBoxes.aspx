<%@ Page Title="Produce Boxes" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="ProduceBoxes.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.ProduceBoxes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="flex items-center justify-between mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Produce Boxes</h1>
            <p class="text-gray-500 text-sm mt-1">
                Manage weekly subscription boxes
            </p>
        </div>
        <a href="ProduceBoxForm.aspx"
           class="bg-[#2d6a4f] hover:bg-[#1b4332] text-white text-sm font-medium 
                  px-4 py-2 rounded-lg transition-colors inline-block">
            + Add Box
        </a>
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="bg-green-50 border border-green-200 text-green-700 rounded-lg 
                  px-4 py-3 mb-5 text-sm flex items-center gap-2">
        <span>✅</span><asp:Literal ID="litSuccess" runat="server" />
    </asp:Panel>
    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="bg-red-50 border border-red-200 text-red-700 rounded-lg 
                  px-4 py-3 mb-5 text-sm flex items-center gap-2">
        <span>⚠️</span><asp:Literal ID="litError" runat="server" />
    </asp:Panel>

    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <asp:GridView ID="gvBoxes" runat="server"
            AutoGenerateColumns="false"
            DataKeyNames="BoxId"
            OnRowCommand="gvBoxes_RowCommand"
            CssClass="w-full text-sm"
            GridLines="None"
            EmptyDataText="No produce boxes found.">
            <EmptyDataRowStyle CssClass="text-center text-gray-400 py-12 text-sm" />
            <HeaderStyle CssClass="bg-gray-50 text-gray-500 text-xs 
                                   uppercase tracking-wider" />
            <RowStyle CssClass="border-t border-gray-100 
                                hover:bg-gray-50 transition-colors" />
            <AlternatingRowStyle CssClass="border-t border-gray-100 
                                           bg-gray-50/50 hover:bg-gray-100" />
            <Columns>

                <asp:TemplateField HeaderText="Image"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-20"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <div class="w-14 h-14 rounded-xl overflow-hidden bg-gray-100 
                                    flex items-center justify-center">
                            <asp:Image ID="imgBox" runat="server"
                                ImageUrl='<%# ViewHelpers.GetImageUrl(Eval("ImageUrl")) %>'
                                AlternateText='<%# Eval("Name") %>'
                                CssClass="w-full h-full object-cover" />
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Box Details"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <p class="font-medium text-gray-800"><%# Eval("Name") %></p>
                        <p class="text-xs text-gray-400 mt-0.5 max-w-sm">
                            <%# Eval("Description") %>
                        </p>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Price"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-28"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <p class="font-bold text-[#2d6a4f] text-lg">
                            $<%# Eval("Price", "{0:F2}") %>
                        </p>
                        <p class="text-xs text-gray-400">per box</p>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-24"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <span class='<%# ViewHelpers.ActiveStatus(Eval("IsActive")) %>'>
                            <%# (bool)Eval("IsActive") ? "Active" : "Inactive" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="CreatedAt" HeaderText="Created"
                    DataFormatString="{0:dd MMM yyyy}"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-32"
                    ItemStyle-CssClass="px-4 py-3 text-gray-400 text-xs" />

                <asp:TemplateField HeaderText="Actions"
                    HeaderStyle-CssClass="px-4 py-3 text-right w-28"
                    ItemStyle-CssClass="px-4 py-3 text-right">
                    <ItemTemplate>
                        <a href='<%# "ProduceBoxForm.aspx?id=" + Eval("BoxId") %>'
                           class="text-blue-600 hover:text-blue-800 
                                  text-xs font-medium mr-3">
                            Edit
                        </a>
                        <asp:LinkButton ID="btnDelete" runat="server"
                            CommandName="DeleteRow"
                            CommandArgument='<%# Eval("BoxId") %>'
                            CssClass="text-red-500 hover:text-red-700 text-xs font-medium"
                            OnClientClick="return confirm('Delete this produce box?');">
                            Delete
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>

</asp:Content>