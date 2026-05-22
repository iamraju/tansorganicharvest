<%@ Page Title="Checkout" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Checkout.aspx.cs"
    Inherits="TansOrganicHarvest.Members.Checkout" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .payment-option input[type=radio]:checked + label {
        border-color: #2d6a4f;
        background: #f0faf4;
    }
    .payment-option label { cursor: pointer; }
</style>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

<div class="bg-forest py-12 px-6 text-white text-center">
    <h1 class="font-display text-4xl font-bold">Checkout</h1>
    <p class="text-white/60 mt-2 text-sm">
        Complete your order details below
    </p>
</div>

<div class="max-w-6xl mx-auto px-6 py-12">

    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="bg-red-50 border border-red-200 text-red-700 rounded-xl 
                  px-4 py-3 mb-6 text-sm flex items-center gap-2">
        <span>⚠️</span><asp:Literal ID="litError" runat="server" />
    </asp:Panel>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

        <!-- Left: forms -->
        <div class="lg:col-span-2 space-y-6">

            <!-- Step 1: Delivery Details -->
            <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-6">
                <h2 class="font-display text-xl font-bold text-gray-800 mb-5 
                           flex items-center gap-2">
                    <span class="w-7 h-7 bg-forest text-white rounded-full 
                                 flex items-center justify-center text-sm font-bold">
                        1
                    </span>
                    Delivery Details
                </h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">

                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Full Name <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtFullName" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="Your full name" />
                        <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                            ControlToValidate="txtFullName"
                            ErrorMessage="Full name is required."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="CheckoutForm" />
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Phone <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtPhone" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="+60 12-345 6789" />
                        <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                            ControlToValidate="txtPhone"
                            ErrorMessage="Phone is required."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="CheckoutForm" />
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Preferred Delivery Date
                        </label>
                        <asp:TextBox ID="txtDeliveryDate" runat="server"
                            TextMode="Date"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition" />
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Delivery Address <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtAddress" runat="server"
                            TextMode="MultiLine" Rows="2"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest 
                                      transition resize-none"
                            placeholder="Street address, unit number..." />
                        <asp:RequiredFieldValidator ID="rfvAddress" runat="server"
                            ControlToValidate="txtAddress"
                            ErrorMessage="Address is required."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="CheckoutForm" />
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            City <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtCity" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="Your city" />
                        <asp:RequiredFieldValidator ID="rfvCity" runat="server"
                            ControlToValidate="txtCity"
                            ErrorMessage="City is required."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="CheckoutForm" />
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Postcode
                        </label>
                        <asp:TextBox ID="txtPostcode" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="12345" />
                    </div>

                    <!-- Delivery Option -->
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-3">
                            Delivery Option <span class="text-red-500">*</span>
                        </label>
                        <div class="grid grid-cols-2 gap-3">
                            <div class="payment-option">
                                <input type="radio" id="optDelivery" name="deliveryOpt"
                                       value="Delivery"
                                       runat="server"
                                       class="sr-only" Checked="true" />
                                <label for="optDelivery"
                                       class="flex items-center gap-3 border-2 
                                              border-gray-200 rounded-xl p-4 
                                              hover:border-forest transition-colors">
                                    <span class="text-2xl">🚚</span>
                                    <div>
                                        <p class="font-semibold text-gray-800 text-sm">
                                            Home Delivery
                                        </p>
                                        <p class="text-xs text-gray-400">
                                            Free over $50
                                        </p>
                                    </div>
                                </label>
                            </div>
                            <div class="payment-option">
                                <input type="radio" id="optPickup" name="deliveryOpt"
                                       value="Pickup"
                                       runat="server"
                                       class="sr-only" />
                                <label for="optPickup"
                                       class="flex items-center gap-3 border-2 
                                              border-gray-200 rounded-xl p-4 
                                              hover:border-forest transition-colors">
                                    <span class="text-2xl">🏪</span>
                                    <div>
                                        <p class="font-semibold text-gray-800 text-sm">
                                            Farm Pickup
                                        </p>
                                        <p class="text-xs text-gray-400">
                                            Tue–Sat 8am–1pm
                                        </p>
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Notes -->
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Order Notes
                            <span class="text-gray-400 font-normal ml-1">(optional)</span>
                        </label>
                        <asp:TextBox ID="txtNotes" runat="server"
                            TextMode="MultiLine" Rows="2"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5
                                      text-sm focus:outline-none focus:ring-2 
                                      focus:ring-forest/30 focus:border-forest 
                                      transition resize-none"
                            placeholder="Any special instructions..." />
                    </div>

                </div>
            </div>

            <!-- Step 2: Payment Method -->
            <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-6">
                <h2 class="font-display text-xl font-bold text-gray-800 mb-5 
                           flex items-center gap-2">
                    <span class="w-7 h-7 bg-forest text-white rounded-full 
                                 flex items-center justify-center text-sm font-bold">
                        2
                    </span>
                    Payment Method
                </h2>

                <!-- Payment selector -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-3 mb-6">

                    <!-- Inside the payment method selection grid -->
                    <div class="payment-option">
                        <asp:RadioButton ID="rbEsewa" runat="server"
                            GroupName="PaymentMethod"
                            CssClass="sr-only" />
                        <label for="<%= rbEsewa.ClientID %>"
                               onclick="showPayment('esewa')"
                               class="flex items-center gap-3 border-2 border-gray-200
                                      rounded-xl p-4 hover:border-forest transition-colors
                                      cursor-pointer block">
                            <span class="text-2xl">💚</span>
                            <div>
                                <p class="font-semibold text-gray-800 text-sm">eSewa</p>
                                <p class="text-xs text-gray-400">Nepal Digital Wallet</p>
                            </div>
                        </label>
                    </div>

                    <%--<div class="payment-option">
                        <asp:RadioButton ID="rbPayPal" runat="server"
                            GroupName="PaymentMethod"
                            CssClass="sr-only" />
                        <label for="<%= rbPayPal.ClientID %>"
                               onclick="showPayment('paypal')"
                               class="flex items-center gap-3 border-2 border-gray-200 
                                      rounded-xl p-4 hover:border-forest 
                                      transition-colors cursor-pointer block">
                            <span class="text-2xl">🅿️</span>
                            <div>
                                <p class="font-semibold text-gray-800 text-sm">
                                    PayPal
                                </p>
                                <p class="text-xs text-gray-400">Pay via PayPal</p>
                            </div>
                        </label>
                    </div>--%>

                    <div class="payment-option">
                        <asp:RadioButton ID="rbCOD" runat="server"
                            GroupName="PaymentMethod"
                            CssClass="sr-only" />
                        <label for="<%= rbCOD.ClientID %>"
                               onclick="showPayment('cod')"
                               class="flex items-center gap-3 border-2 border-gray-200 
                                      rounded-xl p-4 hover:border-forest 
                                      transition-colors cursor-pointer block">
                            <span class="text-2xl">💵</span>
                            <div>
                                <p class="font-semibold text-gray-800 text-sm">
                                    Cash on Delivery
                                </p>
                                <p class="text-xs text-gray-400">Pay when delivered</p>
                            </div>
                        </label>
                    </div>

                </div>

                <!-- Credit Card fields -->
                <div id="panelCard">
                    <div class="bg-gray-50 rounded-xl p-5 space-y-4">
                        <p class="text-xs text-amber-600 bg-amber-50 border border-amber-200 
                                  rounded-lg px-3 py-2 font-medium">
                            🔒 Simulation only — do not enter real card details
                        </p>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1.5">
                                Cardholder Name
                            </label>
                            <asp:TextBox ID="txtCardName" runat="server"
                                CssClass="w-full border border-gray-200 rounded-xl 
                                          px-4 py-2.5 text-sm focus:outline-none 
                                          focus:ring-2 focus:ring-forest/30 transition"
                                placeholder="Name on card" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1.5">
                                Card Number
                            </label>
                            <asp:TextBox ID="txtCardNumber" runat="server"
                                CssClass="w-full border border-gray-200 rounded-xl 
                                          px-4 py-2.5 text-sm focus:outline-none 
                                          focus:ring-2 focus:ring-forest/30 transition"
                                placeholder="1234 5678 9012 3456"
                                MaxLength="19" />
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium 
                                             text-gray-700 mb-1.5">
                                    Expiry Date
                                </label>
                                <asp:TextBox ID="txtExpiry" runat="server"
                                    CssClass="w-full border border-gray-200 rounded-xl 
                                              px-4 py-2.5 text-sm focus:outline-none 
                                              focus:ring-2 focus:ring-forest/30 transition"
                                    placeholder="MM/YY" MaxLength="5" />
                            </div>
                            <div>
                                <label class="block text-sm font-medium 
                                             text-gray-700 mb-1.5">
                                    CVV
                                </label>
                                <asp:TextBox ID="txtCVV" runat="server"
                                    TextMode="Password"
                                    CssClass="w-full border border-gray-200 rounded-xl 
                                              px-4 py-2.5 text-sm focus:outline-none 
                                              focus:ring-2 focus:ring-forest/30 transition"
                                    placeholder="•••" MaxLength="4" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- PayPal panel -->
                <div id="panelPaypal" class="hidden">
                    <div class="bg-blue-50 border border-blue-200 rounded-xl p-6 
                                text-center">
                        <div class="text-5xl mb-3">🅿️</div>
                        <h3 class="font-bold text-blue-800 text-lg mb-2">
                            Pay with PayPal
                        </h3>
                        <p class="text-blue-600 text-sm mb-4">
                            You will be redirected to PayPal to complete payment 
                            after placing your order.
                        </p>
                        <div class="bg-white rounded-lg px-4 py-3 text-xs 
                                    text-blue-500 border border-blue-200">
                            🔒 Simulation mode — no real PayPal transaction will occur
                        </div>
                    </div>
                </div>

                <!-- eSewa panel -->
                <div id="panelEsewa" class="hidden">
                    <div class="bg-green-50 border border-green-200 rounded-xl p-6 text-center">
                        <div class="text-5xl mb-3">💚</div>
                        <h3 class="font-bold text-green-800 text-lg mb-2">Pay with eSewa</h3>
                        <p class="text-green-700 text-sm mb-3">
                            You will be redirected to eSewa to complete your payment securely.
                        </p>
                        <div class="bg-white rounded-lg px-4 py-3 text-xs text-green-600
                                    border border-green-200 text-left space-y-1">
                            <p class="font-semibold">Sandbox Test Credentials:</p>
                            <p>eSewa ID: <strong>9806800001</strong></p>
                            <p>Password: <strong>Nepal@123</strong></p>
                            <p>OTP/Token: <strong>123456</strong></p>
                        </div>
                    </div>
                </div>

                <!-- COD panel -->
                <div id="panelCOD" class="hidden">
                    <div class="bg-amber-50 border border-amber-200 rounded-xl p-6 
                                text-center">
                        <div class="text-5xl mb-3">💵</div>
                        <h3 class="font-bold text-amber-800 text-lg mb-2">
                            Cash on Delivery
                        </h3>
                        <p class="text-amber-700 text-sm">
                            Pay in cash when your order is delivered. 
                            Please have the exact amount ready.
                        </p>
                    </div>
                </div>

            </div>
        </div>

        <!-- Right: order summary -->
        <div>
            <div class="bg-white rounded-2xl border border-sage/20 
                        shadow-sm p-6 sticky top-24">

                <h2 class="font-semibold text-gray-800 mb-5 pb-4 
                           border-b border-gray-100">
                    Your Order
                </h2>

                <!-- Items summary -->
                <asp:Repeater ID="rptSummary" runat="server">
                    <ItemTemplate>
                        <div class="flex justify-between text-sm mb-3">
                            <span class="text-gray-600 flex-1 mr-2 truncate">
                                <%# Eval("Name") %>
                                <span class="text-gray-400">× <%# Eval("Quantity") %></span>
                            </span>
                            <span class="font-medium text-gray-800 flex-shrink-0">
                                $<%# Eval("LineTotal", "{0:F2}") %>
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="border-t border-gray-100 mt-4 pt-4 space-y-2">
                    <div class="flex justify-between text-sm text-gray-600">
                        <span>Subtotal</span>
                        <span>$<asp:Literal ID="litSubtotal" runat="server" /></span>
                    </div>
                    <div class="flex justify-between text-sm text-gray-600">
                        <span>Delivery</span>
                        <asp:Literal ID="litDelivery" runat="server" />
                    </div>
                </div>

                <div class="border-t border-gray-100 mt-3 pt-3">
                    <div class="flex justify-between font-bold text-gray-800 text-lg">
                        <span>Total</span>
                        <span class="text-forest">
                            $<asp:Literal ID="litTotal" runat="server" />
                        </span>
                    </div>
                </div>

                <asp:Button ID="btnPlaceOrder" runat="server"
                    Text="Place Order →"
                    OnClick="btnPlaceOrder_Click"
                    ValidationGroup="CheckoutForm"
                    CssClass="w-full bg-forest hover:bg-forest-dark text-white 
                              font-bold py-4 rounded-xl transition-colors 
                              cursor-pointer text-sm mt-6" />

                <p class="text-xs text-gray-400 text-center mt-3">
                    🔒 Your information is secure and encrypted
                </p>

            </div>
        </div>

    </div>
