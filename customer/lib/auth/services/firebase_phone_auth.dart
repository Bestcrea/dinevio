import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:customer/auth/utils/firebase_auth_error_handler.dart';

class PhoneAuthRequestResult {
  const PhoneAuthRequestResult({
    required this.verificationId,
    required this.resendingToken,
    required this.autoVerified,
  });

  final String? verificationId;
  final int? resendingToken;
  final bool autoVerified;
}

class FirebasePhoneAuthService {
  FirebasePhoneAuthService._();
  static final FirebasePhoneAuthService instance = FirebasePhoneAuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Request phone verification code with defensive error handling
  Future<PhoneAuthRequestResult> requestCode({
    required String phone,
    int? forceResendToken,
  }) async {
    debugPrint('[PhoneAuth] Requesting code for phone: ${_maskPhone(phone)}');
    debugPrint('[PhoneAuth] Force resend token: ${forceResendToken != null ? "Present" : "None"}');
    
    final completer = Completer<PhoneAuthRequestResult>();
    var completed = false;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        forceResendingToken: forceResendToken,
        verificationCompleted: (credential) async {
          if (completed) {
            debugPrint('[PhoneAuth] Verification completed but already handled');
            return;
          }
          completed = true;
          debugPrint('[PhoneAuth] Auto-verification successful');
          try {
            await _auth.signInWithCredential(credential);
            debugPrint('[PhoneAuth] Auto sign-in successful');
            completer.complete(
              const PhoneAuthRequestResult(
                verificationId: null,
                resendingToken: null,
                autoVerified: true,
              ),
            );
          } catch (e) {
            debugPrint('[PhoneAuth] Auto sign-in failed: $e');
            completer.completeError(e);
          }
        },
        verificationFailed: (e) {
          if (completed) {
            debugPrint('[PhoneAuth] Verification failed but already handled');
            return;
          }
          completed = true;
          FirebaseAuthErrorHandler.logError(
            exception: e,
            context: 'Phone verification failed',
            phoneNumber: phone,
          );
          completer.completeError(e);
        },
        codeSent: (verificationId, resendToken) {
          if (completed) {
            debugPrint('[PhoneAuth] Code sent but already handled');
            return;
          }
          completed = true;
          debugPrint('[PhoneAuth] Verification code sent successfully');
          debugPrint('[PhoneAuth] Verification ID: ${verificationId.substring(0, 10)}...');
          debugPrint('[PhoneAuth] Resend token: ${resendToken != null ? "Present" : "None"}');
          completer.complete(
            PhoneAuthRequestResult(
              verificationId: verificationId,
              resendingToken: resendToken,
              autoVerified: false,
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {
          if (completed) {
            debugPrint('[PhoneAuth] Auto-retrieval timeout but already handled');
            return;
          }
          completed = true;
          debugPrint('[PhoneAuth] Auto-retrieval timeout');
          debugPrint('[PhoneAuth] Verification ID: ${verificationId.substring(0, 10)}...');
          completer.complete(
            PhoneAuthRequestResult(
              verificationId: verificationId,
              resendingToken: forceResendToken,
              autoVerified: false,
            ),
          );
        },
      );
    } catch (e) {
      if (!completed) {
        completed = true;
        debugPrint('[PhoneAuth] Unexpected error: $e');
        completer.completeError(e);
      }
    }

    return completer.future;
  }

  /// Verify SMS code with defensive error handling
  Future<UserCredential> verifyCode({
    required String verificationId,
    required String smsCode,
  }) async {
    debugPrint('[PhoneAuth] Verifying code');
    debugPrint('[PhoneAuth] Verification ID: ${verificationId.substring(0, 10)}...');
    debugPrint('[PhoneAuth] SMS Code length: ${smsCode.length}');
    
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      
      debugPrint('[PhoneAuth] Credential created, signing in...');
      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint('[PhoneAuth] Sign-in successful');
      debugPrint('[PhoneAuth] User ID: ${userCredential.user?.uid}');
      debugPrint('[PhoneAuth] Is new user: ${userCredential.additionalUserInfo?.isNewUser}');
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      FirebaseAuthErrorHandler.logError(
        exception: e,
        context: 'Code verification failed',
      );
      rethrow;
    } catch (e) {
      debugPrint('[PhoneAuth] Unexpected error during verification: $e');
      rethrow;
    }
  }

  /// Mask phone number for logging (shows only last 4 digits)
  String _maskPhone(String phone) {
    if (phone.length <= 4) return '***';
    return '***${phone.substring(phone.length - 4)}';
  }
}
