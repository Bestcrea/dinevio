import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for cart item
/// Path: users/{uid}/para_cart/current/items/{itemId}
class ParaCartItemModel {
  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double unitPriceMad;
  final int quantity;
  final double lineTotal;
  final DateTime createdAt;

  ParaCartItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPriceMad,
    required this.quantity,
    required this.lineTotal,
    required this.createdAt,
  });

  factory ParaCartItemModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ParaCartItemModel(
      id: doc.id,
      productId: data['productId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      unitPriceMad: (data['unitPriceMad'] as num?)?.toDouble() ?? 0.0,
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
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

  ParaCartItemModel copyWith({
    String? id,
    String? productId,
    String? title,
    String? imageUrl,
    double? unitPriceMad,
    int? quantity,
    double? lineTotal,
    DateTime? createdAt,
  }) {
    return ParaCartItemModel(
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

/// Model for cart summary
/// Path: users/{uid}/para_cart/current
class ParaCartModel {
  final String shopId;
  final String shopName;
  final String currency;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime updatedAt;

  ParaCartModel({
    required this.shopId,
    required this.shopName,
    required this.currency,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.updatedAt,
  });

  factory ParaCartModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ParaCartModel(
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

