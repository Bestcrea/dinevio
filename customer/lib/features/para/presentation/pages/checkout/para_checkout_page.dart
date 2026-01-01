import 'package:customer/features/para/state/para_cart_controller.dart';
import 'package:customer/features/para/state/para_checkout_controller.dart';
import 'package:customer/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Checkout page for Parapharmacy
class ParaCheckoutPage extends StatelessWidget {
  const ParaCheckoutPage({super.key});

  static const Color _primaryPurple = Color(0xFF7E57C2);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<ParaCartController>();
    final checkoutController = Get.put(ParaCheckoutController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (cartController.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Back to Cart'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildDeliveryAddressSection(checkoutController),
                  const SizedBox(height: 16),
                  _buildPaymentMethodSection(checkoutController),
                  const SizedBox(height: 16),
                  _buildOrderSummary(cartController),
                ],
              ),
            ),
            _buildPlaceOrderButton(checkoutController),
          ],
        );
      }),
    );
  }

  Widget _buildDeliveryAddressSection(ParaCheckoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: _primaryPurple, size: 20),
              const SizedBox(width: 8),
              Text(
                'Delivery Address',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showAddressDialog(controller),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => Text(
                          controller.deliveryAddress.value.isEmpty
                              ? 'Tap to enter delivery address'
                              : controller.deliveryAddress.value,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: controller.deliveryAddress.value.isEmpty
                                ? Colors.grey[600]
                                : Colors.black87,
                          ),
                        )),
                  ),
                  Icon(Icons.edit, color: Colors.grey[600], size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog(ParaCheckoutController controller) {
    final addressController = TextEditingController(text: controller.deliveryAddress.value);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delivery Address',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: 'Enter your address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      controller.setDeliveryAddress(addressController.text);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: _primaryPurple),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection(ParaCheckoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: _primaryPurple, size: 20),
              const SizedBox(width: 8),
              Text(
                'Payment Method',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => _buildPaymentOption(
                'Cash on Delivery',
                'cash',
                Icons.money,
                controller.paymentMethod.value == 'cash',
                controller,
              )),
          const SizedBox(height: 8),
          Obx(() => _buildPaymentOption(
                'Card Payment',
                'card',
                Icons.credit_card,
                controller.paymentMethod.value == 'card',
                controller,
                isEnabled: controller.isCardEnabled.value,
              )),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    String label,
    String value,
    IconData icon,
    bool isSelected,
    ParaCheckoutController controller, {
    bool isEnabled = true,
  }) {
    return GestureDetector(
      onTap: isEnabled ? () => controller.setPaymentMethod(value) : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? _primaryPurple.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primaryPurple : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? _primaryPurple : Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isEnabled ? Colors.black87 : Colors.grey[400],
                ),
              ),
            ),
            if (!isEnabled)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Coming soon',
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[600]),
                ),
              ),
            if (isSelected && isEnabled)
              Icon(Icons.check_circle, color: _primaryPurple, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(ParaCartController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...controller.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.title} x${item.quantity}',
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatMoneyMAD(item.lineTotal),
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )),
          const Divider(height: 24),
          _buildSummaryRow('Subtotal', controller.subtotal),
          const SizedBox(height: 8),
          _buildSummaryRow('Delivery Fee', controller.deliveryFee),
          const Divider(height: 24),
          _buildSummaryRow('Total', controller.total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          CurrencyFormatter.formatMoneyMAD(amount),
          style: GoogleFonts.inter(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? _primaryPurple : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(ParaCheckoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() => SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        final orderId = await controller.placeOrder();
                        if (orderId != null) {
                          Get.snackbar('Success', 'Order placed successfully!',
                              backgroundColor: Colors.green, colorText: Colors.white);
                          Get.offNamed('/para-order-details', arguments: {'orderId': orderId});
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'Place Order',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            )),
      ),
    );
  }
}

