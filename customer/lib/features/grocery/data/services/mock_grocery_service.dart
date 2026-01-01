import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/repositories/grocery_repository.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/promotion_model.dart';
import '../models/store_model.dart';

class MockGroceryRepository implements GroceryRepository {
  MockGroceryRepository();

  final _categories = [
    CategoryModel(
      id: 'cat_supermarket',
      name: 'Supermarket',
      iconAsset: 'assets/grocery/supermarket.png',
      active: true,
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: 'cat_bakery',
      name: 'Bakery',
      iconAsset: 'assets/grocery/bakery.png',
      active: true,
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: 'cat_sweets',
      name: 'Sweets',
      iconAsset: 'assets/grocery/sweets.png',
      active: true,
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: 'cat_ice_cream',
      name: 'Ice Cream',
      iconAsset: 'assets/grocery/ice_cream.png',
      active: true,
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: 'cat_tee_coffee',
      name: 'Tea & Coffee',
      iconAsset: 'assets/grocery/tee_coffee.png',
      active: true,
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: 'cat_dairy',
      name: 'Dairy',
      iconAsset: 'assets/grocery/dairy.png',
      active: true,
      createdAt: DateTime.now(),
    ),
  ];

  final _products = [
    ProductModel(
      id: 'p1',
      name: 'Strawberries 500g',
      image:
          'https://images.unsplash.com/photo-1439127989242-c3749a012eac?w=400',
      active: true,
      createdAt: DateTime.now(),
      price: 24.0,
      discountPercent: 10,
      badge: 'Promo',
    ),
    ProductModel(
      id: 'p2',
      name: 'Fresh Baguette',
      image:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
      active: true,
      createdAt: DateTime.now(),
      price: 6.0,
      badge: 'Fresh',
    ),
    ProductModel(
      id: 'p3',
      name: 'Ribeye Steak 400g',
      image:
          'https://images.unsplash.com/photo-1604908177248-29c9e95c8b40?w=400',
      active: true,
      createdAt: DateTime.now(),
      price: 85.0,
      discountPercent: 15,
      badge: 'Butcher',
    ),
  ];

  final _promos = [
    PromotionModel(
      id: 'promo1',
      name: 'Free Delivery',
      image:
          'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?w=400',
      active: true,
      createdAt: DateTime.now(),
      badge: 'Free',
    ),
  ];

  @override
  Future<List<CategoryEntity>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _categories;
  }

  @override
  Future<List<ProductEntity>> getProducts(String storeId,
      {int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _products;
  }

  @override
  Future<List<StoreEntity>> getStores({int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final stores = [
      StoreModel(
        id: 'store_bringo',
        name: 'Bringo',
        image:
            'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?w=1600',
        logoAsset: 'assets/supermarket/bringo.png',
        active: true,
        createdAt: DateTime.now(),
        rating: 4.8,
        deliveryMin: 10,
        deliveryMax: 20,
        isSponsored: true,
        isFreeDelivery: true,
        samePriceAsStore: true,
        categories: _categories,
        products: _products,
        promotions: _promos,
      ),
      StoreModel(
        id: 'store_carrefour_gourmet',
        name: 'Gourmet',
        image:
            'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=1600',
        logoAsset: 'assets/supermarket/carrefour_gourmet.png',
        active: true,
        createdAt: DateTime.now(),
        rating: 4.7,
        deliveryMin: 12,
        deliveryMax: 22,
        isSponsored: false,
        isFreeDelivery: true,
        samePriceAsStore: true,
        categories: _categories,
        products: _products,
        promotions: _promos,
      ),
      StoreModel(
        id: 'store_carrefour_market',
        name: 'Carrefour Market',
        image:
            'https://images.unsplash.com/photo-1464375117522-1311d6a5b81f?w=1600',
        logoAsset: 'assets/supermarket/carrefour_market.png',
        active: true,
        createdAt: DateTime.now(),
        rating: 4.6,
        deliveryMin: 15,
        deliveryMax: 25,
        isSponsored: true,
        isFreeDelivery: true,
        samePriceAsStore: true,
        categories: _categories,
        products: _products,
        promotions: _promos,
      ),
      StoreModel(
        id: 'store_carrefour',
        name: 'Carrefour',
        image:
            'https://images.unsplash.com/photo-1542838132-92c53300491e?w=1600',
        logoAsset: 'assets/supermarket/carrefour.png',
        active: true,
        createdAt: DateTime.now(),
        rating: 4.5,
        deliveryMin: 14,
        deliveryMax: 24,
        isSponsored: false,
        isFreeDelivery: true,
        samePriceAsStore: true,
        categories: _categories,
        products: _products,
        promotions: _promos,
      ),
      StoreModel(
        id: 'store_marjan_market',
        name: 'Marjan Market',
        image:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1600',
        logoAsset: 'assets/supermarket/marjan_market.png',
        active: true,
        createdAt: DateTime.now(),
        rating: 4.4,
        deliveryMin: 16,
        deliveryMax: 26,
        isSponsored: false,
        isFreeDelivery: false,
        samePriceAsStore: true,
        categories: _categories,
        products: _products,
        promotions: _promos,
      ),
      StoreModel(
        id: 'store_marjan',
        name: 'Marjan',
        image:
            'https://images.unsplash.com/photo-1464375117522-1311d6a5b81f?w=1600',
        logoAsset: 'assets/supermarket/marjan.png',
        active: true,
        createdAt: DateTime.now(),
        rating: 4.5,
        deliveryMin: 15,
        deliveryMax: 25,
        isSponsored: false,
        isFreeDelivery: false,
        samePriceAsStore: false,
        categories: _categories,
        products: _products,
        promotions: _promos,
      ),
      StoreModel(
        id: 'store_paul',
        name: 'Paul',
        image:
            'https://images.unsplash.com/photo-1542838132-92c53300491e?w=1600',
        logoAsset: 'assets/supermarket/paul.png',
        active: true,
        createdAt: DateTime.now(),
        rating: 4.7,
        deliveryMin: 8,
        deliveryMax: 18,
        isSponsored: true,
        isFreeDelivery: true,
        samePriceAsStore: true,
        categories: _categories,
        products: _products,
        promotions: _promos,
      ),
      StoreModel(
        id: 'store_starbucks',
        name: 'Starbucks',
        image:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1600',
        logoAsset: 'assets/supermarket/starbucks.png',
        active: true,
        createdAt: DateTime.now(),
        rating: 4.6,
        deliveryMin: 10,
        deliveryMax: 20,
        isSponsored: false,
        isFreeDelivery: true,
        samePriceAsStore: true,
        categories: _categories,
        products: _products,
        promotions: _promos,
      ),
    ];
    return stores;
  }
}
