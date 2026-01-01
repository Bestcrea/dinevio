import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/modules/checkout/data/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Repository for order operations in Firestore
class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new order in Firestore
  /// Returns the order ID
  Future<String> createOrder(OrderModel order) async {
    try {
      final orderRef = _firestore.collection('orders').doc(order.orderId);
      await orderRef.set(order.toFirestore());
      return order.orderId;
    } catch (e) {
      throw Exception('Failed to create order: ${e.toString()}');
    }
  }

  /// Get order by ID
  Future<OrderModel?> getOrder(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (!doc.exists) return null;
      return OrderModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get order: ${e.toString()}');
    }
  }

  /// Update order payment status
  Future<void> updateOrderPaymentStatus({
    required String orderId,
    required String paymentStatus,
    String? paymentIntentId,
  }) async {
    try {
      final updates = <String, dynamic>{
        'paymentStatus': paymentStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (paymentIntentId != null) {
        updates['paymentIntentId'] = paymentIntentId;
      }
      await _firestore.collection('orders').doc(orderId).update(updates);
    } catch (e) {
      throw Exception('Failed to update order payment status: ${e.toString()}');
    }
  }

  /// Get user's orders (if authenticated)
  Stream<List<OrderModel>> getUserOrders({int limit = 20}) {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Return empty stream for guest users
        return Stream.value([]);
      }

      return _firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      return Stream.value([]);
    }
  }
}

