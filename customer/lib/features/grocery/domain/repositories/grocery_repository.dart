import '../entities/category_entity.dart';
import '../entities/product_entity.dart';
import '../entities/store_entity.dart';

abstract class GroceryRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<StoreEntity>> getStores({int page = 1});
  Future<List<ProductEntity>> getProducts(String storeId, {int page = 1});
}
