import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for food cart summary
/// Path: users/{uid}/food_cart/current
class FoodCartModel {
  final String restaurantId;
  final String restaurantName;
  final String currency;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime updatedAt;

  FoodCartModel({
    required this.restaurantId,
    required this.restaurantName,
    required this.currency,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.updatedAt,
  });

  factory FoodCartModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodCartModel(
      restaurantId: data['restaurantId'] as String? ?? '',
      restaurantName: data['restaurantName'] as String? ?? '',
      currency: data['currency'] as String? ?? 'MAD',
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (data['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'currency': currency,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

