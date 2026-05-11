<%@ Page Title="FAQ" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="FAQ.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.FAQ" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="flex items-center justify-between mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">FAQ Management</h1>
            <p class="text-gray-500 text-sm mt-1">
                Manage frequently asked questions
            </p>
        </div>
        <asp:Button ID="btnShowAdd" runat="server"
            Text="+ Add Question"
            OnClick="btnShowAdd_Click"
            CssClass="bg-[#2d6a4f] hover:bg-[#1b4332] text-white text-sm 
                      font-medium px-4 py-2 rounded-lg cursor-pointer" />
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="bg-green-50 border border-green-200 text-green-700 rounded-lg 
                  px-4 py-3 mb-5 text-sm flex items-center gap-2">
        <span>✅</span><asp:Literal ID="litSuccess" runat="server" />
    </asp:Panel>

    <!-- Add/Edit Form -->
    <asp:Panel ID="pnlForm" runat="server" Visible="false"
        CssClass="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-6">

        <h2 class="font-semibold text-gray-800 mb-5 pb-3 border-b border-gray-100">
            <asp:Literal ID="litFormTitle" runat="server" Text="Add FAQ" />
        </h2>

        <asp:HiddenField ID="hfFAQId" runat="server" Value="0" />

        <div class="mb-5">
            <label class="block text-sm font-medium text-gray-700 mb-1.5">
                Question <span class="text-red-500">*</span>
            </label>
            <asp:TextBox ID="txtQuestion" runat="server"
                CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                          text-sm focus:outline-none focus:ring-2 
                          focus:ring-[#2d6a4f] transition"
                placeholder="Enter the question..." />
            <asp:RequiredFieldValidator ID="rfvQuestion" runat="server"
                ControlToValidate="txtQuestion"
                ErrorMessage="Question is required."
                CssClass="text-red-500 text-xs mt-1 block"
                Display="Dynamic" ValidationGroup="FAQForm" />
        </div>

        <div class="mb-5">
            <label class="block text-sm font-medium text-gray-700 mb-1.5">
                Answer <span class="text-red-500">*</span>
            </label>
            <asp:TextBox ID="txtAnswer" runat="server"
                TextMode="MultiLine" Rows="4"
                CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                          text-sm focus:outline-none focus:ring-2 
                          focus:ring-[#2d6a4f] transition resize-none"
                placeholder="Enter the answer..." />
            <asp:RequiredFieldValidator ID="rfvAnswer" runat="server"
                ControlToValidate="txtAnswer"
                ErrorMessage="Answer is required."
                CssClass="text-red-500 text-xs mt-1 block"
                Display="Dynamic" ValidationGroup="FAQForm" />
        </div>

        <div class="grid grid-cols-2 gap-5 mb-5">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1.5">
                    Sort Order
                </label>
                <asp:TextBox ID="txtSortOrder" runat="server" Text="0"
                    CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                              text-sm focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f] transition" />
            </div>
            <div class="flex items-end pb-1">
                <label class="flex items-center gap-2 cursor-pointer">
                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                    <span class="text-sm font-medium text-gray-700">Active</span>
                </label>
            </div>
        </div>

        <div class="flex gap-3 pt-4 border-t border-gray-100">
            <asp:Button ID="btnSave" runat="server"
                Text="Save"
                OnClick="btnSave_Click"
                ValidationGroup="FAQForm"
                CssClass="bg-[#2d6a4f] hover:bg-[#1b4332] text-white font-semibold 
                          px-6 py-2.5 rounded-lg cursor-pointer text-sm" />
            <asp:Button ID="btnCancel" runat="server"
                Text="Cancel"
                OnClick="btnCancel_Click"
                CausesValidation="false"
                CssClass="bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium 
                          px-6 py-2.5 rounded-lg cursor-pointer text-sm" />
        </div>
    </asp:Panel>

    <!-- FAQ List -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <asp:GridView ID="gvFAQ" runat="server"
            AutoGenerateColumns="false"
            DataKeyNames="FAQId"
            OnRowCommand="gvFAQ_RowCommand"
            CssClass="w-full text-sm"
            GridLines="None"
            EmptyDataText="No FAQs yet. Click '+ Add Question' to create one.">
            <EmptyDataRowStyle CssClass="text-center text-gray-400 py-12 text-sm" />
            <HeaderStyle CssClass="bg-gray-50 text-gray-500 text-xs 
                                   uppercase tracking-wider" />
            <RowStyle CssClass="border-t border-gray-100 hover:bg-gray-50" />
            <AlternatingRowStyle CssClass="border-t border-gray-100 bg-gray-50/30" />
            <Columns>

                <asp:BoundField DataField="SortOrder" HeaderText="#"
                    HeaderStyle-CssClass="px-4 py-3 text-left w-16"
                    ItemStyle-CssClass="px-4 py-3 text-gray-500 text-center" />

                <asp:TemplateField HeaderText="Question & Answer"
                    HeaderStyle-CssClass="px-4 py-3 text-left"
                    ItemStyle-CssClass="px-4 py-3">
                    <ItemTemplate>
                        <p class="font-medium text-gray-800">
                            <%# Eval("Question") %>
                        </p>
                        <p class="text-xs text-gray-400 mt-1 line-clamp-2">
                            <%# Eval("Answer") %>
                        </p>
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

                <asp:TemplateField HeaderText="Actions"
                    HeaderStyle-CssClass="px-4 py-3 text-right w-28"
                    ItemStyle-CssClass="px-4 py-3 text-right">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server"
                            CommandName="EditRow"
                            CommandArgument='<%# Eval("FAQId") %>'
                            CssClass="text-blue-600 hover:text-blue-800 
                                      text-xs font-medium mr-3">
                            Edit
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server"
                            CommandName="DeleteRow"
                            CommandArgument='<%# Eval("FAQId") %>'
                            CssClass="text-red-500 hover:text-red-700 text-xs font-medium"
                            OnClientClick="return confirm('Delete this FAQ?');">
                            Delete
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>

</asp:Content>