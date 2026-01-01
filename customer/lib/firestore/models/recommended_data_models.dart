// Recommended Data Models for Firestore
// These models provide a solid foundation for the Dinevio app

import 'package:cloud_firestore/cloud_firestore.dart';

/// User Model - Enhanced with defensive null checks
class RecommendedUserModel {
  final String id;
  final String fullName;
  final String? email;
  final String phoneNumber;
  final String countryCode;
  final String? profilePic;
  final String? fcmToken;
  final String loginType; // 'phone', 'google', 'apple'
  final double walletAmount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata; // For additional fields

  RecommendedUserModel({
    required this.id,
    required this.fullName,
    this.email,
    required this.phoneNumber,
    required this.countryCode,
    this.profilePic,
    this.fcmToken,
    required this.loginType,
    this.walletAmount = 0.0,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory RecommendedUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return RecommendedUserModel(
      id: doc.id,
      fullName: data['fullName'] as String? ?? 'Unknown',
      email: data['email'] as String?,
      phoneNumber: data['phoneNumber'] as String? ?? '',
      countryCode: data['countryCode'] as String? ?? '+212',
      profilePic: data['profilePic'] as String?,
      fcmToken: data['fcmToken'] as String?,
      loginType: data['loginType'] as String? ?? 'phone',
      walletAmount: (data['walletAmount'] ?? 0).toDouble(),
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'fullName': fullName,
      if (email != null) 'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      if (profilePic != null) 'profilePic': profilePic,
      if (fcmToken != null) 'fcmToken': fcmToken,
      'loginType': loginType,
      'walletAmount': walletAmount,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Order Model - For food delivery orders
class RecommendedOrderModel {
  final String id;
  final String customerId;
  final String restaurantId;
  final String? driverId;
  final OrderStatus status;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;
  final String paymentType; // 'cash', 'card', 'wallet'
  final bool paymentStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? scheduledTime;
  final DeliveryAddress? deliveryAddress;
  final String? notes;

  RecommendedOrderModel({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    this.driverId,
    required this.status,
    required this.items,
    required this.subtotal,
    this.deliveryFee = 0.0,
    this.tax = 0.0,
    this.discount = 0.0,
    required this.total,
    required this.paymentType,
    this.paymentStatus = false,
    required this.createdAt,
    this.updatedAt,
    this.scheduledTime,
    this.deliveryAddress,
    this.notes,
  });

  factory RecommendedOrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return RecommendedOrderModel(
      id: doc.id,
      customerId: data['customerId'] as String? ?? '',
      restaurantId: data['restaurantId'] as String? ?? '',
      driverId: data['driverId'] as String?,
      status: OrderStatus.fromString(data['status'] as String? ?? 'pending'),
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ?? [],
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      deliveryFee: (data['deliveryFee'] ?? 0).toDouble(),
      tax: (data['tax'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      total: (data['total'] ?? 0).toDouble(),
      paymentType: data['paymentType'] as String? ?? 'cash',
      paymentStatus: data['paymentStatus'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      scheduledTime: (data['scheduledTime'] as Timestamp?)?.toDate(),
      deliveryAddress: data['deliveryAddress'] != null
          ? DeliveryAddress.fromMap(data['deliveryAddress'] as Map<String, dynamic>)
          : null,
      notes: data['notes'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'customerId': customerId,
      'restaurantId': restaurantId,
      if (driverId != null) 'driverId': driverId,
      'status': status.toString(),
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'discount': discount,
      'total': total,
      'paymentType': paymentType,
      'paymentStatus': paymentStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      if (scheduledTime != null) 'scheduledTime': Timestamp.fromDate(scheduledTime!),
      if (deliveryAddress != null) 'deliveryAddress': deliveryAddress!.toMap(),
      if (notes != null) 'notes': notes,
    };
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;
  final Map<String, dynamic>? options;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
    this.options,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      menuItemId: map['menuItemId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      quantity: (map['quantity'] ?? 1) as int,
      price: (map['price'] ?? 0).toDouble(),
      options: map['options'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'quantity': quantity,
      'price': price,
      if (options != null) 'options': options,
    };
  }
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  assigned,
  pickedUp,
  delivered,
  cancelled,
  refunded;

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

class DeliveryAddress {
  final String address;
  final double latitude;
  final double longitude;
  final String? apartment;
  final String? instructions;

  DeliveryAddress({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.apartment,
    this.instructions,
  });

  factory DeliveryAddress.fromMap(Map<String, dynamic> map) {
    return DeliveryAddress(
      address: map['address'] as String? ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      apartment: map['apartment'] as String?,
      instructions: map['instructions'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (apartment != null) 'apartment': apartment,
      if (instructions != null) 'instructions': instructions,
    };
  }
}

/// Restaurant Model - Enhanced
class RecommendedRestaurantModel {
  final String id;
  final String name;
  final String coverImage;
  final String brandLogo;
  final double rating;
  final int reviewCount;
  final double deliveryBaseFee;
  final double deliveryPerKm;
  final int etaMin;
  final int etaMax;
  final bool isFeatured;
  final bool isTop10;
  final bool isNearby;
  final bool isActive;
  final GeoPoint? location;
  final List<String> categories;
  final DateTime createdAt;

  RecommendedRestaurantModel({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.brandLogo,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.deliveryBaseFee,
    required this.deliveryPerKm,
    required this.etaMin,
    required this.etaMax,
    this.isFeatured = false,
    this.isTop10 = false,
    this.isNearby = false,
    this.isActive = true,
    this.location,
    this.categories = const [],
    required this.createdAt,
  });

  factory RecommendedRestaurantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return RecommendedRestaurantModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      coverImage: data['coverImage'] as String? ?? '',
      brandLogo: data['brandLogo'] as String? ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: (data['reviewCount'] ?? 0) as int,
      deliveryBaseFee: (data['deliveryBaseFee'] ?? 0).toDouble(),
      deliveryPerKm: (data['deliveryPerKm'] ?? 0).toDouble(),
      etaMin: (data['etaMin'] ?? 0) as int,
      etaMax: (data['etaMax'] ?? 0) as int,
      isFeatured: data['isFeatured'] as bool? ?? false,
      isTop10: data['isTop10'] as bool? ?? false,
      isNearby: data['isNearby'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      location: data['location'] as GeoPoint?,
      categories: (data['categories'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ?? [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'coverImage': coverImage,
      'brandLogo': brandLogo,
      'rating': rating,
      'reviewCount': reviewCount,
      'deliveryBaseFee': deliveryBaseFee,
      'deliveryPerKm': deliveryPerKm,
      'etaMin': etaMin,
      'etaMax': etaMax,
      'isFeatured': isFeatured,
      'isTop10': isTop10,
      'isNearby': isNearby,
      'isActive': isActive,
      if (location != null) 'location': location,
      'categories': categories,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

/// Driver Model
class RecommendedDriverModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String countryCode;
  final String? email;
  final String? profilePic;
  final String? fcmToken;
  final bool isOnline;
  final bool isActive;
  final GeoPoint? currentLocation;
  final String? vehicleTypeId;
  final double rating;
  final int totalRides;
  final DateTime createdAt;
  final DateTime? updatedAt;

  RecommendedDriverModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.countryCode,
    this.email,
    this.profilePic,
    this.fcmToken,
    this.isOnline = false,
    this.isActive = true,
    this.currentLocation,
    this.vehicleTypeId,
    this.rating = 0.0,
    this.totalRides = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory RecommendedDriverModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return RecommendedDriverModel(
      id: doc.id,
      fullName: data['fullName'] as String? ?? 'Unknown Driver',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      countryCode: data['countryCode'] as String? ?? '+212',
      email: data['email'] as String?,
      profilePic: data['profilePic'] as String?,
      fcmToken: data['fcmToken'] as String?,
      isOnline: data['isOnline'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      currentLocation: data['currentLocation'] as GeoPoint?,
      vehicleTypeId: data['vehicleTypeId'] as String?,
      rating: (data['rating'] ?? 0).toDouble(),
      totalRides: (data['totalRides'] ?? 0) as int,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      if (email != null) 'email': email,
      if (profilePic != null) 'profilePic': profilePic,
      if (fcmToken != null) 'fcmToken': fcmToken,
      'isOnline': isOnline,
      'isActive': isActive,
      if (currentLocation != null) 'currentLocation': currentLocation,
      if (vehicleTypeId != null) 'vehicleTypeId': vehicleTypeId,
      'rating': rating,
      'totalRides': totalRides,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }
}

/// Parcel Model
class RecommendedParcelModel {
  final String id;
  final String customerId;
  final String? driverId;
  final ParcelType type;
  final double weight; // in kg
  final ParcelDimensions? dimensions;
  final String pickupAddress;
  final GeoPoint pickupLocation;
  final String deliveryAddress;
  final GeoPoint deliveryLocation;
  final ParcelStatus status;
  final double price;
  final String paymentType;
  final bool paymentStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? scheduledTime;
  final String? notes;
  final String? parcelImage;

  RecommendedParcelModel({
    required this.id,
    required this.customerId,
    this.driverId,
    required this.type,
    required this.weight,
    this.dimensions,
    required this.pickupAddress,
    required this.pickupLocation,
    required this.deliveryAddress,
    required this.deliveryLocation,
    required this.status,
    required this.price,
    required this.paymentType,
    this.paymentStatus = false,
    required this.createdAt,
    this.updatedAt,
    this.scheduledTime,
    this.notes,
    this.parcelImage,
  });

  factory RecommendedParcelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return RecommendedParcelModel(
      id: doc.id,
      customerId: data['customerId'] as String? ?? '',
      driverId: data['driverId'] as String?,
      type: ParcelType.fromString(data['type'] as String? ?? 'document'),
      weight: (data['weight'] ?? 0).toDouble(),
      dimensions: data['dimensions'] != null
          ? ParcelDimensions.fromMap(data['dimensions'] as Map<String, dynamic>)
          : null,
      pickupAddress: data['pickupAddress'] as String? ?? '',
      pickupLocation: data['pickupLocation'] as GeoPoint? ?? 
                      GeoPoint(0, 0),
      deliveryAddress: data['deliveryAddress'] as String? ?? '',
      deliveryLocation: data['deliveryLocation'] as GeoPoint? ?? 
                        GeoPoint(0, 0),
      status: ParcelStatus.fromString(data['status'] as String? ?? 'pending'),
      price: (data['price'] ?? 0).toDouble(),
      paymentType: data['paymentType'] as String? ?? 'cash',
      paymentStatus: data['paymentStatus'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      scheduledTime: (data['scheduledTime'] as Timestamp?)?.toDate(),
      notes: data['notes'] as String?,
      parcelImage: data['parcelImage'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'customerId': customerId,
      if (driverId != null) 'driverId': driverId,
      'type': type.toString().split('.').last,
      'weight': weight,
      if (dimensions != null) 'dimensions': dimensions!.toMap(),
      'pickupAddress': pickupAddress,
      'pickupLocation': pickupLocation,
      'deliveryAddress': deliveryAddress,
      'deliveryLocation': deliveryLocation,
      'status': status.toString().split('.').last,
      'price': price,
      'paymentType': paymentType,
      'paymentStatus': paymentStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      if (scheduledTime != null) 'scheduledTime': Timestamp.fromDate(scheduledTime!),
      if (notes != null) 'notes': notes,
      if (parcelImage != null) 'parcelImage': parcelImage,
    };
  }
}

enum ParcelType {
  document,
  box,
  fragile,
  other;

  static ParcelType fromString(String value) {
    return ParcelType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => ParcelType.other,
    );
  }
}

enum ParcelStatus {
  pending,
  assigned,
  pickedUp,
  inTransit,
  delivered,
  cancelled;

  static ParcelStatus fromString(String value) {
    return ParcelStatus.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => ParcelStatus.pending,
    );
  }
}

class ParcelDimensions {
  final double length; // in cm
  final double width; // in cm
  final double height; // in cm

  ParcelDimensions({
    required this.length,
    required this.width,
    required this.height,
  });

  factory ParcelDimensions.fromMap(Map<String, dynamic> map) {
    return ParcelDimensions(
      length: (map['length'] ?? 0).toDouble(),
      width: (map['width'] ?? 0).toDouble(),
      height: (map['height'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'width': width,
      'height': height,
    };
  }
}

