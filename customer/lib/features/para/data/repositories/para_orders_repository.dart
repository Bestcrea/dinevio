import 'package:customer/features/para/data/models/para_order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for orders operations
class ParaOrdersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getOrdersPath() => 'para_orders';
  String _getOrderItemsPath(String orderId) => '$_getOrdersPath()/$orderId/items';

  /// Create order from cart (transactional)
  Future<String> createOrder({
    required String userId,
    required String shopId,
    required String shopName,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String paymentMethod,
    required String deliveryAddressText,
    required List<ParaOrderItemModel> items,
  }) async {
    try {
      final batch = _firestore.batch();

      // Create order document
      final orderRef = _firestore.collection(_getOrdersPath()).doc();
      final order = ParaOrderModel(
        id: orderRef.id,
        userId: userId,
        shopId: shopId,
        shopName: shopName,
        status: 'pending',
        currency: 'MAD',
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        paymentMethod: paymentMethod,
        deliveryAddressText: deliveryAddressText,
        createdAt: DateTime.now(),
      );
      batch.set(orderRef, order.toJson());

      // Create order items
      for (var item in items) {
        final itemRef = orderRef.collection('items').doc();
        batch.set(itemRef, item.toJson());
      }

      await batch.commit();
      return orderRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  /// Get user orders
  Future<List<ParaOrderModel>> getUserOrders(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_getOrdersPath())
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => ParaOrderModel.fromDoc(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  /// Get order by ID
  Future<ParaOrderModel?> getOrder(String orderId) async {
    try {
      final doc = await _firestore.collection(_getOrdersPath()).doc(orderId).get();
      if (!doc.exists) return null;
      return ParaOrderModel.fromDoc(doc);
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  /// Get order items
  Future<List<ParaOrderItemModel>> getOrderItems(String orderId) async {
    try {
      final snapshot = await _firestore.collection(_getOrderItemsPath(orderId)).get();
      return snapshot.docs.map((doc) => ParaOrderItemModel.fromDoc(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get order items: $e');
    }
  }

  /// Update order status (for admin/server use)
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection(_getOrdersPath()).doc(orderId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}

