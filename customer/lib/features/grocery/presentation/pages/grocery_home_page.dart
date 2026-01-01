import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/grocery_controller.dart';
import '../widgets/grocery_widgets.dart';

class GroceryHomePage extends StatelessWidget {
  const GroceryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: const _GroceryHomeScaffold(),
    );
  }
}

class _GroceryHomeScaffold extends ConsumerWidget {
  const _GroceryHomeScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(groceryControllerProvider);
    final hasSamePrice = state.stores.any((s) => s.samePriceAsStore);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: () => ref.read(groceryControllerProvider.notifier).load(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: GroceryHeader()),
            if (state.loading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            else if (state.error != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text("Error: ${state.error}",
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(groceryControllerProvider.notifier).load(),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              SliverToBoxAdapter(
                child: CategoryScroller(categories: state.categories),
              ),
              const SliverToBoxAdapter(child: FilterChipsRow()),
              if (hasSamePrice)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      children: const [
                        Icon(Icons.home_outlined,
                            size: 18, color: Colors.black87),
                        SizedBox(width: 8),
                        Text(
                          "Same prices as in store",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.info_outline,
                            size: 16, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
              if (state.stores.isNotEmpty)
                SliverToBoxAdapter(
                  child: TopBrandsGrid(stores: state.stores),
                ),
              SliverList.builder(
                itemCount: state.stores.length,
                itemBuilder: (context, index) {
                  final store = state.stores[index];
                  return StoreCard(store: store);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
