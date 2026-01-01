import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/services/payment_service.dart';
import 'package:customer/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:customer/app/modules/checkout/data/models/order_model.dart';
import 'package:customer/app/modules/checkout/data/repositories/order_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// CheckoutController manages checkout state and payment processing
class CheckoutController extends GetxController {
  final PaymentService _paymentService = PaymentService();
  final WalletController _walletController = Get.find<WalletController>();
  final OrderRepository _orderRepository = OrderRepository();

  // Order amounts (in cents)
  RxInt subtotal = 0.obs;
  RxInt deliveryFee = 0.obs;
  RxInt tax = 0.obs;

  // Payment state
  RxBool isProcessing = false.obs;
  String? errorMessage;

  // Optional metadata for payment
  String? orderId;
  String? userId;
  
  // Order items (for creating order)
  List<OrderItem> orderItems = [];
  String? shopId;
  String? shopName;
  String? deliveryAddressText;

  @override
  void onInit() {
    super.onInit();
    // Get order details from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      subtotal.value = (args['subtotal'] as num? ?? 0).toInt();
      deliveryFee.value = (args['deliveryFee'] as num? ?? 0).toInt();
      tax.value = (args['tax'] as num? ?? 0).toInt();
      orderId = args['orderId'] as String?;
      userId = args['userId'] as String?;
      shopId = args['shopId'] as String?;
      shopName = args['shopName'] as String?;
      deliveryAddressText = args['deliveryAddressText'] as String?;
      
      // Parse order items if provided
      if (args['items'] != null) {
        final itemsList = args['items'] as List<dynamic>?;
        if (itemsList != null) {
          orderItems = itemsList
              .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList();
        }
      }
    }
    
    // Get current user ID
    final user = FirebaseAuth.instance.currentUser;
    userId = userId ?? user?.uid;
  }
  
  /// Get selected payment method from Wallet
  String get selectedPaymentMethod => _walletController.selectedMethod.value;
  
  /// Get display name for selected payment method
  String get selectedPaymentMethodName => 
      _walletController.getMethodDisplayName(selectedPaymentMethod);
  
  /// Check if selected method requires Stripe payment
  bool get requiresStripePayment {
    final method = selectedPaymentMethod;
    return method == 'apple_pay' || method == 'google_pay' || method == 'card';
  }

  /// Calculate total amount in cents
  int get totalAmount => subtotal.value + deliveryFee.value + tax.value;

  /// Format amount from cents to currency string
  String formatAmount(int cents) {
    final amount = cents / 100.0;
    return NumberFormat.currency(symbol: 'MAD ', decimalDigits: 2).format(amount);
  }

  /// Handle payment button tap
  Future<void> handlePayment() async {
    if (isProcessing.value) return;

    try {
      isProcessing.value = true;
      errorMessage = null;

      // Generate order ID if not provided
      final finalOrderId = orderId ?? const Uuid().v4();
      
      // Create order in Firestore first (with pending payment status)
      final order = OrderModel(
        orderId: finalOrderId,
        userId: userId,
        shopId: shopId,
        shopName: shopName,
        items: orderItems.isNotEmpty 
            ? orderItems 
            : [
                // Fallback: create a single item from totals if items not provided
                OrderItem(
                  productId: 'unknown',
                  title: 'Order items',
                  unitPriceMAD: subtotal.value,
                  quantity: 1,
                  lineTotalMAD: subtotal.value,
                ),
              ],
        subtotalMAD: subtotal.value,
        deliveryFeeMAD: deliveryFee.value,
        taxMAD: tax.value,
        totalMAD: totalAmount,
        paymentMethod: selectedPaymentMethod,
        paymentStatus: requiresStripePayment ? 'pending' : 'paid', // Cash is paid immediately
        deliveryAddressText: deliveryAddressText,
        orderStatus: 'pending',
        createdAt: DateTime.now(),
      );

      await _orderRepository.createOrder(order);

      // If Cash payment, complete order immediately
      if (!requiresStripePayment) {
        // Cash payment - order is already created with paymentStatus='paid'
        Get.back(result: {
          'success': true,
          'orderId': finalOrderId,
          'paymentMethod': selectedPaymentMethod,
        });
        Get.snackbar(
          'Order Placed',
          'Your order has been placed successfully. Payment on delivery.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Stripe payment flow (Apple Pay / Google Pay / Card)
      // Prepare metadata
      final metadata = <String, String>{
        'orderId': finalOrderId,
      };
      if (userId != null) metadata['userId'] = userId!;
      if (shopId != null) metadata['shopId'] = shopId!;

      // Process payment using PaymentService
      final success = await _paymentService.processPayment(
        amount: totalAmount,
        currency: 'mad',
        metadata: metadata,
      );

      if (success) {
        // Payment succeeded - update order status
        await _orderRepository.updateOrderPaymentStatus(
          orderId: finalOrderId,
          paymentStatus: 'paid',
          // paymentIntentId could be retrieved from PaymentService if needed
        );

        Get.back(result: {
          'success': true,
          'orderId': finalOrderId,
          'paymentMethod': selectedPaymentMethod,
        });
        Get.snackbar(
          'Payment Successful',
          'Your payment has been processed successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        // User cancelled - update order status
        await _orderRepository.updateOrderPaymentStatus(
          orderId: finalOrderId,
          paymentStatus: 'failed',
        );

        Get.snackbar(
          'Payment Cancelled',
          'Payment was cancelled. Order created but not paid.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // Payment failed
      errorMessage = e.toString();
      Get.snackbar(
        'Payment Failed',
        errorMessage ?? 'An error occurred during payment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isProcessing.value = false;
    }
  }
  
  /// Navigate to Wallet page to change payment method
  Future<void> changePaymentMethod() async {
    await Get.toNamed('/wallet');
    // Wallet selection is automatically updated via WalletController
    update(); // Refresh UI
  }
}

