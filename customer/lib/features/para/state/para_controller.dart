import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/para_repository_impl.dart';
import '../data/services/para_service.dart';
import '../data/models/para_category_model.dart';
import '../data/models/para_store_model.dart';
import '../repositories/para_repository.dart';

class ParaState {
  final bool loading;
  final List<ParaCategoryModel> categories;
  final List<ParaStoreModel> stores;
  final String? error;
  const ParaState({
    this.loading = false,
    this.categories = const [],
    this.stores = const [],
    this.error,
  });

  ParaState copyWith({
    bool? loading,
    List<ParaCategoryModel>? categories,
    List<ParaStoreModel>? stores,
    String? error,
  }) {
    return ParaState(
      loading: loading ?? this.loading,
      categories: categories ?? this.categories,
      stores: stores ?? this.stores,
      error: error,
    );
  }
}

class ParaController extends StateNotifier<ParaState> {
  ParaController(this._repo) : super(const ParaState());
  final ParaRepository _repo;

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

final paraRepositoryProvider = Provider<ParaRepository>((ref) {
  return ParaRepositoryImpl(ParaService());
});

final paraControllerProvider =
    StateNotifierProvider<ParaController, ParaState>((ref) {
  final repo = ref.watch(paraRepositoryProvider);
  return ParaController(repo)..load();
});

