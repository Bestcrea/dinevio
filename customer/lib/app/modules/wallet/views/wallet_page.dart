import 'package:customer/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:customer/app/modules/wallet/data/models/payment_method_item.dart';
import 'package:customer/app/modules/wallet/views/add_payment_method_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletPage extends GetView<WalletController> {
  const WalletPage({super.key});

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
          icon: const Icon(Icons.close, color: _darkText),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Wallet',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _darkText,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Payment methods section
                _buildSectionHeader('Payment methods'),
                const SizedBox(height: 16),
                // Payment methods list
                _buildPaymentMethodsList(),
                const SizedBox(height: 24),
                // Add payment method button
                _buildAddPaymentMethodButton(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: _darkText,
      ),
    );
  }

  Widget _buildPaymentMethodsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Obx(() {
        final methods = controller.availableMethods
            .where((m) => m.isAvailable && m.type != 'card')
            .toList();

        if (methods.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: methods.asMap().entries.map((entry) {
            final index = entry.key;
            final method = entry.value;
            final isSelected = controller.isMethodSelected(method.type);

            return Column(
              children: [
                _buildPaymentMethodRow(method, isSelected),
                if (index < methods.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.shade200,
                    indent: 56,
                  ),
              ],
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _buildPaymentMethodRow(PaymentMethodItem method, bool isSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleMethodTap(method),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              // Icon
              _buildMethodIcon(method.type),
              const SizedBox(width: 16),
              // Title
              Expanded(
                child: Text(
                  method.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _darkText,
                  ),
                ),
              ),
              // Selection indicator or chevron
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: _primaryPurple,
                  size: 24,
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: _greyText,
                  size: 24,
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

  void _handleMethodTap(PaymentMethodItem method) {
    // Haptic feedback
    HapticFeedback.lightImpact();

    // Select method
    controller.selectPaymentMethod(method.type);

    // Show confirmation
    Get.snackbar(
      'Payment method selected',
      '${method.name} is now your default payment method',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _primaryPurple,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  Widget _buildAddPaymentMethodButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToAddPaymentMethod(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: _lightGrey,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: _primaryPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Add payment method',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _primaryPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAddPaymentMethod(BuildContext context) {
    Get.to(() => const AddPaymentMethodPage());
  }
}

