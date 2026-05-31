<%@ Page Title="My Subscriptions" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Subscriptions.aspx.cs"
    Inherits="TansOrganicHarvest.Members.Subscriptions" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<div class="bg-forest py-12 px-6 text-white text-center">
    <h1 class="font-display text-4xl font-bold">My Subscriptions</h1>
    <p class="text-white/60 mt-2 text-sm">
        Manage your weekly produce box subscriptions
    </p>
</div>

<div class="max-w-5xl mx-auto px-6 py-12">

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="bg-green-50 border border-green-200 text-green-700 rounded-xl
                  px-4 py-3 mb-6 text-sm flex items-center gap-2">
        <span>✅</span><asp:Literal ID="litSuccess" runat="server" />
    </asp:Panel>
    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="bg-red-50 border border-red-200 text-red-700 rounded-xl
                  px-4 py-3 mb-6 text-sm flex items-center gap-2">
        <span>⚠️</span><asp:Literal ID="litError" runat="server" />
    </asp:Panel>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

        <!-- Left: Subscribe form -->
        <div class="lg:col-span-1">
            <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-6">
                <h2 class="font-display text-xl font-bold text-gray-800 mb-5">
                    Subscribe to a Box
                </h2>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Select Box <span class="text-red-500">*</span>
                    </label>
                    <asp:DropDownList ID="ddlBox" runat="server"
                        CssClass="w-full border border-gray-200 rounded-xl px-3 py-2.5
                                  text-sm focus:outline-none focus:ring-2
                                  focus:ring-forest/30 bg-white" />
                    <asp:RequiredFieldValidator ID="rfvBox" runat="server"
                        ControlToValidate="ddlBox" InitialValue=""
                        ErrorMessage="Please select a box."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="SubForm" />
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Delivery Frequency <span class="text-red-500">*</span>
                    </label>
                    <asp:DropDownList ID="ddlFrequency" runat="server"
                        CssClass="w-full border border-gray-200 rounded-xl px-3 py-2.5
                                  text-sm focus:outline-none focus:ring-2
                                  focus:ring-forest/30 bg-white">
                        <asp:ListItem Text="Weekly"      Value="Weekly" />
                        <asp:ListItem Text="Fortnightly" Value="Fortnightly" />
                        <asp:ListItem Text="Monthly"     Value="Monthly" />
                    </asp:DropDownList>
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Start Date <span class="text-red-500">*</span>
                    </label>
                    <asp:TextBox ID="txtStartDate" runat="server"
                        TextMode="Date"
                        CssClass="w-full border border-gray-200 rounded-xl px-3 py-2.5
                                  text-sm focus:outline-none focus:ring-2
                                  focus:ring-forest/30" />
                    <asp:RequiredFieldValidator ID="rfvDate" runat="server"
                        ControlToValidate="txtStartDate"
                        ErrorMessage="Please select a start date."
                        CssClass="text-red-500 text-xs mt-1 block"
                        Display="Dynamic" ValidationGroup="SubForm" />
                </div>

                <div class="mb-5">
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">
                        Special Notes
                    </label>
                    <asp:TextBox ID="txtNotes" runat="server"
                        TextMode="MultiLine" Rows="2"
                        CssClass="w-full border border-gray-200 rounded-xl px-3 py-2.5
                                  text-sm focus:outline-none focus:ring-2
                                  focus:ring-forest/30 resize-none"
                        placeholder="Any preferences or allergies..." />
                </div>

                <asp:Button ID="btnSubscribe" runat="server"
                    Text="Subscribe Now"
                    OnClick="btnSubscribe_Click"
                    ValidationGroup="SubForm"
                    CssClass="w-full bg-forest hover:bg-forest-dark text-white
                              font-bold py-3 rounded-xl cursor-pointer text-sm
                              transition-colors" />

                <!-- Price info based on selected box -->
                <div class="mt-4 bg-sage/10 rounded-xl p-3 text-xs text-forest text-center">
                    🌿 You earn <strong>loyalty points</strong> on every subscription delivery!
                </div>
            </div>
        </div>

        <!-- Right: Active subscriptions -->
        <div class="lg:col-span-2">

            <h2 class="font-display text-xl font-bold text-gray-800 mb-4">
                Active Subscriptions
            </h2>

            <!-- Empty state -->
            <asp:Panel ID="pnlNoSubs" runat="server" Visible="false"
                CssClass="bg-white rounded-2xl border border-sage/20 shadow-sm
                          p-12 text-center">
                <div class="text-5xl mb-4">📦</div>
                <h3 class="font-display text-xl font-semibold text-gray-600 mb-2">
                    No active subscriptions
                </h3>
                <p class="text-gray-400 text-sm">
                    Subscribe to a produce box on the left to get
                    fresh organic produce delivered regularly.
                </p>
            </asp:Panel>

            <!-- Subscriptions list -->
            <asp:Repeater ID="rptSubscriptions" runat="server"
                OnItemCommand="rptSubscriptions_ItemCommand">
                <ItemTemplate>
                    <div class="bg-white rounded-2xl border border-sage/20 shadow-sm
                                mb-4 overflow-hidden">
                        <div class="p-5">
                            <div class="flex items-start justify-between gap-4">
                                <div class="flex items-center gap-4">
                                    <div class="w-14 h-14 bg-sage/10 rounded-xl
                                                overflow-hidden flex-shrink-0">
                                        <asp:Image ID="imgBox" runat="server"
                                            ImageUrl='<%# ViewHelpers.GetImageUrl(Eval("ImageUrl")) %>'
                                            CssClass="w-full h-full object-cover" />
                                    </div>
                                    <div>
                                        <h3 class="font-semibold text-gray-800">
                                            <%# Eval("BoxName") %>
                                        </h3>
                                        <p class="text-sm text-forest font-bold mt-0.5">
                                            $<%# Eval("Price", "{0:F2}") %> / delivery
                                        </p>
                                    </div>
                                </div>
                                <asp:Literal ID="litStatus" runat="server"
                                    Text='<%# GetStatusBadge(Eval("Status").ToString()) %>'
                                    Mode="PassThrough" />
                            </div>

                            <div class="grid grid-cols-3 gap-3 mt-4 pt-4
                                        border-t border-gray-100 text-center">
                                <div>
                                    <p class="text-xs text-gray-400">Frequency</p>
                                    <p class="font-semibold text-gray-700 text-sm mt-0.5">
                                        <%# Eval("Frequency") %>
                                    </p>
                                </div>
                                <div>
                                    <p class="text-xs text-gray-400">Started</p>
                                    <p class="font-semibold text-gray-700 text-sm mt-0.5">
                                        <%# Eval("StartDate", "{0:dd MMM yyyy}") %>
                                    </p>
                                </div>
                                <div>
                                    <p class="text-xs text-gray-400">Next Delivery</p>
                                    <p class="font-semibold text-gray-700 text-sm mt-0.5">
                                        <%# Eval("NextDelivery", "{0:dd MMM yyyy}") %>
                                    </p>
                                </div>
                            </div>

                            <%# !string.IsNullOrEmpty(Eval("Notes").ToString())
                                ? "<p class='text-xs text-gray-400 mt-3 italic'>Note: " + Eval("Notes") + "</p>"
                                : "" %>

                            <div class="flex gap-2 mt-4 pt-3 border-t border-gray-100">
                                <%# Eval("Status").ToString() == "Active"
                                    ? "<span class='text-xs text-gray-400'>Your box will be delivered " + Eval("Frequency").ToString().ToLower() + ".</span>"
                                    : "" %>
                                <div class="ml-auto flex gap-2">
                                    <asp:LinkButton ID="btnPause" runat="server"
                                        CommandName='<%# Eval("Status").ToString() == "Active" ? "Pause" : "Resume" %>'
                                        CommandArgument='<%# Eval("SubscriptionId") %>'
                                        CssClass="text-amber-600 hover:text-amber-800
                                                  text-xs font-medium transition-colors">
                                        <%# Eval("Status").ToString() == "Active" ? "⏸ Pause" : "▶ Resume" %>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnCancel" runat="server"
                                        CommandName="Cancel"
                                        CommandArgument='<%# Eval("SubscriptionId") %>'
                                        CssClass="text-red-400 hover:text-red-600
                                                  text-xs font-medium transition-colors"
                                        OnClientClick="return confirm('Cancel this subscription?');">
                                        ✕ Cancel
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </div>
    </div>
</div>

</asp:Content>