import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Helper class for handling Firebase Auth errors with user-friendly messages
class FirebaseAuthErrorHandler {
  FirebaseAuthErrorHandler._();

  /// Get user-friendly error message from FirebaseAuthException
  static String getUserFriendlyMessage(FirebaseAuthException exception) {
    debugPrint('[FirebaseAuth] Error Code: ${exception.code}');
    debugPrint('[FirebaseAuth] Error Message: ${exception.message}');

    switch (exception.code) {
      // Phone Authentication Errors
      case 'invalid-phone-number':
        return 'invalid_phone_number'.tr.isNotEmpty
            ? 'invalid_phone_number'.tr
            : 'Invalid phone number. Please check and try again.';
      
      case 'missing-phone-number':
        return 'Phone number is required.';
      
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      
      case 'operation-not-allowed':
        return 'Phone authentication is not enabled. Please contact support.';
      
      case 'too-many-requests':
        return 'multiple_time_request'.tr.isNotEmpty
            ? 'multiple_time_request'.tr
            : 'Too many requests. Please wait a moment and try again.';
      
      case 'session-expired':
        return 'Verification session expired. Please request a new code.';
      
      case 'invalid-verification-code':
        return 'Invalid verification code. Please check and try again.';
      
      case 'invalid-verification-id':
        return 'Invalid verification ID. Please request a new code.';
      
      case 'missing-verification-code':
        return 'Verification code is required.';
      
      case 'missing-verification-id':
        return 'Verification ID is missing. Please request a new code.';
      
      case 'credential-already-in-use':
        return 'This phone number is already registered with another account.';
      
      case 'phone-number-already-exists':
        return 'This phone number is already in use.';
      
      // Network Errors
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      
      // General Errors
      case 'user-not-found':
        return 'No account found with this phone number.';
      
      case 'wrong-password':
        return 'Incorrect verification code.';
      
      case 'weak-password':
        return 'Password is too weak.';
      
      case 'email-already-in-use':
        return 'This email is already registered.';
      
      case 'invalid-email':
        return 'Invalid email address.';
      
      // App Check / ReCAPTCHA Errors
      case 'app-not-authorized':
        return 'App not authorized. Please contact support.';
      
      case 'captcha-check-failed':
        return 'Security check failed. Please try again.';
      
      case 'missing-or-invalid-nonce':
        return 'Security verification failed. Please try again.';
      
      // Default
      default:
        debugPrint('[FirebaseAuth] Unhandled error code: ${exception.code}');
        return exception.message ?? 'An error occurred. Please try again.';
    }
  }

  /// Check if error is retryable
  static bool isRetryable(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'network-request-failed':
      case 'too-many-requests':
      case 'quota-exceeded':
      case 'session-expired':
        return true;
      default:
        return false;
    }
  }

  /// Get retry delay in seconds based on error
  static int getRetryDelaySeconds(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'too-many-requests':
        return 60; // Wait 1 minute
      case 'quota-exceeded':
        return 300; // Wait 5 minutes
      case 'network-request-failed':
        return 5; // Wait 5 seconds
      default:
        return 10; // Default 10 seconds
    }
  }

  /// Log error with context (non-sensitive information only)
  static void logError({
    required FirebaseAuthException exception,
    String? context,
    String? phoneNumber, // Only last 4 digits for logging
  }) {
    final maskedPhone = phoneNumber != null && phoneNumber.length > 4
        ? '***${phoneNumber.substring(phoneNumber.length - 4)}'
        : '***';
    
    debugPrint('═══════════════════════════════════════');
    debugPrint('[FirebaseAuth Error] ${context ?? "Authentication"}');
    debugPrint('  Code: ${exception.code}');
    debugPrint('  Message: ${exception.message}');
    if (phoneNumber != null) {
      debugPrint('  Phone: $maskedPhone');
    }
    debugPrint('  Retryable: ${isRetryable(exception)}');
    debugPrint('═══════════════════════════════════════');
  }
}

