import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/checkout_controller.dart';

/// CheckoutScreen displays order summary and handles Stripe PaymentSheet
/// Supports Apple Pay and Google Pay automatically
class CheckoutScreen extends GetView<CheckoutController> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Checkout',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              // Order Summary Section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary Title
                      Text(
                        'Order Summary',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Order Items
                      _buildOrderItem(
                        label: 'Subtotal',
                        value: controller.formatAmount(controller.subtotal.value),
                      ),
                      const SizedBox(height: 8),
                      _buildOrderItem(
                        label: 'Delivery Fee',
                        value: controller.formatAmount(controller.deliveryFee.value),
                      ),
                      const SizedBox(height: 8),
                      _buildOrderItem(
                        label: 'Tax',
                        value: controller.formatAmount(controller.tax.value),
                      ),
                      const Divider(height: 32),
                      _buildOrderItem(
                        label: 'Total',
                        value: controller.formatAmount(controller.totalAmount),
                        isTotal: true,
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),

                      // Payment Method Section
                      Text(
                        'Payment Method',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPaymentMethodCard(),
                      const SizedBox(height: 24),

                      // Payment Methods Info (only for Stripe methods)
                      if (controller.requiresStripePayment)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  controller.selectedPaymentMethod == 'apple_pay'
                                      ? 'Apple Pay will appear automatically if available on your device.'
                                      : controller.selectedPaymentMethod == 'google_pay'
                                          ? 'Google Pay will appear automatically if available on your device.'
                                          : 'Card payment will be processed securely via Stripe.',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Bottom Payment Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.isProcessing.value
                          ? null
                          : () => controller.handlePayment(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7E57C2), // Primary purple
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isProcessing.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              controller.requiresStripePayment
                                  ? 'Pay ${controller.formatAmount(controller.totalAmount)}'
                                  : 'Place Order (Cash on Delivery)',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem({
    required String label,
    required String value,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard() {
    return Obx(() {
      final methodName = controller.selectedPaymentMethodName;
      final methodType = controller.selectedPaymentMethod;

      IconData iconData;
      Color iconColor = const Color(0xFF7E57C2);

      switch (methodType) {
        case 'apple_pay':
          iconData = Icons.apple;
          break;
        case 'google_pay':
          iconData = Icons.account_balance_wallet;
          break;
        case 'cash':
          iconData = Icons.money;
          iconColor = Colors.green;
          break;
        default:
          iconData = Icons.credit_card;
      }

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.changePaymentMethod(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        methodName,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      if (methodType == 'cash')
                        Text(
                          'Pay on delivery',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  'Change',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7E57C2),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

