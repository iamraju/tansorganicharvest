<%@ Page Title="Checkout" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Checkout.aspx.cs"
    Inherits="TansOrganicHarvest.Members.Checkout" %>

<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .option-label {
        cursor: pointer;
        transition: border-color 0.2s, background-color 0.2s;
    }
    .option-label.selected {
        border-color: #2d6a4f !important;
        background-color: #f0faf4;
    }
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

        <!-- ── LEFT: FORMS ─────────────────────────────────────── -->
        <div class="lg:col-span-2 space-y-6">

            <!-- STEP 1: Delivery Details -->
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

                    <!-- Full Name -->
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

                    <!-- Phone -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Phone <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtPhone" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5
                                      text-sm focus:outline-none focus:ring-2
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="+977 98-XXXXXXXX" />
                        <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                            ControlToValidate="txtPhone"
                            ErrorMessage="Phone is required."
                            CssClass="text-red-500 text-xs mt-1 block"
                            Display="Dynamic" ValidationGroup="CheckoutForm" />
                    </div>

                    <!-- Preferred Delivery Date -->
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

                    <!-- Address -->
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

                    <!-- City -->
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

                    <!-- Postcode -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                            Postcode
                        </label>
                        <asp:TextBox ID="txtPostcode" runat="server"
                            CssClass="w-full border border-gray-200 rounded-xl px-4 py-2.5
                                      text-sm focus:outline-none focus:ring-2
                                      focus:ring-forest/30 focus:border-forest transition"
                            placeholder="44600" />
                    </div>

                    <!-- Delivery Option -->
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-3">
                            Delivery Option <span class="text-red-500">*</span>
                        </label>

                        <%-- 
                            ASP.NET server-side radio buttons get their id mangled.
                            We use plain HTML radio inputs + JavaScript for selection
                            and read the value in code-behind via Request.Form.
                        --%>
                        <div class="grid grid-cols-2 gap-3" id="deliveryOptions">

                            <div>
                                <input type="radio"
                                       id="optDelivery"
                                       name="deliveryOption"
                                       value="Delivery"
                                       checked="checked"
                                       class="sr-only" />
                                <label for="optDelivery"
                                       class="option-label selected flex items-center gap-3
                                              border-2 border-gray-200 rounded-xl p-4"
                                       onclick="selectDelivery('optDelivery')">
                                    <span class="text-2xl">🚚</span>
                                    <div>
                                        <p class="font-semibold text-gray-800 text-sm">
                                            Home Delivery
                                        </p>
                                        <p class="text-xs text-gray-400">Free over $50</p>
                                    </div>
                                </label>
                            </div>

                            <div>
                                <input type="radio"
                                       id="optPickup"
                                       name="deliveryOption"
                                       value="Pickup"
                                       class="sr-only" />
                                <label for="optPickup"
                                       class="option-label flex items-center gap-3
                                              border-2 border-gray-200 rounded-xl p-4"
                                       onclick="selectDelivery('optPickup')">
                                    <span class="text-2xl">🏪</span>
                                    <div>
                                        <p class="font-semibold text-gray-800 text-sm">
                                            Farm Pickup
                                        </p>
                                        <p class="text-xs text-gray-400">Tue–Sat 8am–1pm</p>
                                    </div>
                                </label>
                            </div>

                        </div>
                    </div>

                    <!-- Order Notes -->
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

            <!-- STEP 2: Payment Method -->
            <div class="bg-white rounded-2xl border border-sage/20 shadow-sm p-6">
                <h2 class="font-display text-xl font-bold text-gray-800 mb-5
                           flex items-center gap-2">
                    <span class="w-7 h-7 bg-forest text-white rounded-full
                                 flex items-center justify-center text-sm font-bold">
                        2
                    </span>
                    Payment Method
                </h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-3 mb-6"
                     id="paymentOptions">

                    <!-- Cash on Delivery -->
                    <div>
                        <input type="radio"
                               id="rbCOD"
                               name="paymentMethod"
                               value="CashOnDelivery"
                               checked="checked"
                               class="sr-only" />
                        <label for="rbCOD"
                               class="option-label selected flex items-center gap-3
                                      border-2 border-gray-200 rounded-xl p-4"
                               onclick="selectPayment('rbCOD'); showPayment('cod')">
                            <span class="text-2xl">💵</span>
                            <div>
                                <p class="font-semibold text-gray-800 text-sm">
                                    Cash on Delivery
                                </p>
                                <p class="text-xs text-gray-400">Pay when delivered</p>
                            </div>
                        </label>
                    </div>

                    <!-- eSewa -->
                    <div>
                        <input type="radio"
                               id="rbEsewa"
                               name="paymentMethod"
                               value="Esewa"
                               class="sr-only" />
                        <label for="rbEsewa"
                               class="option-label flex items-center gap-3
                                      border-2 border-gray-200 rounded-xl p-4"
                               onclick="selectPayment('rbEsewa'); showPayment('esewa')">
                            <span class="text-2xl">💚</span>
                            <div>
                                <p class="font-semibold text-gray-800 text-sm">eSewa</p>
                                <p class="text-xs text-gray-400">Nepal Digital Wallet</p>
                            </div>
                        </label>
                    </div>

                </div>

                <!-- COD Panel (default visible) -->
                <div id="panelCod">
                    <div class="bg-amber-50 border border-amber-200 rounded-xl p-5
                                text-center">
                        <div class="text-4xl mb-2">💵</div>
                        <h3 class="font-bold text-amber-800 mb-1">Cash on Delivery</h3>
                        <p class="text-amber-700 text-sm">
                            Pay in cash when your order is delivered.
                            Please have the exact amount ready.
                        </p>
                    </div>
                </div>

                <!-- eSewa Panel (hidden by default) -->
                <div id="panelEsewa" class="hidden">
                    <div class="bg-green-50 border border-green-200 rounded-xl p-5
                                text-center">
                        <div class="text-4xl mb-2">💚</div>
                        <h3 class="font-bold text-green-800 mb-1">Pay with eSewa</h3>
                        <p class="text-green-700 text-sm mb-3">
                            You will be redirected to eSewa to complete your payment securely.
                        </p>
                        <div class="bg-white rounded-lg px-4 py-3 text-xs text-green-700
                                    border border-green-200 text-left space-y-1">
                            <p class="font-semibold mb-1">Sandbox Test Credentials:</p>
                            <p>eSewa ID: <strong>9806800001</strong></p>
                            <p>Password: <strong>Nepal@123</strong></p>
                            <p>OTP / Token: <strong>123456</strong></p>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- ── RIGHT: ORDER SUMMARY ────────────────────────────── -->
        <div>
            <div class="bg-white rounded-2xl border border-sage/20
                        shadow-sm p-6 sticky top-24">

                <h2 class="font-semibold text-gray-800 mb-5 pb-4
                           border-b border-gray-100">
                    Your Order
                </h2>

                <asp:Repeater ID="rptSummary" runat="server">
                    <ItemTemplate>
                        <div class="flex justify-between text-sm mb-3">
                            <span class="text-gray-600 flex-1 mr-2 truncate">
                                <%# Eval("Name") %>
                                <span class="text-gray-400">
                                    × <%# Eval("Quantity") %>
                                </span>
                            </span>
                            <span class="font-medium text-gray-800 flex-shrink-0">
                                $<%# Eval("LineTotal", "{0:F2}") %>
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="border-t border-gray-100 mt-2 pt-4 space-y-2">
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
    // ── Delivery option selection ─────────────────────────────────
    function selectDelivery(selectedId) {
        ['optDelivery', 'optPickup'].forEach(function (id) {
            var radio = document.getElementById(id);
            var label = document.querySelector('label[for="' + id + '"]');
            if (!radio || !label) return;

            if (id === selectedId) {
                radio.checked = true;
                label.classList.add('selected');
            } else {
                radio.checked = false;
                label.classList.remove('selected');
            }
        });
    }

    // ── Payment option selection ──────────────────────────────────
    function selectPayment(selectedId) {
        ['rbCOD', 'rbEsewa'].forEach(function (id) {
            var radio = document.getElementById(id);
            var label = document.querySelector('label[for="' + id + '"]');
            if (!radio || !label) return;

            if (id === selectedId) {
                radio.checked = true;
                label.classList.add('selected');
            } else {
                radio.checked = false;
                label.classList.remove('selected');
            }
        });
    }

    // ── Payment panel toggle ──────────────────────────────────────
    function showPayment(type) {
        document.getElementById('panelCod').classList.add('hidden');
        document.getElementById('panelEsewa').classList.add('hidden');

        var panel = document.getElementById(
            type === 'esewa' ? 'panelEsewa' : 'panelCod'
        );
        if (panel) panel.classList.remove('hidden');
    }

    // ── Init: apply selected state on page load ───────────────────
    document.addEventListener('DOMContentLoaded', function () {
        // Mark the initially checked delivery option
        ['optDelivery', 'optPickup'].forEach(function (id) {
            var radio = document.getElementById(id);
            var label = document.querySelector('label[for="' + id + '"]');
            if (radio && label) {
                if (radio.checked) label.classList.add('selected');
                else label.classList.remove('selected');
            }
        });

        // Mark the initially checked payment option
        ['rbCOD', 'rbEsewa'].forEach(function (id) {
            var radio = document.getElementById(id);
            var label = document.querySelector('label[for="' + id + '"]');
            if (radio && label) {
                if (radio.checked) label.classList.add('selected');
                else label.classList.remove('selected');
            }
        });

        // Show the correct initial payment panel
        var codRadio = document.getElementById('rbCOD');
        showPayment(codRadio && codRadio.checked ? 'cod' : 'esewa');
    });
</script>

</asp:Content>