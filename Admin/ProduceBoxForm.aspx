<%@ Page Title="Produce Box Form" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="ProduceBoxForm.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.ProduceBoxForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="flex items-center gap-3 mb-6">
        <a href="ProduceBoxes.aspx"
           class="text-gray-400 hover:text-gray-600 transition-colors">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15 19l-7-7 7-7"/>
            </svg>
        </a>
        <div>
            <h1 class="text-2xl font-bold text-gray-800">
                <asp:Literal ID="litPageTitle" runat="server" Text="Add Produce Box" />
            </h1>
            <p class="text-gray-500 text-sm mt-0.5">
                <asp:Literal ID="litPageSubtitle" runat="server"
                    Text="Fill in the details to create a new produce box." />
            </p>
        </div>
    </div>

    <asp:HiddenField ID="hfBoxId"         runat="server" Value="0" />
    <asp:HiddenField ID="hfExistingImage" runat="server" Value="" />

    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="bg-red-50 border border-red-200 text-red-700 rounded-lg 
                  px-4 py-3 mb-5 text-sm flex items-center gap-2">
        <span>⚠️</span><asp:Literal ID="litError" runat="server" />
    </asp:Panel>

    <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">

        <!-- Left: main fields -->
        <div class="xl:col-span-2 space-y-5">

            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-sm font-semibold text-gray-700 mb-5 pb-3 
                           border-b border-gray-100">
                    Box Information
                </h2>

                <!-- Name -->
                <div class="mb-5">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Box Name <span class="text-red-500">*</span>
                    </label>
                    <asp:TextBox ID="txtName" runat="server"
                        CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-[#2d6a4f] transition"
                        placeholder="e.g. Family Veggie Box" />
                    <asp:RequiredFieldValidator ID="rfvName" runat="server"
                        ControlToValidate="txtName"
                        ErrorMessage="Box name is required."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="BoxForm" />
                </div>

                <!-- Description -->
                <div class="mb-5">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Description
                        <span class="text-gray-400 font-normal ml-1">
                            (shown to customers)
                        </span>
                    </label>
                    <asp:TextBox ID="txtDescription" runat="server"
                        TextMode="MultiLine" Rows="5"
                        CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                  text-sm focus:outline-none focus:ring-2 
                                  focus:ring-[#2d6a4f] transition resize-none"
                        placeholder="Describe what's inside this box, who it's for, 
                                     how many it feeds..." />
                </div>

                <!-- Price -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Price ($) <span class="text-red-500">*</span>
                    </label>
                    <div class="relative w-48">
                        <span class="absolute left-3 top-2.5 text-gray-400 text-sm">
                            $
                        </span>
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
                        Display="Dynamic" ValidationGroup="BoxForm" />
                    <asp:RegularExpressionValidator ID="revPrice" runat="server"
                        ControlToValidate="txtPrice"
                        ValidationExpression="^\d+(\.\d{1,2})?$"
                        ErrorMessage="Enter a valid price (e.g. 28.00)."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="BoxForm" />
                </div>
            </div>

            <!-- Box Contents (what's inside) -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-sm font-semibold text-gray-700 mb-3 pb-3 
                           border-b border-gray-100">
                    Box Contents
                    <span class="text-gray-400 font-normal ml-1 text-xs">
                        — list items included in this box
                    </span>
                </h2>
                <p class="text-xs text-gray-400 mb-3">
                    One item per line. e.g. "2x Zucchini" or "500g Baby Spinach"
                </p>
                <asp:TextBox ID="txtContents" runat="server"
                    TextMode="MultiLine" Rows="7"
                    CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                              text-sm focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f] transition resize-none font-mono"
                    placeholder="2x Zucchini&#10;500g Baby Spinach&#10;4x Carrots&#10;1kg Tomatoes&#10;1 bunch Kale" />
            </div>

        </div>

        <!-- Right: image + status -->
        <div class="space-y-5">

            <!-- Image -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-sm font-semibold text-gray-700 mb-4 pb-3 
                           border-b border-gray-100">
                    Box Image
                </h2>

                <asp:Panel ID="pnlCurrentImage" runat="server" Visible="false"
                    CssClass="mb-4">
                    <p class="text-xs text-gray-500 mb-2">Current image:</p>
                    <div class="w-full h-44 rounded-xl overflow-hidden 
                                bg-gray-100 border border-gray-200">
                        <asp:Image ID="imgPreview" runat="server"
                            CssClass="w-full h-full object-cover" />
                    </div>
                    <p class="text-xs text-gray-400 mt-2">
                        Upload below to replace.
                    </p>
                </asp:Panel>

                <div class="border-2 border-dashed border-gray-300 rounded-xl p-5 
                            text-center hover:border-[#2d6a4f] transition-colors">
                    <div class="text-3xl mb-2">📦</div>
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
                         class="w-full h-44 object-cover rounded-xl 
                                border border-gray-200" />
                </div>
            </div>

            <!-- Status -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-sm font-semibold text-gray-700 mb-4 pb-3 
                           border-b border-gray-100">
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

            <!-- Actions -->
            <div class="flex flex-col gap-3">
                <asp:Button ID="btnSave" runat="server"
                    Text="Save Produce Box"
                    OnClick="btnSave_Click"
                    ValidationGroup="BoxForm"
                    CssClass="w-full bg-[#2d6a4f] hover:bg-[#1b4332] text-white 
                              font-semibold py-2.5 rounded-lg transition-colors 
                              cursor-pointer text-sm" />
                <a href="ProduceBoxes.aspx"
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