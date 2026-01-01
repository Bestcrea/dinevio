import 'category_entity.dart';
import 'product_entity.dart';
import 'promotion_entity.dart';

class StoreEntity {
  final String id;
  final String name;
  final String image;
  final bool active;
  final DateTime createdAt;
  final String logoAsset;
  final double rating;
  final int deliveryMin;
  final int deliveryMax;
  final bool isSponsored;
  final bool isFreeDelivery;
  final bool samePriceAsStore;
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final List<PromotionEntity> promotions;

  const StoreEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.active,
    required this.createdAt,
    required this.logoAsset,
    required this.rating,
    required this.deliveryMin,
    required this.deliveryMax,
    required this.isSponsored,
    required this.isFreeDelivery,
    required this.samePriceAsStore,
    required this.categories,
    required this.products,
    required this.promotions,
  });
}
