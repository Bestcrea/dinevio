class CategoryEntity {
  final String id;
  final String name;
  final String iconAsset;
  final bool active;
  final DateTime createdAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconAsset,
    required this.active,
    required this.createdAt,
  });
}
