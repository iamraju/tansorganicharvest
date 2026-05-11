<%@ Page Title="Order Detail" Language="C#"
    MasterPageFile="~/Admin/Masters/AdminMaster.master"
    AutoEventWireup="true" CodeBehind="OrderDetail.aspx.cs"
    Inherits="TansOrganicHarvest.Admin.OrderDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="flex items-center gap-3 mb-6">
        <a href="Orders.aspx"
           class="text-gray-400 hover:text-gray-600 transition-colors">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15 19l-7-7 7-7"/>
            </svg>
        </a>
        <div>
            <h1 class="text-2xl font-bold text-gray-800">
                Order #<asp:Literal ID="litOrderId" runat="server" />
            </h1>
            <p class="text-gray-500 text-sm mt-0.5">
                Placed on <asp:Literal ID="litOrderDate" runat="server" />
            </p>
        </div>
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="bg-green-50 border border-green-200 text-green-700 rounded-lg 
                  px-4 py-3 mb-5 text-sm flex items-center gap-2">
        <span>✅</span><asp:Literal ID="litSuccess" runat="server" />
    </asp:Panel>

    <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">

        <!-- Left: items + status update -->
        <div class="xl:col-span-2 space-y-5">

            <!-- Order Items -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="font-semibold text-gray-800 mb-4 pb-3 
                           border-b border-gray-100">
                    Order Items
                </h2>
                <asp:Repeater ID="rptItems" runat="server">
                    <ItemTemplate>
                        <div class="flex items-center gap-4 py-3 
                                    border-b border-gray-50 last:border-0">
                            <div class="w-14 h-14 rounded-xl overflow-hidden 
                                        bg-sage/10 flex-shrink-0">
                                <asp:Image ID="imgItem" runat="server"
                                    ImageUrl='<%# ViewHelpers.GetImageUrl(Eval("ImageUrl")) %>'
                                    CssClass="w-full h-full object-cover" />
                            </div>
                            <div class="flex-1">
                                <p class="font-medium text-gray-800">
                                    <%# Eval("Name") %>
                                </p>
                                <p class="text-xs text-gray-400 mt-0.5">
                                    <%# Eval("CategoryName") %>
                                </p>
                            </div>
                            <div class="text-right">
                                <p class="text-sm text-gray-600">
                                    <%# Eval("Quantity") %> ×
                                    $<%# Eval("UnitPrice", "{0:F2}") %>
                                </p>
                                <p class="font-bold text-gray-800">
                                    $<%# Eval("LineTotal", "{0:F2}") %>
                                </p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <!-- Totals -->
                <div class="mt-4 pt-4 border-t border-gray-100 space-y-2">
                    <div class="flex justify-between text-sm text-gray-600">
                        <span>Subtotal</span>
                        <span>$<asp:Literal ID="litSubtotal" runat="server" /></span>
                    </div>
                    <div class="flex justify-between text-sm text-gray-600">
                        <span>Delivery Fee</span>
                        <asp:Literal ID="litDeliveryFee" runat="server" />
                    </div>
                    <div class="flex justify-between font-bold text-gray-800 text-lg 
                                pt-2 border-t border-gray-200">
                        <span>Total</span>
                        <span class="text-[#2d6a4f]">
                            $<asp:Literal ID="litTotal" runat="server" />
                        </span>
                    </div>
                </div>
            </div>

            <!-- Update Order Status -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h2 class="font-semibold text-gray-800 mb-5 pb-3 
                           border-b border-gray-100">
                    Update Order Status
                </h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Order Status
                        </label>
                        <asp:DropDownList ID="ddlOrderStatus" runat="server"
                            CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-[#2d6a4f] bg-white">
                            <asp:ListItem Text="Pending"    Value="Pending" />
                            <asp:ListItem Text="Processing" Value="Processing" />
                            <asp:ListItem Text="Shipped"    Value="Shipped" />
                            <asp:ListItem Text="Delivered"  Value="Delivered" />
                            <asp:ListItem Text="Cancelled"  Value="Cancelled" />
                        </asp:DropDownList>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Payment Status
                        </label>
                        <asp:DropDownList ID="ddlPaymentStatus" runat="server"
                            CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-[#2d6a4f] bg-white">
                            <asp:ListItem Text="Unpaid"    Value="Unpaid" />
                            <asp:ListItem Text="Paid"      Value="Paid" />
                            <asp:ListItem Text="Refunded"  Value="Refunded" />
                        </asp:DropDownList>
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Admin Notes
                        </label>
                        <asp:TextBox ID="txtAdminNotes" runat="server"
                            TextMode="MultiLine" Rows="3"
                            CssClass="w-full border border-gray-300 rounded-lg px-3 py-2.5 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-[#2d6a4f] resize-none"
                            placeholder="Internal notes about this order..." />
                    </div>
                </div>
                <div class="mt-5 pt-4 border-t border-gray-100">
                    <asp:Button ID="btnUpdateStatus" runat="server"
                        Text="Update Order"
                        OnClick="btnUpdateStatus_Click"
                        CssClass="bg-[#2d6a4f] hover:bg-[#1b4332] text-white 
                                  font-semibold px-6 py-2.5 rounded-lg 
                                  transition-colors cursor-pointer text-sm" />
                </div>
            </div>

        </div>

        <!-- Right: customer + delivery + payment -->
        <div class="space-y-5">

            <!-- Customer Info -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
                <h2 class="font-semibold text-gray-800 mb-4 pb-3 
                           border-b border-gray-100 text-sm">
                    Customer
                </h2>
                <div class="space-y-2 text-sm">
                    <div class="flex gap-2">
                        <span class="text-gray-400 w-16 flex-shrink-0">Name</span>
                        <span class="font-medium text-gray-700">
                            <asp:Literal ID="litCustomerName" runat="server" />
                        </span>
                    </div>
                    <div class="flex gap-2">
                        <span class="text-gray-400 w-16 flex-shrink-0">Email</span>
                        <span class="text-gray-600 break-all">
                            <asp:Literal ID="litCustomerEmail" runat="server" />
                        </span>
                    </div>
                    <div class="flex gap-2">
                        <span class="text-gray-400 w-16 flex-shrink-0">Phone</span>
                        <span class="text-gray-600">
                            <asp:Literal ID="litCustomerPhone" runat="server" />
                        </span>
                    </div>
                </div>
            </div>

            <!-- Delivery Info -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
                <h2 class="font-semibold text-gray-800 mb-4 pb-3 
                           border-b border-gray-100 text-sm">
                    Delivery
                </h2>
                <div class="space-y-2 text-sm">
                    <div class="flex gap-2">
                        <span class="text-gray-400 w-16 flex-shrink-0">Option</span>
                        <span class="font-medium text-gray-700">
                            <asp:Literal ID="litDeliveryOption" runat="server" />
                        </span>
                    </div>
                    <div class="flex gap-2">
                        <span class="text-gray-400 w-16 flex-shrink-0">Address</span>
                        <span class="text-gray-600">
                            <asp:Literal ID="litDeliveryAddress" runat="server" />
                        </span>
                    </div>
                    <div class="flex gap-2">
                        <span class="text-gray-400 w-16 flex-shrink-0">Date</span>
                        <span class="text-gray-600">
                            <asp:Literal ID="litPreferredDate" runat="server" />
                        </span>
                    </div>
                    <div class="flex gap-2 mt-2">
                        <span class="text-gray-400 w-16 flex-shrink-0">Status</span>
                        <asp:Literal ID="litDeliveryStatus" runat="server"
                            Mode="PassThrough" />
                    </div>
                </div>

                <!-- Update delivery status -->
                <div class="mt-4 pt-4 border-t border-gray-100">
                    <label class="block text-xs font-medium text-gray-500 mb-1.5">
                        Update Delivery Status
                    </label>
                    <div class="flex gap-2">
                        <asp:DropDownList ID="ddlDeliveryStatus" runat="server"
                            CssClass="flex-1 border border-gray-300 rounded-lg px-3 py-2 
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-[#2d6a4f] bg-white">
                            <asp:ListItem Text="Pending"   Value="Pending" />
                            <asp:ListItem Text="Preparing" Value="Preparing" />
                            <asp:ListItem Text="Shipped"   Value="Shipped" />
                            <asp:ListItem Text="Delivered" Value="Delivered" />
                            <asp:ListItem Text="Failed"    Value="Failed" />
                        </asp:DropDownList>
                        <asp:Button ID="btnUpdateDelivery" runat="server"
                            Text="Save"
                            OnClick="btnUpdateDelivery_Click"
                            CssClass="bg-gray-800 hover:bg-gray-900 text-white text-xs 
                                      font-medium px-4 py-2 rounded-lg cursor-pointer" />
                    </div>
                </div>
            </div>

            <!-- Payment Info -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
                <h2 class="font-semibold text-gray-800 mb-4 pb-3 
                           border-b border-gray-100 text-sm">
                    Payment
                </h2>
                <div class="space-y-2 text-sm">
                    <div class="flex gap-2">
                        <span class="text-gray-400 w-20 flex-shrink-0">Method</span>
                        <span class="font-medium text-gray-700">
                            <asp:Literal ID="litPayMethod" runat="server" />
                        </span>
                    </div>
                    <div class="flex gap-2">
                        <span class="text-gray-400 w-20 flex-shrink-0">Amount</span>
                        <span class="font-bold text-[#2d6a4f]">
                            $<asp:Literal ID="litPayAmount" runat="server" />
                        </span>
                    </div>
                    <div class="flex gap-2">
                        <span class="text-gray-400 w-20 flex-shrink-0">Ref</span>
                        <span class="text-gray-600 font-mono text-xs">
                            <asp:Literal ID="litPayRef" runat="server" />
                        </span>
                    </div>
                    <asp:Panel ID="pnlCardInfo" runat="server" Visible="false">
                        <div class="flex gap-2">
                            <span class="text-gray-400 w-20 flex-shrink-0">Card</span>
                            <span class="text-gray-600">
                                **** **** **** 
                                <asp:Literal ID="litCardLast4" runat="server" />
                            </span>
                        </div>
                    </asp:Panel>
                </div>
            </div>

        </div>
    </div>

</asp:Content>