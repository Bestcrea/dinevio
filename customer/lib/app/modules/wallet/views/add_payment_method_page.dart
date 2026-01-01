import 'dart:io';
import 'package:customer/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:customer/app/modules/wallet/data/models/payment_method_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPaymentMethodPage extends GetView<WalletController> {
  const AddPaymentMethodPage({super.key});

  static const Color _primaryPurple = Color(0xFF7E57C2);
  static const Color _darkText = Color(0xFF1A1A1A);
  static const Color _greyText = Color(0xFF757575);
  static const Color _lightGrey = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _darkText),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Add payment method',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _darkText,
          ),
        ),
      ),
      body: Obx(() {
        // Filter methods that can be added (not already available or disabled)
        final addableMethods = controller.availableMethods
            .where((m) => !m.isAvailable || m.type == 'card')
            .toList();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Select a payment method to add',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _greyText,
                  ),
                ),
                const SizedBox(height: 24),
                // Available methods to add
                ...addableMethods.map((method) => _buildMethodOption(method)),
                const SizedBox(height: 24),
                // Platform-specific options
                if (Platform.isIOS) _buildApplePayOption(),
                if (Platform.isAndroid) _buildGooglePayOption(),
                // Card option (coming soon)
                _buildCardOption(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMethodOption(PaymentMethodItem method) {
    final isEnabled = method.isEnabled;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => _handleAddMethod(method) : null,
          borderRadius: BorderRadius.circular(12),
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.5,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _lightGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isEnabled ? Colors.grey.shade300 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  _buildMethodIcon(method.type),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          method.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _darkText,
                          ),
                        ),
                        if (!isEnabled) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Coming soon',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: _greyText,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isEnabled)
                    Icon(
                      Icons.chevron_right,
                      color: _greyText,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplePayOption() {
    // Check if already added
    final alreadyAdded = controller.availableMethods
        .any((m) => m.type == 'apple_pay' && m.isAvailable);

    if (alreadyAdded) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleAddApplePay(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _lightGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.apple,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Apple Pay',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _darkText,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: _greyText,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGooglePayOption() {
    // Check if already added
    final alreadyAdded = controller.availableMethods
        .any((m) => m.type == 'google_pay' && m.isAvailable);

    if (alreadyAdded) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleAddGooglePay(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _lightGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _primaryPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Google Pay',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _darkText,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: _greyText,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardOption() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: 0.5,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _lightGrey,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.credit_card,
                  color: _greyText,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Coming soon',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: _greyText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodIcon(String methodType) {
    IconData iconData;
    Color iconColor = _primaryPurple;

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

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _lightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  void _handleAddMethod(PaymentMethodItem method) {
    HapticFeedback.lightImpact();
    
    // Select the method
    controller.selectPaymentMethod(method.type);
    
    // Show success and go back
    Get.back();
    Get.snackbar(
      'Payment method added',
      '${method.name} has been added to your wallet',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _primaryPurple,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleAddApplePay() {
    HapticFeedback.lightImpact();
    
    // TODO: Integrate with Apple Pay setup
    // For now, just select it
    controller.selectPaymentMethod('apple_pay');
    
    Get.back();
    Get.snackbar(
      'Apple Pay added',
      'Apple Pay is now available in your wallet',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _primaryPurple,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleAddGooglePay() {
    HapticFeedback.lightImpact();
    
    // TODO: Integrate with Google Pay setup
    // For now, just select it
    controller.selectPaymentMethod('google_pay');
    
    Get.back();
    Get.snackbar(
      'Google Pay added',
      'Google Pay is now available in your wallet',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _primaryPurple,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}

