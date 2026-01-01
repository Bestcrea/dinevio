import 'package:customer/features/para/data/models/para_shop_model.dart';
import 'package:customer/features/para/data/repositories/para_repository.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';

/// GetX Controller for ParaMarketplacePage
class ParaMarketplaceController extends GetxController {
  final ParaRepository _repository = ParaRepository();

  // State
  final RxBool isLoading = false.obs;
  final RxList<ParaShopModel> shops = <ParaShopModel>[].obs;
  final RxList<ParaShopModel> filteredShops = <ParaShopModel>[].obs;
  final RxString selectedCategory = ''.obs; // Empty = all
  final RxString searchQuery = ''.obs;
  final RxSet<String> favorites = <String>{}.obs;

  // Categories
  final List<Map<String, String>> categories = [
    {'id': 'Promotion', 'name': 'Promotions', 'icon': 'assets/para/promotions.png'},
    {'id': 'Parapharmacy', 'name': 'Parapharmacy', 'icon': 'assets/para/parapharmacy.png'},
    {'id': 'Beauty', 'name': 'Beauty', 'icon': 'assets/para/beauty.png'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadShops();
    loadFavorites();
  }

  /// Load shops from Firestore
  Future<void> loadShops() async {
    try {
      isLoading.value = true;
      final allShops = await _repository.getShops();
      shops.value = allShops;
      applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load shops: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Apply category and search filters
  void applyFilters() {
    var filtered = shops.toList();

    // Category filter
    if (selectedCategory.value.isNotEmpty) {
      filtered = filtered.where((shop) => shop.category == selectedCategory.value).toList();
    }

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((shop) => shop.name.toLowerCase().contains(query)).toList();
    }

    filteredShops.value = filtered;
  }

  /// Select category
  void selectCategory(String? categoryId) {
    selectedCategory.value = categoryId ?? '';
    applyFilters();
  }

  /// Search shops
  Future<void> search(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      applyFilters();
    } else {
      try {
        isLoading.value = true;
        final results = await _repository.searchShops(query);
        // Apply category filter on search results
        if (selectedCategory.value.isNotEmpty) {
          filteredShops.value = results.where((shop) => shop.category == selectedCategory.value).toList();
        } else {
          filteredShops.value = results;
        }
      } catch (e) {
        Get.snackbar('Error', 'Search failed: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  /// Toggle favorite
  void toggleFavorite(String shopId) {
    if (favorites.contains(shopId)) {
      favorites.remove(shopId);
    } else {
      favorites.add(shopId);
    }
    saveFavorites();
  }

  /// Check if shop is favorite
  bool isFavorite(String shopId) {
    return favorites.contains(shopId);
  }

  /// Load favorites from local storage (Firestore user document)
  Future<void> loadFavorites() async {
    try {
      final uid = FireStoreUtils.getCurrentUid();
      if (uid == null) return;
      final userDoc = await FireStoreUtils.fireStore.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
      final favs = data?['paraFavorites'] as List<dynamic>?;
      if (favs != null) {
        favorites.clear();
        favorites.addAll(favs.map((e) => e.toString()));
      }
      }
    } catch (e) {
      // Silent fail
    }
  }

  /// Save favorites to Firestore
  Future<void> saveFavorites() async {
    try {
      final uid = FireStoreUtils.getCurrentUid();
      if (uid == null) return;
      await FireStoreUtils.fireStore.collection('Users').doc(uid).update({
        'paraFavorites': favorites.toList(),
      });
    } catch (e) {
      // Silent fail
    }
  }

  /// Sort shops
  void sortShops(String sortBy) {
    switch (sortBy) {
      case 'rating':
        filteredShops.sort((a, b) => b.ratingPercent.compareTo(a.ratingPercent));
        break;
      case 'delivery':
        filteredShops.sort((a, b) => a.deliveryTimeMin.compareTo(b.deliveryTimeMin));
        break;
      case 'name':
        filteredShops.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        break;
    }
    filteredShops.refresh();
  }
}

