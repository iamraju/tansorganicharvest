<%@ Page Title="Feedback" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="Feedback.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.Feedback" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="flex items-center justify-between mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Customer Feedback</h1>
            <p class="text-gray-500 text-sm mt-1">
                Review and respond to customer messages
            </p>
        </div>
        <div class="flex items-center gap-3">
            <span class="bg-red-100 text-red-700 text-xs font-semibold 
                         px-3 py-1.5 rounded-full">
                <asp:Literal ID="litUnreadCount" runat="server" /> unread
            </span>
        </div>
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="bg-green-50 border border-green-200 text-green-700 rounded-lg 
                  px-4 py-3 mb-5 text-sm flex items-center gap-2">
        <span>✅</span><asp:Literal ID="litSuccess" runat="server" />
    </asp:Panel>

    <!-- Reply Modal (hidden by default) -->
    <div id="replyModal"
         class="hidden fixed inset-0 bg-black/50 z-50 flex items-center 
                justify-center p-4">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg p-6">
            <h3 class="font-semibold text-gray-800 mb-1">Reply to Feedback</h3>
            <p class="text-xs text-gray-400 mb-4" id="replyTo"></p>
            <asp:HiddenField ID="hfFeedbackId" runat="server" Value="0" />
            <asp:TextBox ID="txtReply" runat="server"
                TextMode="MultiLine" Rows="5"
                CssClass="w-full border border-gray-300 rounded-xl px-4 py-3 
                          text-sm focus:outline-none focus:ring-2 
                          focus:ring-[#2d6a4f] resize-none mb-4"
                placeholder="Type your reply..." />
            <div class="flex gap-3">
                <asp:Button ID="btnSendReply" runat="server"
                    Text="Send Reply"
                    OnClick="btnSendReply_Click"
                    CssClass="flex-1 bg-[#2d6a4f] hover:bg-[#1b4332] text-white 
                              font-semibold py-2.5 rounded-xl cursor-pointer text-sm" />
                <button type="button" onclick="closeReplyModal()"
                        class="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 
                               font-medium py-2.5 rounded-xl text-sm">
                    Cancel
                </button>
            </div>
        </div>
    </div>

    <!-- Filters -->
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
                    <asp:ListItem Text="All"    Value="" />
                    <asp:ListItem Text="Unread" Value="0" />
                    <asp:ListItem Text="Read"   Value="1" />
                </asp:DropDownList>
            </div>
            <div>
                <label class="block text-xs font-medium text-gray-500 mb-1.5">
                    Category
                </label>
                <asp:DropDownList ID="ddlCategory" runat="server"
                    CssClass="border border-gray-300 rounded-lg px-3 py-2 text-sm 
                              bg-white focus:outline-none focus:ring-2 
                              focus:ring-[#2d6a4f]">
                    <asp:ListItem Text="All Categories"  Value="" />
                    <asp:ListItem Text="General"         Value="General" />
                    <asp:ListItem Text="Product Quality" Value="Product Quality" />
                    <asp:ListItem Text="Delivery"        Value="Delivery" />
                    <asp:ListItem Text="Order"           Value="Order" />
                    <asp:ListItem Text="Suggestion"      Value="Suggestion" />
                    <asp:ListItem Text="Other"           Value="Other" />
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

    <!-- Feedback list -->
    <asp:Repeater ID="rptFeedback" runat="server"
        OnItemCommand="rptFeedback_ItemCommand">
        <ItemTemplate>
            <div class="bg-white rounded-xl border border-gray-100 shadow-sm 
                        mb-3 overflow-hidden
                        <%# !(bool)Eval("IsRead") ? "border-l-4 border-l-forest" : "" %>">

                <div class="p-5">
                    <!-- Header row -->
                    <div class="flex items-start justify-between gap-4 mb-3">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 bg-sage/20 rounded-full 
                                        flex items-center justify-center 
                                        font-bold text-forest flex-shrink-0">
                                <%# Eval("Name").ToString().Substring(0,1).ToUpper() %>
                            </div>
                            <div>
                                <p class="font-semibold text-gray-800 text-sm">
                                    <%# Eval("Name") %>
                                </p>
                                <p class="text-xs text-gray-400">
                                    <%# Eval("Email") %>
                                </p>
                            </div>
                        </div>
                        <div class="flex items-center gap-2 flex-shrink-0">
                            <span class="bg-gray-100 text-gray-600 text-xs 
                                         px-2.5 py-1 rounded-full">
                                <%# Eval("Category") %>
                            </span>
                            <%# !(bool)Eval("IsRead")
                                ? "<span class='bg-forest text-white text-xs px-2.5 py-1 rounded-full font-semibold'>New</span>"
                                : "<span class='bg-gray-100 text-gray-400 text-xs px-2.5 py-1 rounded-full'>Read</span>" %>
                            <span class="text-xs text-gray-400">
                                <%# Eval("CreatedAt", "{0:dd MMM yyyy}") %>
                            </span>
                        </div>
                    </div>

                    <!-- Subject + Message -->
                    <p class="font-semibold text-gray-800 text-sm mb-1">
                        <%# Eval("Subject") %>
                    </p>
                    <p class="text-gray-600 text-sm leading-relaxed">
                        <%# Eval("Message") %>
                    </p>

                    <!-- Admin Reply (if exists) -->
                    <asp:Panel ID="pnlReply" runat="server"
                        Visible='<%# !string.IsNullOrEmpty(Eval("AdminReply") as string) %>'
                        CssClass="mt-4 bg-forest/5 border border-forest/20 
                                  rounded-xl p-4">
                        <p class="text-xs font-semibold text-forest mb-1">
                            ✉️ Admin Reply:
                        </p>
                        <p class="text-sm text-gray-700">
                            <%# Eval("AdminReply") %>
                        </p>
                    </asp:Panel>

                    <!-- Actions -->
                    <div class="flex gap-3 mt-4 pt-3 border-t border-gray-100">
                        <asp:LinkButton ID="btnReply" runat="server"
                            CommandName="OpenReply"
                            CommandArgument='<%# Eval("FeedbackId") + "|" + Eval("Name") + "|" + Eval("Email") %>'
                            CssClass="text-forest hover:text-forest-dark text-xs 
                                      font-semibold transition-colors">
                            ✉️ Reply
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnMarkRead" runat="server"
                            CommandName="MarkRead"
                            CommandArgument='<%# Eval("FeedbackId") %>'
                            Visible='<%# !(bool)Eval("IsRead") %>'
                            CssClass="text-gray-500 hover:text-gray-700 text-xs 
                                      transition-colors">
                            ✓ Mark as Read
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server"
                            CommandName="DeleteFeedback"
                            CommandArgument='<%# Eval("FeedbackId") %>'
                            OnClientClick="return confirm('Delete this feedback?');"
                            CssClass="text-red-400 hover:text-red-600 text-xs 
                                      transition-colors ml-auto">
                            Delete
                        </asp:LinkButton>
                    </div>

                </div>
            </div>
        </ItemTemplate>
        <%--<EmptyDataTemplate>
            <div class="text-center py-16 bg-white rounded-xl border border-gray-100">
                <div class="text-5xl mb-3">💬</div>
                <p class="text-gray-400 text-sm">No feedback found.</p>
            </div>
        </EmptyDataTemplate>--%>
    </asp:Repeater>

</asp:Content>

<asp:Content ID="Scripts" ContentPlaceHolderID="HeadContent" runat="server">
<script>
    function openReplyModal(feedbackId, name, email) {
        document.getElementById('<%= hfFeedbackId.ClientID %>').value = feedbackId;
        document.getElementById('replyTo').textContent =
            'Replying to ' + name + ' (' + email + ')';
        document.getElementById('replyModal').classList.remove('hidden');
    }
    function closeReplyModal() {
        document.getElementById('replyModal').classList.add('hidden');
    }
</script>
</asp:Content>