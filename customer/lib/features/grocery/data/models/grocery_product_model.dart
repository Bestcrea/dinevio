import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore model for Grocery Product
/// Collection: grocery_shops/{shopId}/products/{productId}
class GroceryProductModel {
  final String id;
  final String shopId;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final double priceMad; // Currency in MAD only
  final double? discountPercent;
  final String? badge; // "Promo", "Fresh", etc.
  final int stock;
  final bool isActive;
  final DateTime createdAt;

  GroceryProductModel({
    required this.id,
    required this.shopId,
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

  factory GroceryProductModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroceryProductModel(
      id: doc.id,
      shopId: data['shopId'] as String? ?? '',
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
      'shopId': shopId,
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

  GroceryProductModel copyWith({
    String? id,
    String? shopId,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    double? priceMad,
    double? discountPercent,
    String? badge,
    int? stock,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return GroceryProductModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      priceMad: priceMad ?? this.priceMad,
      discountPercent: discountPercent ?? this.discountPercent,
      badge: badge ?? this.badge,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

