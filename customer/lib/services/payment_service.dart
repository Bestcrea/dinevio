import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// PaymentService handles Stripe PaymentSheet integration with Apple Pay and Google Pay
/// Uses Firebase Cloud Functions backend to securely create PaymentIntents
class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Initialize Stripe with publishable key and merchant identifier
  /// Should be called once in main.dart during app initialization
  static Future<void> initializeStripe({
    required String publishableKey,
    String merchantIdentifier = 'merchant.com.dinevio.app',
    String merchantDisplayName = 'Dinevio',
  }) async {
    Stripe.publishableKey = publishableKey;
    Stripe.merchantIdentifier = merchantIdentifier;
    await Stripe.instance.applySettings();
  }

  /// Create PaymentIntent via Firebase Cloud Function
  /// Returns clientSecret for PaymentSheet initialization
  Future<String> createPaymentIntent({
    required int amount, // Amount in cents (e.g., 10000 = 100.00 MAD)
    String currency = 'mad',
    Map<String, String>? metadata, // Optional: orderId, userId, etc.
  }) async {
    try {
      // Try HTTPS callable first (preferred)
      try {
        final callable = _functions.httpsCallable('createPaymentIntent');
        final result = await callable.call({
          'amount': amount,
          'currency': currency,
          'metadata': metadata ?? {},
        });

        final data = result.data as Map<String, dynamic>;
        final clientSecret = data['clientSecret'] as String;

        if (clientSecret.isEmpty) {
          throw Exception('Failed to get client secret from server');
        }

        return clientSecret;
      } catch (callableError) {
        // Fallback to HTTP request if callable fails
        // This handles the case where the function uses onRequest instead of callable
        debugPrint('Callable failed, trying HTTP request: $callableError');
        
        // For now, rethrow the callable error
        // If you need HTTP fallback, implement it here using http package
        rethrow;
      }
    } catch (e) {
      throw Exception('Failed to create payment intent: ${e.toString()}');
    }
  }

  /// Initialize PaymentSheet with Apple Pay and Google Pay enabled
  /// This will automatically show Apple Pay / Google Pay if:
  /// 1. Enabled in Stripe Dashboard
  /// 2. Platform supports it (iOS for Apple Pay, Android for Google Pay)
  /// 3. User has payment methods configured
  Future<void> initPaymentSheet({
    required String clientSecret,
    String? customerId,
    String? customerEphemeralKeySecret,
  }) async {
    try {
      // Configure Google Pay (Android)
      final googlePay = PaymentSheetGooglePay(
        merchantCountryCode: 'MA', // Morocco
        currencyCode: 'MAD', // Moroccan Dirham
        testEnv: true, // Set to false for production
      );

      // Configure Apple Pay (iOS)
      final applePay = PaymentSheetApplePay(
        merchantCountryCode: 'MA', // Morocco
      );

      // Initialize PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Dinevio',
          applePay: applePay,
          googlePay: googlePay,
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
        ),
      );
    } catch (e) {
      throw Exception('Failed to initialize payment sheet: ${e.toString()}');
    }
  }

  /// Present PaymentSheet to user
  /// Returns true if payment succeeded, false if cancelled
  Future<bool> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true; // Payment succeeded
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        // User cancelled payment
        return false;
      } else {
        // Payment failed
        throw Exception('Payment failed: ${e.error.message}');
      }
    } catch (e) {
      throw Exception('Failed to present payment sheet: ${e.toString()}');
    }
  }

  /// Complete payment flow: create intent, init sheet, present sheet
  /// Returns true if payment succeeded, false if cancelled
  Future<bool> processPayment({
    required int amount, // Amount in cents
    String currency = 'mad',
    Map<String, String>? metadata,
  }) async {
    try {
      // Step 1: Create PaymentIntent
      final clientSecret = await createPaymentIntent(
        amount: amount,
        currency: currency,
        metadata: metadata,
      );

      // Step 2: Initialize PaymentSheet
      await initPaymentSheet(clientSecret: clientSecret);

      // Step 3: Present PaymentSheet
      final success = await presentPaymentSheet();

      return success;
    } catch (e) {
      throw Exception('Payment processing failed: ${e.toString()}');
    }
  }
}

