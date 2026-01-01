// ignore_for_file: unnecessary_overrides

import 'dart:async';

import 'package:get/get.dart';
import 'package:customer/app/modules/home/views/home_view.dart';
import 'package:customer/app/modules/intro_screen/views/intro_screen_view.dart';
import 'package:customer/app/modules/login/views/login_view.dart';
import 'package:customer/app/modules/permission/views/permission_view.dart';
import 'package:customer/app/routes/app_pages.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/preferences.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> redirectScreen() async {
    try {
      final isOnboardingDone =
          await Preferences.getBoolean(Preferences.isFinishOnBoardingKey);
      if (isOnboardingDone == false) {
        Get.offAll(const IntroScreenView());
        return;
      }

      bool isLogin = false;
      try {
        isLogin = await FireStoreUtils.isLogin();
      } catch (e) {
        // Firebase not initialized or error, default to login
        print("Firebase check failed: $e");
        isLogin = false;
      }

      if (isLogin == true) {
        bool permissionGiven = false;
        try {
          permissionGiven = await Constant.isPermissionApplied();
        } catch (e) {
          print("Permission check failed: $e");
        }
        if (permissionGiven) {
          Get.offAll(const HomeView());
        } else {
          Get.offAll(const PermissionView());
        }
      } else {
        Get.offAllNamed(Routes.ONBOARDING_LOGIN);
      }
    } catch (e) {
      // Fallback: always go to onboarding login if anything fails
      print("Splash redirect error: $e");
      Get.offAllNamed(Routes.ONBOARDING_LOGIN);
    }
  }
}
