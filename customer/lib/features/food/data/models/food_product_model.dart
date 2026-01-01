import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore model for Food Product (Menu Item)
/// Collection: food_restaurants/{restaurantId}/products/{productId}
class FoodProductModel {
  final String id;
  final String restaurantId;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final double priceMad; // Currency in MAD only
  final double? discountPercent;
  final String? badge; // "Promo", "New", etc.
  final int stock;
  final bool isActive;
  final DateTime createdAt;

  FoodProductModel({
    required this.id,
    required this.restaurantId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.priceMad,
    this.discountPercent,
    this.badge,
    required this.stock,
    required this.isActive,
    required this.createdAt,
  });

  factory FoodProductModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodProductModel(
      id: doc.id,
      restaurantId: data['restaurantId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      category: data['category'] as String? ?? '',
      priceMad: (data['priceMad'] as num?)?.toDouble() ?? 0.0,
      discountPercent: (data['discountPercent'] as num?)?.toDouble(),
      badge: data['badge'] as String?,
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'priceMad': priceMad,
      'discountPercent': discountPercent,
      'badge': badge,
      'stock': stock,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

