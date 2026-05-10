<%@ Page Title="Product Form" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="ProductForm.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.ProductForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <!-- Header -->
    <div class="flex items-center gap-3 mb-6">
        <a href="Products.aspx"
           class="text-gray-400 hover:text-gray-600 transition-colors">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15 19l-7-7 7-7"/>
            </svg>
        </a>
        <div>
            <h1 class="text-2xl font-bold text-gray-800">
                <asp:Literal ID="litPageTitle" runat="server" Text="Add Product" />
            </h1>
            <p class="text-gray-500 text-sm mt-0.5">
                <asp:Literal ID="litPageSubtitle" runat="server"
                    Text="Fill in the details to add a new product." />
            </p>
        </div>
    </div>

    <asp:HiddenField ID="hfProductId"     runat="server" Value="0" />
    <asp:HiddenField ID="hfExistingImage" runat="server" Value="" />

    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="bg-red-50 border border-red-200 text-red-700 rounded-lg 
                  px-4 py-3 mb-5 text-sm flex items-center gap-2">
        <span>⚠️</span><asp:Literal ID="litError" runat="server" />
    </asp:Panel>

    <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">

        <!-- ── Left col: main fields ── -->
        <div class="xl:col-span-2 space-y-5">

            <!-- Basic Info -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-sm font-semibold text-gray-700 mb-5 pb-3 
                           border-b border-gray-100">
                    Basic Information
                </h2>

                <!-- Name -->
                <div class="mb-5">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Product Name <span class="text-red-500">*</span>
                    </label>
                    <asp:TextBox ID="txtName" runat="server"
                        CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-[#2d6a4f] transition"
                        placeholder="e.g. Organic Strawberries" />
                    <asp:RequiredFieldValidator ID="rfvName" runat="server"
                        ControlToValidate="txtName"
                        ErrorMessage="Product name is required."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="ProductForm" />
                </div>

                <!-- Category -->
                <div class="mb-5">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Category <span class="text-red-500">*</span>
                    </label>
                    <asp:DropDownList ID="ddlCategory" runat="server"
                        CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-[#2d6a4f] bg-white" />
                    <asp:RequiredFieldValidator ID="rfvCategory" runat="server"
                        ControlToValidate="ddlCategory"
                        InitialValue=""
                        ErrorMessage="Please select a category."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="ProductForm" />
                </div>

                <!-- Description -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Description
                    </label>
                    <asp:TextBox ID="txtDescription" runat="server"
                        TextMode="MultiLine" Rows="5"
                        CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-[#2d6a4f] transition resize-none"
                        placeholder="Describe the product — freshness, taste, origin..." />
                </div>
            </div>

            <!-- Pricing + Inventory -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-sm font-semibold text-gray-700 mb-5 pb-3 
                           border-b border-gray-100">
                    Pricing &amp; Inventory
                </h2>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-5">

                    <!-- Price -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Price ($) <span class="text-red-500">*</span>
                        </label>
                        <div class="relative">
                            <span class="absolute left-3 top-2.5 text-gray-400 text-sm">$</span>
                            <asp:TextBox ID="txtPrice" runat="server"
                                CssClass="w-full border border-gray-300 rounded-lg 
                                          pl-7 pr-3 py-2.5 text-sm focus:outline-none 
                                          focus:ring-2 focus:ring-[#2d6a4f] transition"
                                placeholder="0.00" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvPrice" runat="server"
                            ControlToValidate="txtPrice"
                            ErrorMessage="Price is required."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="ProductForm" />
                        <asp:RegularExpressionValidator ID="revPrice" runat="server"
                            ControlToValidate="txtPrice"
                            ValidationExpression="^\d+(\.\d{1,2})?$"
                            ErrorMessage="Enter a valid price (e.g. 4.99)."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="ProductForm" />
                    </div>

                    <!-- Unit -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Unit <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtUnit" runat="server"
                            CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-[#2d6a4f] transition"
                            placeholder="e.g. per kg, per 500g" />
                        <asp:RequiredFieldValidator ID="rfvUnit" runat="server"
                            ControlToValidate="txtUnit"
                            ErrorMessage="Unit is required."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="ProductForm" />
                    </div>

                    <!-- Stock -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Stock Quantity <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtStock" runat="server" Text="0"
                            CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-[#2d6a4f] transition"
                            placeholder="0" />
                        <asp:RangeValidator ID="rvStock" runat="server"
                            ControlToValidate="txtStock"
                            MinimumValue="0" MaximumValue="99999" Type="Integer"
                            ErrorMessage="Stock must be 0 or more."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="ProductForm" />
                    </div>

                </div>
            </div>

        </div>

        <!-- ── Right col: image + settings ── -->
        <div class="space-y-5">

            <!-- Image -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-sm font-semibold text-gray-700 mb-4 pb-3 
                           border-b border-gray-100">
                    Product Image
                </h2>

                <asp:Panel ID="pnlCurrentImage" runat="server" Visible="false"
                    CssClass="mb-4">
                    <p class="text-xs text-gray-500 mb-2">Current image:</p>
                    <div class="w-full h-44 rounded-lg overflow-hidden 
                                bg-gray-100 border border-gray-200">
                        <asp:Image ID="imgPreview" runat="server"
                            CssClass="w-full h-full object-cover" />
                    </div>
                    <p class="text-xs text-gray-400 mt-2">
                        Upload below to replace.
                    </p>
                </asp:Panel>

                <div class="border-2 border-dashed border-gray-300 rounded-lg p-5 
                            text-center hover:border-[#2d6a4f] transition-colors">
                    <div class="text-3xl mb-2">🥬</div>
                    <p class="text-xs text-gray-400 mb-3">JPG, PNG, WEBP up to 10MB</p>
                    <asp:FileUpload ID="fuImage" runat="server"
                        CssClass="text-sm text-gray-500 
                                  file:mr-2 file:py-1.5 file:px-3 file:rounded-md 
                                  file:border-0 file:text-xs file:font-medium
                                  file:bg-[#2d6a4f] file:text-white
                                  hover:file:bg-[#1b4332] file:cursor-pointer"
                        accept="image/jpeg,image/png,image/webp" />
                </div>

                <div id="newImagePreview" class="mt-3 hidden">
                    <p class="text-xs text-gray-500 mb-1">Preview:</p>
                    <img id="previewImg" src="#" alt="Preview"
                         class="w-full h-44 object-cover rounded-lg 
                                border border-gray-200" />
                </div>
            </div>

            <!-- Settings -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-sm font-semibold text-gray-700 mb-4 pb-3 
                           border-b border-gray-100">
                    Settings
                </h2>

                <div class="space-y-4">
                    <label class="flex items-center gap-3 cursor-pointer">
                        <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                        <div>
                            <p class="text-sm font-medium text-gray-700">Active</p>
                            <p class="text-xs text-gray-400">Visible in the shop</p>
                        </div>
                    </label>
                    <label class="flex items-center gap-3 cursor-pointer">
                        <asp:CheckBox ID="chkIsFeatured" runat="server" />
                        <div>
                            <p class="text-sm font-medium text-gray-700">Featured</p>
                            <p class="text-xs text-gray-400">
                                Shown on the home page
                            </p>
                        </div>
                    </label>
                </div>
            </div>

            <!-- Save / Cancel -->
            <div class="flex flex-col gap-3">
                <asp:Button ID="btnSave" runat="server"
                    Text="Save Product"
                    OnClick="btnSave_Click"
                    ValidationGroup="ProductForm"
                    CssClass="w-full bg-[#2d6a4f] hover:bg-[#1b4332] text-white 
                              font-semibold py-2.5 rounded-lg transition-colors 
                              cursor-pointer text-sm" />
                <a href="Products.aspx"
                   class="w-full bg-gray-100 hover:bg-gray-200 text-gray-700 
                          font-medium py-2.5 rounded-lg transition-colors 
                          text-sm text-center block">
                    Cancel
                </a>
            </div>

        </div>
    </div>

</asp:Content>

<asp:Content ID="Scripts" ContentPlaceHolderID="HeadContent" runat="server">
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var fu = document.getElementById('<%= fuImage.ClientID %>');
        if (!fu) return;
        fu.addEventListener('change', function (e) {
            var file = e.target.files[0];
            if (!file) return;
            if (file.size > 10 * 1024 * 1024) {
                alert('Image must be less than 10MB.');
                fu.value = '';
                return;
            }
            var reader = new FileReader();
            reader.onload = function (ev) {
                document.getElementById('previewImg').src = ev.target.result;
                document.getElementById('newImagePreview').classList.remove('hidden');
            };
            reader.readAsDataURL(file);
        });
    });
</script>
</asp:Content>