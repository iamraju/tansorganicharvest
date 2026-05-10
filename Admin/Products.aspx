<%@ Page Title="Products" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="Products.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="flex items-center justify-between mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Products</h1>
            <p class="text-gray-500 text-sm mt-1">Manage your farm products</p>
        </div>
        <a href="ProductForm.aspx"
           class="bg-[#2d6a4f] hover:bg-[#1b4332] text-white text-sm font-medium 
                  px-4 py-2 rounded-lg transition-colors inline-block">
            + Add Product
        </a>
    </div>

    <!-- Toast messages -->
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

    <!-- Filters Bar -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-4 mb-5">
        <div class="flex flex-wrap items-end gap-4">

            <!-- Search -->
            <div class="flex-1 min-w-48">
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    Search
                </label>
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm
                              focus:outline-none focus:ring-2 focus:ring-[#2d6a4f]"
                    placeholder="Product name..." />
            </div>

            <!-- Category Filter -->
            <div class="min-w-48">
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    Category
                </label>
                <asp:DropDownList ID="ddlCategory" runat="server"
                    CssClass="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm
                              focus:outline-none focus:ring-2 focus:ring-[#2d6a4f] 
                              bg-white" />
            </div>

            <!-- Status Filter -->
            <div>
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    Status
                </label>
                <asp:DropDownList ID="ddlStatus" runat="server"
                    CssClass="border border-gray-300 rounded-lg px-3 py-2 text-sm
                              focus:outline-none focus:ring-2 focus:ring-[#2d6a4f] 
                              bg-white">
                    <asp:ListItem Text="All Status" Value="" />
                    <asp:ListItem Text="Active" Value="1" />
                    <asp:ListItem Text="Inactive" Value="0" />
                </asp:DropDownList>
            </div>

            <!-- Featured Filter -->
            <div>
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    Featured
                </label>
                <asp:DropDownList ID="ddlFeatured" runat="server"
                    CssClass="border border-gray-300 rounded-lg px-3 py-2 text-sm
                              focus:outline-none focus:ring-2 focus:ring-[#2d6a4f] 
                              bg-white">
                    <asp:ListItem Text="All" Value="" />
                    <asp:ListItem Text="Featured Only" Value="1" />
                    <asp:ListItem Text="Not Featured" Value="0" />
                </asp:DropDownList>
            </div>

            <!-- Buttons -->
            <div class="flex gap-2">
                <asp:Button ID="btnFilter" runat="server" Text="Filter"
                    OnClick="btnFilter_Click"
                    CssClass="bg-[#2d6a4f] hover:bg-[#1b4332] text-white text-sm 
                              font-medium px-4 py-2 rounded-lg cursor-pointer 
                              transition-colors" />
                <asp:Button ID="btnReset" runat="server" Text="Reset"
                    OnClick="btnReset_Click" CausesValidation="false"
                    CssClass="bg-gray-100 hover:bg-gray-200 text-gray-600 text-sm 
                              font-medium px-4 py-2 rounded-lg cursor-pointer 
                              transition-colors" />
            </div>

        </div>
    </div>

    <!-- Results count + page size -->
    <div class="flex items-center justify-between mb-3">
        <p class="text-sm text-gray-500">
            Showing
            <span class="font-medium text-gray-700">
                <asp:Literal ID="litFrom" runat="server" />–<asp:Literal ID="litTo" runat="server" />
            </span>
            of
            <span class="font-medium text-gray-700">
                <asp:Literal ID="litTotal" runat="server" />
            </span>
            products
        </p>
        <div class="flex items-center gap-2 text-sm text-gray-500">
            <label>Per page:</label>
            <asp:DropDownList ID="ddlPageSize" runat="server"
                AutoPostBack="true"
                OnSelectedIndexChanged="ddlPageSize_Changed"
                CssClass="border border-gray-300 rounded-md px-2 py-1 text-sm bg-white">
                <asp:ListItem Text="10" Value="10" />
                <asp:ListItem Text="25" Value="25" Selected="True" />
                <asp:ListItem Text="50" Value="50" />
            </asp:DropDownList>
        </div>
    </div>

    <!-- Products Table -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden mb-4">
        <asp:GridView ID="gvProducts" runat="server"
            AutoGenerateColumns="false"
            DataKeyNames="ProductId"
            OnRowCommand="gvProducts_RowCommand"
            CssClass="w-full text-sm"
            GridLines="None"
            EmptyDataText="No products found matching your filters.">
            <EmptyDataRowStyle CssClass="text-center text-gray-400 py-12 text-sm" />
            <HeaderStyle CssClass="bg-gray-50 text-gray-500 text-xs uppercase tracking-wider" />
            <RowStyle CssClass="border-t border-gray-100 hover:bg-gray-50 transition-colors" />
            <AlternatingRowStyle CssClass="border-t border-gray-100 bg-gray-50/30 
                                           hover:bg-gray-100 transition-colors" />
            <Columns>

                <asp:TemplateField HeaderText="Image"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-16"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <div class="w-12 h-12 rounded-lg overflow-hidden bg-gray-100">
                            <asp:Image ID="imgProduct" runat="server"
                                ImageUrl='<%# GetImageUrl(Eval("ImageUrl")) %>'
                                AlternateText='<%# Eval("Name") %>'
                                CssClass="w-full h-full object-cover" />
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Product"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <p class="font-medium text-gray-800"><%# Eval("Name") %></p>
                        <p class="text-xs text-gray-400 mt-0.5"><%# Eval("CategoryName") %></p>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Price"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-28"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <p class="font-medium text-gray-800">
                            $<%# Eval("Price", "{0:F2}") %>
                        </p>
                        <p class="text-xs text-gray-400"><%# Eval("Unit") %></p>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Stock"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-24"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <span class='<%# GetStockCss((int)Eval("Stock")) %>'>
                            <%# Eval("Stock") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Featured"
                    HeaderStyle-CssClass="px-4 py-3 text-center w-24"
                    ItemStyle-CssClass="px-4 py-3 text-center">
                    <ItemTemplate>
                        <%# (bool)Eval("IsFeatured") ? "⭐" : "—" %>
                    </ItemTemplate>
                </asp:TemplateField>

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

                <asp:TemplateField HeaderText="Actions"
                    HeaderStyle-CssClass="px-4 py-3 text-right w-28"
                    ItemStyle-CssClass="px-4 py-3 text-right">
                    <ItemTemplate>
                        <a href='<%# "ProductForm.aspx?id=" + Eval("ProductId") %>'
                           class="text-blue-600 hover:text-blue-800 text-xs font-medium mr-3">
                            Edit
                        </a>
                        <asp:LinkButton ID="btnDelete" runat="server"
                            CommandName="DeleteRow"
                            CommandArgument='<%# Eval("ProductId") %>'
                            CssClass="text-red-500 hover:text-red-700 text-xs font-medium"
                            OnClientClick="return confirm('Delete this product?');">
                            Delete
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>

    <!-- Pagination -->
    <div class="flex items-center justify-between">

        <p class="text-sm text-gray-400">
            Page <asp:Literal ID="litCurrentPage" runat="server" /> 
            of <asp:Literal ID="litTotalPages" runat="server" />
        </p>

        <div class="flex items-center gap-1">
            <asp:LinkButton ID="btnFirst" runat="server"
                CommandName="First" OnClick="btnPager_Click"
                CssClass="px-3 py-1.5 text-xs border border-gray-300 rounded-md 
                          hover:bg-gray-50 text-gray-600 disabled:opacity-40">
                «
            </asp:LinkButton>
            <asp:LinkButton ID="btnPrev" runat="server"
                OnClick="btnPager_Click" CommandName="Prev"
                CssClass="px-3 py-1.5 text-xs border border-gray-300 rounded-md 
                          hover:bg-gray-50 text-gray-600">
                ‹ Prev
            </asp:LinkButton>

            <!-- Page number buttons generated in code-behind -->
            <asp:PlaceHolder ID="phPageNumbers" runat="server" />

            <asp:LinkButton ID="btnNext" runat="server"
                OnClick="btnPager_Click" CommandName="Next"
                CssClass="px-3 py-1.5 text-xs border border-gray-300 rounded-md 
                          hover:bg-gray-50 text-gray-600">
                Next ›
            </asp:LinkButton>
            <asp:LinkButton ID="btnLast" runat="server"
                OnClick="btnPager_Click" CommandName="Last"
                CssClass="px-3 py-1.5 text-xs border border-gray-300 rounded-md 
                          hover:bg-gray-50 text-gray-600">
                »
            </asp:LinkButton>
        </div>

    </div>

</asp:Content>