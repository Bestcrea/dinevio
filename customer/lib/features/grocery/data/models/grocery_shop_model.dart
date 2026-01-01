import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore model for Grocery Shop
/// Collection: grocery_shops/{shopId}
class GroceryShopModel {
  final String id;
  final String ownerUid;
  final String name;
  final String coverImageUrl;
  final String? logoUrl;
  final String category; // "Supermarket" | "Bakery" | "Sweets" | "Ice Cream" | "Tea & Coffee" | "Dairy"
  final int ratingPercent;
  final int ratingCount;
  final int deliveryTimeMin;
  final int deliveryTimeMax;
  final bool isOpen;
  final String opensAtText; // e.g. "Opens tomorrow at 09:00"
  final bool isFreeDelivery;
  final bool samePriceAsStore;
  final bool isSponsored;
  final DateTime createdAt;

  GroceryShopModel({
    required this.id,
    required this.ownerUid,
    required this.name,
    required this.coverImageUrl,
    this.logoUrl,
    required this.category,
    required this.ratingPercent,
    required this.ratingCount,
    required this.deliveryTimeMin,
    required this.deliveryTimeMax,
    required this.isOpen,
    required this.opensAtText,
    this.isFreeDelivery = false,
    this.samePriceAsStore = false,
    this.isSponsored = false,
    required this.createdAt,
  });

  factory GroceryShopModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroceryShopModel(
      id: doc.id,
      ownerUid: data['ownerUid'] as String? ?? '',
      name: data['name'] as String? ?? '',
      coverImageUrl: data['coverImageUrl'] as String? ?? '',
      logoUrl: data['logoUrl'] as String?,
      category: data['category'] as String? ?? 'Supermarket',
      ratingPercent: (data['ratingPercent'] as num?)?.toInt() ?? 0,
      ratingCount: (data['ratingCount'] as num?)?.toInt() ?? 0,
      deliveryTimeMin: (data['deliveryTimeMin'] as num?)?.toInt() ?? 20,
      deliveryTimeMax: (data['deliveryTimeMax'] as num?)?.toInt() ?? 30,
      isOpen: data['isOpen'] as bool? ?? true,
      opensAtText: data['opensAtText'] as String? ?? '',
      isFreeDelivery: data['isFreeDelivery'] as bool? ?? false,
      samePriceAsStore: data['samePriceAsStore'] as bool? ?? false,
      isSponsored: data['isSponsored'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerUid': ownerUid,
      'name': name,
      'coverImageUrl': coverImageUrl,
      'logoUrl': logoUrl,
      'category': category,
      'ratingPercent': ratingPercent,
      'ratingCount': ratingCount,
      'deliveryTimeMin': deliveryTimeMin,
      'deliveryTimeMax': deliveryTimeMax,
      'isOpen': isOpen,
      'opensAtText': opensAtText,
      'isFreeDelivery': isFreeDelivery,
      'samePriceAsStore': samePriceAsStore,
      'isSponsored': isSponsored,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  GroceryShopModel copyWith({
    String? id,
    String? ownerUid,
    String? name,
    String? coverImageUrl,
    String? logoUrl,
    String? category,
    int? ratingPercent,
    int? ratingCount,
    int? deliveryTimeMin,
    int? deliveryTimeMax,
    bool? isOpen,
    String? opensAtText,
    bool? isFreeDelivery,
    bool? samePriceAsStore,
    bool? isSponsored,
    DateTime? createdAt,
  }) {
    return GroceryShopModel(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      name: name ?? this.name,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      category: category ?? this.category,
      ratingPercent: ratingPercent ?? this.ratingPercent,
      ratingCount: ratingCount ?? this.ratingCount,
      deliveryTimeMin: deliveryTimeMin ?? this.deliveryTimeMin,
      deliveryTimeMax: deliveryTimeMax ?? this.deliveryTimeMax,
      isOpen: isOpen ?? this.isOpen,
      opensAtText: opensAtText ?? this.opensAtText,
      isFreeDelivery: isFreeDelivery ?? this.isFreeDelivery,
      samePriceAsStore: samePriceAsStore ?? this.samePriceAsStore,
      isSponsored: isSponsored ?? this.isSponsored,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

