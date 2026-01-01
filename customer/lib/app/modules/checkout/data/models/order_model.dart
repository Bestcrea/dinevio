import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for Firestore order document
class OrderModel {
  final String orderId;
  final String? userId; // Optional for guest orders
  final String? shopId; // For marketplace orders (Para/Grocery/Food)
  final String? shopName;
  final List<OrderItem> items;
  final int subtotalMAD; // In cents
  final int deliveryFeeMAD; // In cents
  final int taxMAD; // In cents
  final int totalMAD; // In cents
  final String paymentMethod; // 'cash' | 'apple_pay' | 'google_pay' | 'card'
  final String paymentStatus; // 'pending' | 'paid' | 'failed'
  final String? paymentIntentId; // Stripe PaymentIntent ID if paid via Stripe
  final String? deliveryAddressText; // Placeholder for now
  final String orderStatus; // 'pending' | 'confirmed' | 'preparing' | 'delivering' | 'completed' | 'cancelled'
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.orderId,
    this.userId,
    this.shopId,
    this.shopName,
    required this.items,
    required this.subtotalMAD,
    required this.deliveryFeeMAD,
    required this.taxMAD,
    required this.totalMAD,
    required this.paymentMethod,
    required this.paymentStatus,
    this.paymentIntentId,
    this.deliveryAddressText,
    this.orderStatus = 'pending',
    required this.createdAt,
    this.updatedAt,
  });

  /// Create OrderModel from Firestore document
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      orderId: doc.id,
      userId: data['userId'] as String?,
      shopId: data['shopId'] as String?,
      shopName: data['shopName'] as String?,
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      subtotalMAD: (data['subtotalMAD'] as num?)?.toInt() ?? 0,
      deliveryFeeMAD: (data['deliveryFeeMAD'] as num?)?.toInt() ?? 0,
      taxMAD: (data['taxMAD'] as num?)?.toInt() ?? 0,
      totalMAD: (data['totalMAD'] as num?)?.toInt() ?? 0,
      paymentMethod: data['paymentMethod'] as String? ?? 'cash',
      paymentStatus: data['paymentStatus'] as String? ?? 'pending',
      paymentIntentId: data['paymentIntentId'] as String?,
      deliveryAddressText: data['deliveryAddressText'] as String?,
      orderStatus: data['orderStatus'] as String? ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert OrderModel to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'shopId': shopId,
      'shopName': shopName,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotalMAD': subtotalMAD,
      'deliveryFeeMAD': deliveryFeeMAD,
      'taxMAD': taxMAD,
      'totalMAD': totalMAD,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'paymentIntentId': paymentIntentId,
      'deliveryAddressText': deliveryAddressText,
      'orderStatus': orderStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }
}

/// Model for a single order item
class OrderItem {
  final String productId;
  final String title;
  final String? imageUrl;
  final int unitPriceMAD; // In cents
  final int quantity;
  final int lineTotalMAD; // In cents

  OrderItem({
    required this.productId,
    required this.title,
    this.imageUrl,
    required this.unitPriceMAD,
    required this.quantity,
    required this.lineTotalMAD,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] as String,
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String?,
      unitPriceMAD: (map['unitPriceMAD'] as num?)?.toInt() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      lineTotalMAD: (map['lineTotalMAD'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'imageUrl': imageUrl,
      'unitPriceMAD': unitPriceMAD,
      'quantity': quantity,
      'lineTotalMAD': lineTotalMAD,
    };
  }
}

