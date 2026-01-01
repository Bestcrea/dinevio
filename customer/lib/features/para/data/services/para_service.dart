import '../models/para_category_model.dart';
import '../models/para_product_model.dart';
import '../models/para_store_model.dart';

class ParaService {
  Future<List<ParaCategoryModel>> fetchCategories() async {
    return [
      ParaCategoryModel(
        id: 'promotions',
        name: 'Promotions',
        iconAsset: 'assets/para/promotions.png',
        active: true,
        createdAt: DateTime.now(),
      ),
      ParaCategoryModel(
        id: 'parapharmacy',
        name: 'Parapharmacy',
        iconAsset: 'assets/para/parapharmacy.png',
        active: true,
        createdAt: DateTime.now(),
      ),
      ParaCategoryModel(
        id: 'beauty',
        name: 'Beauty',
        iconAsset: 'assets/para/beauty.png',
        active: true,
        createdAt: DateTime.now(),
      ),
    ];
  }

  Future<List<ParaStoreModel>> fetchStores() async {
    final categories = await fetchCategories();
    final products = [
      ParaProductModel(
        id: 'p1',
        name: 'Face serum',
        imageAsset: 'assets/para/beauty.png',
        price: 129.0,
        originalPrice: 149.0,
        discountPercent: 15,
        active: true,
        createdAt: DateTime.now(),
      ),
      ParaProductModel(
        id: 'p2',
        name: 'SPF 50 Cream',
        imageAsset: 'assets/para/parapharmacy.png',
        price: 89.0,
        originalPrice: 99.0,
        discountPercent: 10,
        active: true,
        createdAt: DateTime.now(),
      ),
    ];
    return [
      ParaStoreModel(
        id: 'beauty_success',
        name: 'Beauty Success',
        logoAsset: 'assets/para/brands/beauty_success.png',
        bannerAsset: 'assets/para/banner_para.jpg',
        active: true,
        createdAt: DateTime.now(),
        ratingPercent: 98,
        reviewsCount: 120,
        deliveryMin: 15,
        deliveryMax: 25,
        freeDelivery: true,
        samePriceAsStore: true,
        isSponsored: false,
        categories: categories,
        products: products,
      ),
      ParaStoreModel(
        id: 'faces',
        name: 'FACES',
        logoAsset: 'assets/para/brands/faces.png',
        bannerAsset: 'assets/para/banner_para.jpg',
        active: true,
        createdAt: DateTime.now(),
        ratingPercent: 95,
        reviewsCount: 89,
        deliveryMin: 10,
        deliveryMax: 20,
        freeDelivery: false,
        samePriceAsStore: true,
        isSponsored: true,
        categories: categories,
        products: products,
      ),
      ParaStoreModel(
        id: 'beauty_market',
        name: 'Beauty Market',
        logoAsset: 'assets/para/brands/beauty_market.png',
        bannerAsset: 'assets/para/banner_para.jpg',
        active: true,
        createdAt: DateTime.now(),
        ratingPercent: 93,
        reviewsCount: 150,
        deliveryMin: 12,
        deliveryMax: 22,
        freeDelivery: true,
        samePriceAsStore: true,
        isSponsored: false,
        categories: categories,
        products: products,
      ),
      ParaStoreModel(
        id: 'flormar',
        name: 'Flormar',
        logoAsset: 'assets/para/brands/flormar.png',
        bannerAsset: 'assets/para/banner_para.jpg',
        active: true,
        createdAt: DateTime.now(),
        ratingPercent: 92,
        reviewsCount: 75,
        deliveryMin: 15,
        deliveryMax: 25,
        freeDelivery: true,
        samePriceAsStore: true,
        isSponsored: false,
        categories: categories,
        products: products,
      ),
      ParaStoreModel(
        id: 'mac',
        name: 'MAC',
        logoAsset: 'assets/para/brands/mac.png',
        bannerAsset: 'assets/para/banner_para.jpg',
        active: true,
        createdAt: DateTime.now(),
        ratingPercent: 94,
        reviewsCount: 200,
        deliveryMin: 18,
        deliveryMax: 28,
        freeDelivery: false,
        samePriceAsStore: true,
        isSponsored: false,
        categories: categories,
        products: products,
      ),
    ];
  }
}
