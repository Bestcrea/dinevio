// ignore_for_file: unnecessary_overrides, invalid_return_type_for_catch_error

import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:customer/app/models/user_model.dart';
import 'package:customer/app/modules/home/views/home_view.dart';
import 'package:customer/app/modules/signup/views/signup_view.dart';
import 'package:customer/app/modules/verify_otp/views/verify_otp_view.dart';
import 'package:customer/auth/utils/firebase_auth_error_handler.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  TextEditingController countryCodeController =
      TextEditingController(text: '+212');
  TextEditingController phoneNumberController = TextEditingController();
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> sendCode() async {
    try {
      final phoneNumber = phoneNumberController.value.text;

      // Mode test : accepter les numéros de test
      if (phoneNumber == "000000000" ||
          phoneNumber == "0000000000" ||
          phoneNumber.startsWith("000")) {
        ShowToastDialog.showLoader("Please wait".tr);
        // Simuler un délai pour le mode test
        await Future.delayed(const Duration(seconds: 1));
        ShowToastDialog.closeLoader();
        // Mode test : utiliser un verificationId factice
        Get.to(const VerifyOtpView(), arguments: {
          "countryCode": countryCodeController.value.text,
          "phoneNumber": phoneNumberController.value.text,
          "verificationId": "TEST_MODE_VERIFICATION_ID",
          "isTestMode": true,
        });
        return;
      }

      final fullPhoneNumber = countryCodeController.value.text + phoneNumberController.value.text;
      debugPrint('[LoginController] Requesting verification code');
      debugPrint('[LoginController] Phone: ${_maskPhone(fullPhoneNumber)}');
      
      ShowToastDialog.showLoader("Please wait".tr);
      await FirebaseAuth.instance
          .verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          debugPrint('[LoginController] Auto-verification completed');
          // Auto-verification handled in verificationCompleted
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('[LoginController] Verification failed');
          ShowToastDialog.closeLoader();
          
          // Use error handler for user-friendly messages
          final errorMessage = FirebaseAuthErrorHandler.getUserFriendlyMessage(e);
          FirebaseAuthErrorHandler.logError(
            exception: e,
            context: 'Phone verification',
            phoneNumber: fullPhoneNumber,
          );
          
          ShowToastDialog.showToast(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint('[LoginController] Verification code sent');
          debugPrint('[LoginController] Verification ID received');
          debugPrint('[LoginController] Resend token: ${resendToken != null ? "Available" : "None"}');
          
          ShowToastDialog.closeLoader();
          Get.to(const VerifyOtpView(), arguments: {
            "countryCode": countryCodeController.value.text,
            "phoneNumber": phoneNumberController.value.text,
            "verificationId": verificationId,
            "resendToken": resendToken,
            "isTestMode": false,
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('[LoginController] Auto-retrieval timeout');
          debugPrint('[LoginController] Verification ID: ${verificationId.substring(0, 10)}...');
        },
      )
          .catchError((error) {
        debugPrint('[LoginController] Catch error: $error');
        ShowToastDialog.closeLoader();
        
        if (error is FirebaseAuthException) {
          final errorMessage = FirebaseAuthErrorHandler.getUserFriendlyMessage(error);
          ShowToastDialog.showToast(errorMessage);
        } else {
          ShowToastDialog.showToast("multiple_time_request".tr);
        }
      });
    } catch (e) {
      debugPrint('[LoginController] Unexpected error: $e');
      log("Error in Login ${e.toString()}");
      ShowToastDialog.closeLoader();
      
      if (e is FirebaseAuthException) {
        final errorMessage = FirebaseAuthErrorHandler.getUserFriendlyMessage(e);
        ShowToastDialog.showToast(errorMessage);
      } else {
        ShowToastDialog.showToast("something went wrong!".tr);
      }
    }
  }

  /// Mask phone number for logging (shows only last 4 digits)
  String _maskPhone(String phone) {
    if (phone.length <= 4) return '***';
    return '***${phone.substring(phone.length - 4)}';
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn().catchError((error) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("something_went_wrong".tr);
        return null;
      });

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
    // Trigger the authentication flow
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // webAuthenticationOptions: WebAuthenticationOptions(clientId: clientID, redirectUri: Uri.parse(redirectURL)),
        nonce: nonce,
      ).catchError((error) {
        debugPrint("catchError--->$error");
        ShowToastDialog.closeLoader();
        return null;
      });

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> loginWithGoogle() async {
    ShowToastDialog.showLoader("Please wait".tr);
    await signInWithGoogle().then((value) {
      ShowToastDialog.closeLoader();
      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          UserModel userModel = UserModel();
          userModel.id = value.user!.uid;
          userModel.email = value.user!.email;
          userModel.fullName = value.user!.displayName;
          userModel.profilePic = value.user!.photoURL;
          userModel.loginType = Constant.googleLoginType;

          ShowToastDialog.closeLoader();
          Get.to(const SignupView(), arguments: {
            "userModel": userModel,
          });
        } else {
          FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
            ShowToastDialog.closeLoader();
            if (userExit == true) {
              UserModel? userModel =
                  await FireStoreUtils.getUserProfile(value.user!.uid);
              if (userModel != null) {
                if (userModel.isActive == true) {
                  Get.offAll(const HomeView());
                } else {
                  await FirebaseAuth.instance.signOut();
                  ShowToastDialog.showToast("user_disable_admin_contact".tr);
                }
              }
            } else {
              UserModel userModel = UserModel();
              userModel.id = value.user!.uid;
              userModel.email = value.user!.email;
              userModel.fullName = value.user!.displayName;
              userModel.profilePic = value.user!.photoURL;
              userModel.loginType = Constant.googleLoginType;

              Get.to(const SignupView(), arguments: {
                "userModel": userModel,
              });
            }
          });
        }
      }
    });
  }

  Future<void> loginWithApple() async {
    ShowToastDialog.showLoader("Please wait".tr);
    await signInWithApple().then((value) {
      ShowToastDialog.closeLoader();
      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          UserModel userModel = UserModel();
          userModel.id = value.user!.uid;
          userModel.email = value.user!.email;
          userModel.profilePic = value.user!.photoURL;
          userModel.loginType = Constant.appleLoginType;

          ShowToastDialog.closeLoader();
          Get.to(const SignupView(), arguments: {
            "userModel": userModel,
          });
        } else {
          FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
            ShowToastDialog.closeLoader();

            if (userExit == true) {
              UserModel? userModel =
                  await FireStoreUtils.getUserProfile(value.user!.uid);
              if (userModel != null) {
                if (userModel.isActive == true) {
                  Get.offAll(const HomeView());
                } else {
                  await FirebaseAuth.instance.signOut();
                  ShowToastDialog.showToast("user_disable_admin_contact".tr);
                }
              }
            } else {
              UserModel userModel = UserModel();
              userModel.id = value.user!.uid;
              userModel.email = value.user!.email;
              userModel.profilePic = value.user!.photoURL;
              userModel.loginType = Constant.googleLoginType;

              Get.to(const SignupView(), arguments: {
                "userModel": userModel,
              });
            }
          });
        }
      }
    }).onError((error, stackTrace) {
      log("===> $error");
    });
  }
}
