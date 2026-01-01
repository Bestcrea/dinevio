import '../../domain/entities/promotion_entity.dart';

class PromotionModel extends PromotionEntity {
  PromotionModel({
    required super.id,
    required super.name,
    required super.image,
    required super.active,
    required super.createdAt,
    super.badge,
  });
}












