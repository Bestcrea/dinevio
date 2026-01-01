class ProductEntity {
  final String id;
  final String name;
  final String image;
  final bool active;
  final DateTime createdAt;
  final double price;
  final double? discountPercent;
  final String? badge;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.active,
    required this.createdAt,
    required this.price,
    this.discountPercent,
    this.badge,
  });
}
