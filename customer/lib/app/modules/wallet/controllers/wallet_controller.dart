import 'dart:io';
import 'package:customer/app/modules/wallet/data/models/payment_method_item.dart';
import 'package:customer/app/modules/wallet/data/repositories/wallet_repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletController extends GetxController {
  final WalletRepository _repository = WalletRepository();

  // Available payment methods
  final RxList<PaymentMethodItem> availableMethods = <PaymentMethodItem>[].obs;
  
  // Selected payment method
  final RxString selectedMethod = 'cash'.obs;
  
  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMethods();
    _loadSelectedMethod();
  }

  /// Initialize available payment methods based on platform
  void _initializeMethods() {
    final methods = <PaymentMethodItem>[];

    // Apple Pay (iOS only)
    if (Platform.isIOS) {
      methods.add(PaymentMethodItem(
        id: 'apple_pay',
        name: 'Apple Pay',
        type: 'apple_pay',
        isAvailable: true,
        isEnabled: true,
      ));
    }

    // Google Pay (Android only)
    if (Platform.isAndroid) {
      methods.add(PaymentMethodItem(
        id: 'google_pay',
        name: 'Google Pay',
        type: 'google_pay',
        isAvailable: true,
        isEnabled: true,
      ));
    }

    // Cash (always available)
    methods.add(PaymentMethodItem(
      id: 'cash',
      name: 'Cash',
      type: 'cash',
      isAvailable: true,
      isEnabled: true,
    ));

    // Card (coming soon - disabled for now)
    methods.add(PaymentMethodItem(
      id: 'card',
      name: 'Card',
      type: 'card',
      isAvailable: false,
      isEnabled: false,
    ));

    availableMethods.value = methods;
  }

  /// Load selected payment method from local storage and Firestore
  Future<void> _loadSelectedMethod() async {
    try {
      isLoading.value = true;

      // Try to load from Firestore first
      final firestoreMethod = await _repository.getSelectedPaymentMethod();
      if (firestoreMethod != null) {
        selectedMethod.value = firestoreMethod;
        isLoading.value = false;
        return;
      }

      // Fallback to local storage
      final prefs = await SharedPreferences.getInstance();
      final localMethod = prefs.getString('wallet_selected_method');
      if (localMethod != null && _isMethodAvailable(localMethod)) {
        selectedMethod.value = localMethod;
      }
    } catch (e) {
      // Use default 'cash'
      selectedMethod.value = 'cash';
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if method is available in current list
  bool _isMethodAvailable(String methodType) {
    return availableMethods.any((m) => m.type == methodType && m.isAvailable);
  }

  /// Select a payment method
  Future<void> selectPaymentMethod(String methodType) async {
    if (!_isMethodAvailable(methodType)) return;

    selectedMethod.value = methodType;

    // Save locally
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('wallet_selected_method', methodType);
    } catch (e) {
      // Silent fail
    }

    // Save to Firestore (non-blocking)
    _repository.saveSelectedPaymentMethod(methodType).catchError((_) {
      // Silent fail - local storage is sufficient
    });
  }

  /// Get display name for method type
  String getMethodDisplayName(String methodType) {
    switch (methodType) {
      case 'apple_pay':
        return 'Apple Pay';
      case 'google_pay':
        return 'Google Pay';
      case 'cash':
        return 'Cash';
      case 'card':
        return 'Card';
      default:
        return methodType;
    }
  }

  /// Check if method is currently selected
  bool isMethodSelected(String methodType) {
    return selectedMethod.value == methodType;
  }
}

