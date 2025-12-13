import 'package:customer/app/models/user_model.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/notification_service.dart';
import 'package:get/get.dart';

class MyAccountController extends GetxController {
  RxString name = 'Demo'.obs;
  RxString phone = '+212 1234567890'.obs;
  RxString profilePic = ''.obs;
  RxDouble rating = 5.0.obs;
  RxDouble profileCompletion = 0.4.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final UserModel? user = await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid());
    if (user != null) {
      name.value = (user.fullName ?? '').isNotEmpty ? user.fullName! : 'Demo';
      phone.value = '${user.countryCode ?? ''}${user.phoneNumber ?? ''}'.trim();
      profilePic.value = user.profilePic ?? '';
      // Keep rating static for now (no rating field in model); could be driven by backend later.
      rating.value = 5.0;
      user.fcmToken = await NotificationService.getToken();
      await FireStoreUtils.updateUser(user);
    }
  }
}



