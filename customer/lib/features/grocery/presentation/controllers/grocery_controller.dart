import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/repositories/grocery_repository.dart';
import '../../data/services/mock_grocery_service.dart';

class GroceryState {
  final bool loading;
  final List<CategoryEntity> categories;
  final List<StoreEntity> stores;
  final String? error;
  const GroceryState({
    this.loading = false,
    this.categories = const [],
    this.stores = const [],
    this.error,
  });

  GroceryState copyWith({
    bool? loading,
    List<CategoryEntity>? categories,
    List<StoreEntity>? stores,
    String? error,
  }) {
    return GroceryState(
      loading: loading ?? this.loading,
      categories: categories ?? this.categories,
      stores: stores ?? this.stores,
      error: error,
    );
  }
}

class GroceryController extends StateNotifier<GroceryState> {
  GroceryController(this._repo) : super(const GroceryState());
  final GroceryRepository _repo;

  Future<void> load() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final cats = await _repo.getCategories();
      final stores = await _repo.getStores();
      state = state.copyWith(loading: false, categories: cats, stores: stores);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final groceryRepositoryProvider =
    Provider<GroceryRepository>((ref) => MockGroceryRepository());

final groceryControllerProvider =
    StateNotifierProvider<GroceryController, GroceryState>((ref) {
  final repo = ref.watch(groceryRepositoryProvider);
  return GroceryController(repo)..load();
});
