import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for order item
/// Path: para_orders/{orderId}/items/{itemId}
class ParaOrderItemModel {
  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double unitPriceMad;
  final int quantity;
  final double lineTotal;

  ParaOrderItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPriceMad,
    required this.quantity,
    required this.lineTotal,
  });

  factory ParaOrderItemModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ParaOrderItemModel(
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

/// Model for order
/// Path: para_orders/{orderId}
class ParaOrderModel {
  final String id;
  final String userId;
  final String shopId;
  final String shopName;
  final String status; // "pending" | "confirmed" | "preparing" | "delivering" | "completed" | "cancelled"
  final String currency;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String paymentMethod; // "cash" | "card"
  final String deliveryAddressText;
  final DateTime createdAt;

  ParaOrderModel({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.shopName,
    required this.status,
    required this.currency,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.paymentMethod,
    required this.deliveryAddressText,
    required this.createdAt,
  });

  factory ParaOrderModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ParaOrderModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      shopId: data['shopId'] as String? ?? '',
      shopName: data['shopName'] as String? ?? '',
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
      'shopId': shopId,
      'shopName': shopName,
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

  ParaOrderModel copyWith({
    String? id,
    String? userId,
    String? shopId,
    String? shopName,
    String? status,
    String? currency,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? paymentMethod,
    String? deliveryAddressText,
    DateTime? createdAt,
  }) {
    return ParaOrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddressText: deliveryAddressText ?? this.deliveryAddressText,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

