import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.image,
    required super.active,
    required super.createdAt,
    required super.price,
    super.discountPercent,
    super.badge,
  });
}
