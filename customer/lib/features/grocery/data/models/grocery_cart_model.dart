import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for grocery cart summary
/// Path: users/{uid}/grocery_cart/current
class GroceryCartModel {
  final String shopId;
  final String shopName;
  final String currency;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime updatedAt;

  GroceryCartModel({
    required this.shopId,
    required this.shopName,
    required this.currency,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.updatedAt,
  });

  factory GroceryCartModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroceryCartModel(
      shopId: data['shopId'] as String? ?? '',
      shopName: data['shopName'] as String? ?? '',
      currency: data['currency'] as String? ?? 'MAD',
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (data['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'shopName': shopName,
      'currency': currency,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

