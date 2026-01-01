import '../../domain/entities/store_entity.dart';
import 'category_model.dart';
import 'product_model.dart';
import 'promotion_model.dart';

class StoreModel extends StoreEntity {
  StoreModel({
    required super.id,
    required super.name,
    required super.image,
    required super.active,
    required super.createdAt,
    required super.logoAsset,
    required super.rating,
    required super.deliveryMin,
    required super.deliveryMax,
    required super.isSponsored,
    required super.isFreeDelivery,
    required super.samePriceAsStore,
    required List<CategoryModel> categories,
    required List<ProductModel> products,
    required List<PromotionModel> promotions,
  }) : super(
          categories: categories,
          products: products,
          promotions: promotions,
        );
}

