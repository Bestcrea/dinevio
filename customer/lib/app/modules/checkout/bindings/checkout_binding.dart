import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import 'package:customer/app/modules/wallet/controllers/wallet_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure WalletController is available
    if (!Get.isRegistered<WalletController>()) {
      Get.lazyPut<WalletController>(() => WalletController());
    }
    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}

