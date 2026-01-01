import 'package:customer/features/para/data/models/para_order_model.dart';
import 'package:customer/features/para/data/repositories/para_orders_repository.dart';
import 'package:customer/features/para/state/para_cart_controller.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';

// ParaOrderItemModel is in para_order_model.dart

/// GetX Controller for Checkout
class ParaCheckoutController extends GetxController {
  final ParaOrdersRepository _ordersRepository = ParaOrdersRepository();
  final ParaCartController _cartController = Get.find<ParaCartController>();

  // State
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString deliveryAddress = ''.obs;
  final RxString paymentMethod = 'cash'.obs; // 'cash' | 'card'
  final RxBool isCardEnabled = false.obs; // Set to true when Stripe integrated

  @override
  void onInit() {
    super.onInit();
    // Check if user is logged in
    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) {
      Get.snackbar('Login Required', 'Please login to checkout');
      Get.back();
      return;
    }
  }

  /// Set delivery address
  void setDeliveryAddress(String address) {
    deliveryAddress.value = address;
  }

  /// Set payment method
  void setPaymentMethod(String method) {
    if (method == 'card' && !isCardEnabled.value) {
      Get.snackbar('Coming Soon', 'Card payment will be available soon');
      return;
    }
    paymentMethod.value = method;
  }

  /// Place order
  Future<String?> placeOrder() async {
    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) {
      Get.snackbar('Login Required', 'Please login to place order');
      return null;
    }

    if (_cartController.isEmpty) {
      Get.snackbar('Empty Cart', 'Your cart is empty');
      return null;
    }

    if (deliveryAddress.value.isEmpty) {
      Get.snackbar('Address Required', 'Please enter delivery address');
      return null;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final cart = _cartController.cart.value!;
      final cartItems = _cartController.items;

      // Convert cart items to order items
      final orderItems = cartItems.map((item) => ParaOrderItemModel(
            id: item.id,
            productId: item.productId,
            title: item.title,
            imageUrl: item.imageUrl,
            unitPriceMad: item.unitPriceMad,
            quantity: item.quantity,
            lineTotal: item.lineTotal,
          )).toList();

      // Create order
      final orderId = await _ordersRepository.createOrder(
        userId: uid,
        shopId: cart.shopId,
        shopName: cart.shopName,
        subtotal: cart.subtotal,
        deliveryFee: cart.deliveryFee,
        total: cart.total,
        paymentMethod: paymentMethod.value,
        deliveryAddressText: deliveryAddress.value,
        items: orderItems,
      );

      // Clear cart
      await _cartController.clearCart();

      isLoading.value = false;
      return orderId;
    } catch (e) {
      error.value = 'Failed to place order: $e';
      isLoading.value = false;
      Get.snackbar('Error', error.value);
      return null;
    }
  }
}

