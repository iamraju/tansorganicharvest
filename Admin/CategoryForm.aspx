<%@ Page Title="Category Form" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="CategoryForm.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.CategoryForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <!-- Page Header -->
    <div class="flex items-center gap-3 mb-6">
        <a href="Categories.aspx"
           class="text-gray-400 hover:text-gray-600 transition-colors">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15 19l-7-7 7-7"/>
            </svg>
        </a>
        <div>
            <h1 class="text-2xl font-bold text-gray-800">
                <asp:Literal ID="litPageTitle" runat="server" Text="Add Category" />
            </h1>
            <p class="text-gray-500 text-sm mt-0.5">
                <asp:Literal ID="litPageSubtitle" runat="server" 
                    Text="Fill in the details below to create a new category." />
            </p>
        </div>
    </div>

    <asp:HiddenField ID="hfCategoryId" runat="server" Value="0" />
    <asp:HiddenField ID="hfExistingImage" runat="server" Value="" />

    <!-- Error panel -->
    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="bg-red-50 border border-red-200 text-red-700 rounded-lg 
                  px-4 py-3 mb-5 text-sm flex items-center gap-2">
        <span>⚠️</span>
        <asp:Literal ID="litError" runat="server" />
    </asp:Panel>

    <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">

        <!-- Left: Main fields -->
        <div class="xl:col-span-2 space-y-5">

            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-sm font-semibold text-gray-700 mb-5 
                           pb-3 border-b border-gray-100">
                    Basic Information
                </h2>

                <!-- Name -->
                <div class="mb-5">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Category Name <span class="text-red-500">*</span>
                    </label>
                    <asp:TextBox ID="txtName" runat="server"
                        CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-[#2d6a4f] focus:border-transparent transition"
                        placeholder="e.g. Fresh Fruits" />
                    <asp:RequiredFieldValidator ID="rfvName" runat="server"
                        ControlToValidate="txtName"
                        ErrorMessage="Category name is required."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic"
                        ValidationGroup="CategoryForm" />
                </div>

                <!-- Description -->
                <div class="mb-5">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Description
                    </label>
                    <asp:TextBox ID="txtDescription" runat="server"
                        TextMode="MultiLine" Rows="4"
                        CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-[#2d6a4f] focus:border-transparent 
                                  transition resize-none"
                        placeholder="Brief description of this category..." />
                </div>

                <!-- Sort Order -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Sort Order
                        <span class="text-gray-400 font-normal ml-1">(lower = appears first)</span>
                    </label>
                    <asp:TextBox ID="txtSortOrder" runat="server" Text="0"
                        CssClass="w-32 border border-gray-300 rounded-lg px-3 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-[#2d6a4f] focus:border-transparent transition" />
                    <asp:RangeValidator ID="rvSortOrder" runat="server"
                        ControlToValidate="txtSortOrder"
                        MinimumValue="0" MaximumValue="9999" Type="Integer"
                        ErrorMessage="Sort order must be a number between 0 and 9999."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic"
                        ValidationGroup="CategoryForm" />
                </div>
            </div>

        </div>

        <!-- Right: Image + Status -->
        <div class="space-y-5">

            <!-- Image Upload -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-sm font-semibold text-gray-700 mb-5 
                           pb-3 border-b border-gray-100">
                    Category Image
                </h2>

                <!-- Current image preview (shown when editing) -->
                <asp:Panel ID="pnlCurrentImage" runat="server" Visible="false"
                    CssClass="mb-4">
                    <p class="text-xs text-gray-500 mb-2">Current image:</p>
                    <div class="w-full h-40 rounded-lg overflow-hidden bg-gray-100 
                                border border-gray-200">
                        <asp:Image ID="imgPreview" runat="server"
                            CssClass="w-full h-full object-cover" />
                    </div>
                    <p class="text-xs text-gray-400 mt-2">
                        Upload a new image below to replace it.
                    </p>
                </asp:Panel>

                <!-- Upload control -->
                <div class="border-2 border-dashed border-gray-300 rounded-lg p-6 
                            text-center hover:border-[#2d6a4f] transition-colors"
                     id="dropzone">
                    <div class="text-3xl mb-2">📷</div>
                    <p class="text-sm text-gray-600 mb-1">Upload category image</p>
                    <p class="text-xs text-gray-400 mb-3">JPG, PNG, WEBP up to 10MB</p>
                    <asp:FileUpload ID="fuImage" runat="server"
                        CssClass="text-sm text-gray-500 
                                  file:mr-3 file:py-1.5 file:px-3
                                  file:rounded-md file:border-0
                                  file:text-xs file:font-medium
                                  file:bg-[#2d6a4f] file:text-white
                                  hover:file:bg-[#1b4332] file:cursor-pointer" 
                        accept="image/jpeg,image/png,image/webp" />
                </div>

                <!-- Image preview before upload (JS) -->
                <div id="newImagePreview" class="mt-3 hidden">
                    <p class="text-xs text-gray-500 mb-1">New image preview:</p>
                    <img id="previewImg" src="#" alt="Preview"
                         class="w-full h-40 object-cover rounded-lg border border-gray-200" />
                </div>

            </div>

            <!-- Status -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-sm font-semibold text-gray-700 mb-4 
                           pb-3 border-b border-gray-100">
                    Visibility
                </h2>
                <label class="flex items-center gap-3 cursor-pointer">
                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                    <div>
                        <p class="text-sm font-medium text-gray-700">Active</p>
                        <p class="text-xs text-gray-400">
                            Visible on the public website
                        </p>
                    </div>
                </label>
            </div>

            <!-- Action Buttons -->
            <div class="flex flex-col gap-3">
                <asp:Button ID="btnSave" runat="server"
                    Text="Save Category"
                    OnClick="btnSave_Click"
                    ValidationGroup="CategoryForm"
                    CssClass="w-full bg-[#2d6a4f] hover:bg-[#1b4332] text-white 
                              font-semibold py-2.5 rounded-lg transition-colors 
                              cursor-pointer text-sm" />
                <a href="Categories.aspx"
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
    // Preview image before upload
    document.addEventListener('DOMContentLoaded', function () {
        var fu = document.getElementById('<%= fuImage.ClientID %>');
        if (fu) {
            fu.addEventListener('change', function (e) {
                var file = e.target.files[0];
                if (!file) return;

                // Validate size (2MB)
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
        }
    });
</script>
</asp:Content>