</div>

<script>
    function showPayment(type) {
        //document.getElementById('panelCard').classList.add('hidden');
        //document.getElementById('panelPaypal').classList.add('hidden');
        //document.getElementById('panelCOD').classList.add('hidden');
        //document.getElementById('panelEsewa').classList.add('hidden');

        //if (type === 'card')   document.getElementById('panelCard').classList.remove('hidden');
        //if (type === 'paypal') document.getElementById('panelPaypal').classList.remove('hidden');
        //if (type === 'cod')    document.getElementById('panelCOD').classList.remove('hidden');
        //if (type === 'esewa')  document.getElementById('panelEsewa').classList.remove('hidden');
        ['card', 'paypal', 'cod', 'esewa'].forEach(function (t) {
            document.getElementById('panel' + t.charAt(0).toUpperCase() + t.slice(1))
                .classList.add('hidden');
        });
        let id = 'panel' + type.charAt(0).toUpperCase() + type.slice(1);
        document.getElementById(id).classList.remove('hidden');
    }

    // Format card number with spaces
    document.addEventListener('DOMContentLoaded', function () {
        let cardInput = document.getElementById('<%= txtCardNumber.ClientID %>');
        if (cardInput) {
            cardInput.addEventListener('input', function (e) {
                let val = e.target.value.replace(/\D/g, '').substring(0, 16);
                e.target.value = val.replace(/(.{4})/g, '$1 ').trim();
            });
        }
        let expiryInput = document.getElementById('<%= txtExpiry.ClientID %>');
        if (expiryInput) {
            expiryInput.addEventListener('input', function (e) {
                let val = e.target.value.replace(/\D/g, '').substring(0, 4);
                if (val.length >= 2)
                    e.target.value = val.substring(0, 2) + '/' + val.substring(2);
                else
                    e.target.value = val;
            });
        }
    });
</script>

</asp:Content>