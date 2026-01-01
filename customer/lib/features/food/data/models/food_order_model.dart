import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for food order item
/// Path: food_orders/{orderId}/items/{itemId}
class FoodOrderItemModel {
  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double unitPriceMad;
  final int quantity;
  final double lineTotal;

  FoodOrderItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPriceMad,
    required this.quantity,
    required this.lineTotal,
  });

  factory FoodOrderItemModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodOrderItemModel(
      id: doc.id,
      productId: data['productId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      unitPriceMad: (data['unitPriceMad'] as num?)?.toDouble() ?? 0.0,
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      lineTotal: (data['lineTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'imageUrl': imageUrl,
      'unitPriceMad': unitPriceMad,
      'quantity': quantity,
      'lineTotal': lineTotal,
    };
  }
}

/// Model for food order
/// Path: food_orders/{orderId}
class FoodOrderModel {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String status; // "pending" | "confirmed" | "preparing" | "delivering" | "completed" | "cancelled"
  final String currency;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String paymentMethod; // "cash" | "card"
  final String deliveryAddressText;
  final DateTime createdAt;

  FoodOrderModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.status,
    required this.currency,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.paymentMethod,
    required this.deliveryAddressText,
    required this.createdAt,
  });

  factory FoodOrderModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodOrderModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      restaurantId: data['restaurantId'] as String? ?? '',
      restaurantName: data['restaurantName'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      currency: data['currency'] as String? ?? 'MAD',
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (data['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: data['paymentMethod'] as String? ?? 'cash',
      deliveryAddressText: data['deliveryAddressText'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'status': status,
      'currency': currency,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'paymentMethod': paymentMethod,
      'deliveryAddressText': deliveryAddressText,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

