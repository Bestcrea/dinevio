import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore model for Food Cart Item
/// Collection: users/{uid}/food_cart/current/items/{itemId}
class FoodCartItemModel {
  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double unitPriceMad;
  final int quantity;
  final double lineTotal;
  final DateTime createdAt;

  FoodCartItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPriceMad,
    required this.quantity,
    required this.lineTotal,
    required this.createdAt,
  });

  factory FoodCartItemModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodCartItemModel(
      id: doc.id,
      productId: data['productId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      unitPriceMad: (data['unitPriceMad'] as num?)?.toDouble() ?? 0.0,
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      lineTotal: (data['lineTotal'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
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
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

