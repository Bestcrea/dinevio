import 'package:customer/features/para/data/models/para_cart_item_model.dart';
import 'package:customer/features/para/data/models/para_product_model.dart';
import 'package:customer/features/para/data/models/para_shop_model.dart';
import 'package:customer/features/para/data/repositories/para_cart_repository.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';

/// GetX Controller for Cart management
class ParaCartController extends GetxController {
  final ParaCartRepository _repository = ParaCartRepository();

  // State
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rxn<ParaCartModel> cart = Rxn<ParaCartModel>();
  final RxList<ParaCartItemModel> items = <ParaCartItemModel>[].obs;
  final RxInt itemCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  /// Load cart and items
  Future<void> loadCart() async {
    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) {
      cart.value = null;
      items.clear();
      itemCount.value = 0;
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final cartData = await _repository.getCart(uid);
      cart.value = cartData;

      if (cartData != null) {
        final cartItems = await _repository.getCartItems(uid);
        items.value = cartItems;
        itemCount.value = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
      } else {
        items.clear();
        itemCount.value = 0;
      }
    } catch (e) {
      error.value = 'Failed to load cart: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Add product to cart
  Future<bool> addToCart(ParaShopModel shop, ParaProductModel product) async {
    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) {
      Get.snackbar('Login Required', 'Please login to add items to cart');
      // Navigate to login if needed
      return false;
    }

    try {
      isLoading.value = true;
      error.value = '';

      // Check for shop conflict
      if (cart.value != null && cart.value!.shopId != shop.id) {
        isLoading.value = false;
        return false; // Return false to trigger conflict dialog
      }

      await _repository.addItem(
        uid: uid,
        productId: product.id,
        title: product.title,
        imageUrl: product.imageUrl,
        unitPriceMad: product.priceMad,
        shopId: shop.id,
        shopName: shop.name,
      );

      await loadCart();
      return true;
    } catch (e) {
      if (e.toString().contains('CART_CONFLICT')) {
        isLoading.value = false;
        return false; // Trigger conflict dialog
      }
      error.value = 'Failed to add item: $e';
      Get.snackbar('Error', error.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle cart conflict (different shop)
  Future<bool> handleCartConflict(ParaShopModel newShop) async {
    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) return false;

    try {
      await _repository.clearCart(uid);
      cart.value = null;
      items.clear();
      itemCount.value = 0;
      return true;
    } catch (e) {
      error.value = 'Failed to clear cart: $e';
      return false;
    }
  }

  /// Increase item quantity
  Future<void> increaseQuantity(ParaCartItemModel item) async {
    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) return;

    try {
      isLoading.value = true;
      await _repository.increaseQuantity(uid, item.id, item.unitPriceMad);
      await loadCart();
    } catch (e) {
      error.value = 'Failed to update quantity: $e';
      Get.snackbar('Error', error.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Decrease item quantity
  Future<void> decreaseQuantity(ParaCartItemModel item) async {
    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) return;

    try {
      isLoading.value = true;
      await _repository.decreaseQuantity(uid, item.id, item.unitPriceMad);
      await loadCart();
    } catch (e) {
      error.value = 'Failed to update quantity: $e';
      Get.snackbar('Error', error.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove item from cart
  Future<void> removeItem(ParaCartItemModel item) async {
    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) return;

    try {
      isLoading.value = true;
      await _repository.removeItem(uid, item.id);
      await loadCart();
    } catch (e) {
      error.value = 'Failed to remove item: $e';
      Get.snackbar('Error', error.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) return;

    try {
      isLoading.value = true;
      await _repository.clearCart(uid);
      cart.value = null;
      items.clear();
      itemCount.value = 0;
    } catch (e) {
      error.value = 'Failed to clear cart: $e';
      Get.snackbar('Error', error.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Get subtotal
  double get subtotal => cart.value?.subtotal ?? 0.0;

  /// Get delivery fee
  double get deliveryFee => cart.value?.deliveryFee ?? 0.0;

  /// Get total
  double get total => cart.value?.total ?? 0.0;

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty || cart.value == null;
}

