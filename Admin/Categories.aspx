<%@ Page Title="Categories" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="Categories.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.Categories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="flex items-center justify-between mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Categories</h1>
            <p class="text-gray-500 text-sm mt-1">Manage product categories</p>
        </div>
        <a href="CategoryForm.aspx"
           class="bg-[#2d6a4f] hover:bg-[#1b4332] text-white text-sm font-medium 
                  px-4 py-2 rounded-lg transition-colors inline-block">
            + Add Category
        </a>
    </div>

    <!-- Success message (shown after redirect) -->
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="bg-green-50 border border-green-200 text-green-700 rounded-lg 
                  px-4 py-3 mb-5 text-sm flex items-center gap-2">
        <span>✅</span>
        <asp:Literal ID="litSuccess" runat="server" />
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="bg-red-50 border border-red-200 text-red-700 rounded-lg 
                  px-4 py-3 mb-5 text-sm flex items-center gap-2">
        <span>⚠️</span>
        <asp:Literal ID="litError" runat="server" />
    </asp:Panel>

    <!-- Table -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <asp:GridView ID="gvCategories" runat="server"
            AutoGenerateColumns="false"
            DataKeyNames="CategoryId"
            OnRowCommand="gvCategories_RowCommand"
            CssClass="w-full text-sm"
            EmptyDataText="No categories found. Click '+ Add Category' to create one."
            GridLines="None">
            <EmptyDataRowStyle CssClass="text-center text-gray-400 py-12 text-sm" />
            <HeaderStyle CssClass="bg-gray-50 text-gray-500 text-xs uppercase tracking-wider" />
            <RowStyle CssClass="border-t border-gray-100 hover:bg-gray-50 transition-colors" />
            <AlternatingRowStyle CssClass="border-t border-gray-100 bg-gray-50/50 hover:bg-gray-100 transition-colors" />
            <Columns>

                <asp:TemplateField HeaderText="Image"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-20"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <div class="w-12 h-12 rounded-lg overflow-hidden bg-gray-100 
                                    flex items-center justify-center">
                            <asp:Image ID="imgCategory" runat="server"
                                ImageUrl='<%# GetImageUrl(Eval("ImageUrl")) %>'
                                AlternateText='<%# Eval("Name") %>'
                                CssClass="w-full h-full object-cover" />
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Name" HeaderText="Name"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3 font-medium text-gray-800" />

                <asp:BoundField DataField="Description" HeaderText="Description"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3 text-gray-500 max-w-xs" />

                <asp:BoundField DataField="SortOrder" HeaderText="Order"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-20"
                    ItemStyle-CssClass="px-4 py-3 text-gray-500 text-center" />

                <asp:TemplateField HeaderText="Status"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-24"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <span class='<%# (bool)Eval("IsActive")
                            ? "bg-green-100 text-green-700 text-xs px-2.5 py-1 rounded-full font-medium"
                            : "bg-gray-100 text-gray-500 text-xs px-2.5 py-1 rounded-full font-medium" %>'>
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
                        <!-- Edit → GET to CategoryForm.aspx?id=X -->
                        <a href='<%# "CategoryForm.aspx?id=" + Eval("CategoryId") %>'
                           class="text-blue-600 hover:text-blue-800 text-xs font-medium mr-3">
                            Edit
                        </a>
                        <asp:LinkButton ID="btnDelete" runat="server"
                            CommandName="DeleteRow"
                            CommandArgument='<%# Eval("CategoryId") %>'
                            CssClass="text-red-500 hover:text-red-700 text-xs font-medium"
                            OnClientClick="return confirm('Are you sure you want to delete this category?');">
                            Delete
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>

</asp:Content>