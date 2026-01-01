import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String coverImage;
  final String brandLogo;
  final double rating;
  final double deliveryBaseFee;
  final double deliveryPerKm;
  final int etaMin;
  final int etaMax;
  final bool isFeatured;
  final bool isTop10;
  final bool isNearby;
  final GeoPoint? location;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.brandLogo,
    required this.rating,
    required this.deliveryBaseFee,
    required this.deliveryPerKm,
    required this.etaMin,
    required this.etaMax,
    required this.isFeatured,
    required this.isTop10,
    required this.isNearby,
    this.location,
  });

  factory RestaurantModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return RestaurantModel(
      id: doc.id,
      name: data['name'] ?? '',
      coverImage: data['coverImage'] ?? '',
      brandLogo: data['brandLogo'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      deliveryBaseFee: (data['deliveryBaseFee'] ?? 0).toDouble(),
      deliveryPerKm: (data['deliveryPerKm'] ?? 0).toDouble(),
      etaMin: (data['etaMin'] ?? 0).toInt(),
      etaMax: (data['etaMax'] ?? 0).toInt(),
      isFeatured: data['isFeatured'] ?? false,
      isTop10: data['isTop10'] ?? false,
      isNearby: data['isNearby'] ?? false,
      location: data['location'],
    );
  }
}

class MenuItemModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final double price;
  final double? strikePrice;
  final String category;
  final String? badge;
  final List<OptionGroup> optionsGroups;

  MenuItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    this.strikePrice,
    required this.category,
    this.badge,
    required this.optionsGroups,
  });

  factory MenuItemModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MenuItemModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      strikePrice: data['strikePrice'] != null ? (data['strikePrice']).toDouble() : null,
      category: data['category'] ?? '',
      badge: data['badge'],
      optionsGroups: (data['optionsGroups'] as List<dynamic>? ?? [])
          .map((e) => OptionGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OptionGroup {
  final String title;
  final String type; // single | multi
  final bool required;
  final int? max;
  final List<OptionItem> options;

  OptionGroup({
    required this.title,
    required this.type,
    required this.required,
    this.max,
    required this.options,
  });

  factory OptionGroup.fromJson(Map<String, dynamic> json) {
    return OptionGroup(
      title: json['title'] ?? '',
      type: json['type'] ?? 'single',
      required: json['required'] ?? false,
      max: json['max'],
      options: (json['options'] as List<dynamic>? ?? []).map((e) => OptionItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class OptionItem {
  final String label;
  final double price;

  OptionItem({required this.label, required this.price});

  factory OptionItem.fromJson(Map<String, dynamic> json) {
    return OptionItem(
      label: json['label'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

