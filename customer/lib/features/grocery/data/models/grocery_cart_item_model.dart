import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore model for Grocery Cart Item
/// Collection: users/{uid}/grocery_cart/current/items/{itemId}
class GroceryCartItemModel {
  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double unitPriceMad;
  final int quantity;
  final double lineTotal; // unitPriceMad * quantity
  final DateTime createdAt;

  GroceryCartItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPriceMad,
    required this.quantity,
    required this.lineTotal,
    required this.createdAt,
  });

  factory GroceryCartItemModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroceryCartItemModel(
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

  GroceryCartItemModel copyWith({
    String? id,
    String? productId,
    String? title,
    String? imageUrl,
    double? unitPriceMad,
    int? quantity,
    double? lineTotal,
    DateTime? createdAt,
  }) {
    return GroceryCartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      unitPriceMad: unitPriceMad ?? this.unitPriceMad,
      quantity: quantity ?? this.quantity,
      lineTotal: lineTotal ?? (unitPriceMad ?? this.unitPriceMad) * (quantity ?? this.quantity),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

