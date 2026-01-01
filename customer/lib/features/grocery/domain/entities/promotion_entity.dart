class PromotionEntity {
  final String id;
  final String name;
  final String image;
  final bool active;
  final DateTime createdAt;
  final String? badge;

  const PromotionEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.active,
    required this.createdAt,
    this.badge,
  });
}












