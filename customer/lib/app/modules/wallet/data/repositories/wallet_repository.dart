import 'package:firebase_auth/firebase_auth.dart';

/// Repository for wallet operations (Firestore-ready)
class WalletRepository {
  /// Get selected payment method for current user
  Future<String?> getSelectedPaymentMethod() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      // TODO: Fetch from Firestore: users/{uid}/wallet/selectedMethod
      // For now, return null (will use local default)
      return null;
    } catch (e) {
      // Silent fail - use local default
      return null;
    }
  }

  /// Save selected payment method to Firestore
  Future<void> saveSelectedPaymentMethod(String methodType) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return; // Guest user - skip Firestore

      // TODO: Save to Firestore: users/{uid}/wallet/selectedMethod = methodType
      // Example:
      // await Firestore.instance
      //   .collection('users')
      //   .doc(user.uid)
      //   .collection('wallet')
      //   .doc('settings')
      //   .set({'selectedMethod': methodType}, SetOptions(merge: true));
      
      // For now, just return (local storage only)
    } catch (e) {
      // Silent fail - method will still be saved locally
    }
  }

  /// Get saved payment methods list (for future Stripe integration)
  Future<List<Map<String, dynamic>>> getSavedPaymentMethods() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      // TODO: Fetch from Firestore: users/{uid}/wallet/methods
      // For now, return empty list
      return [];
    } catch (e) {
      return [];
    }
  }
}

