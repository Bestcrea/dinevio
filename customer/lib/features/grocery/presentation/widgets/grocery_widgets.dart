import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/entities/product_entity.dart';

class GroceryHeader extends StatelessWidget {
  const GroceryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.home, color: Colors.black87),
                      SizedBox(width: 8),
                      Text("Rabat, Morocco",
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.black54),
                SizedBox(width: 10),
                Text(
                  "Recherche dans Dinevio",
                  style: TextStyle(color: Colors.black45, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryScroller extends StatelessWidget {
  const CategoryScroller({super.key, required this.categories});
  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final cat = categories[i];
          return Column(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    cat.iconAsset,
                    width: 46,
                    height: 46,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.category_outlined,
                        size: 46,
                        color: Colors.grey.shade400,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          );
        },
      ),
    );
  }
}

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = [
      ("Category", Icons.expand_more),
      ("Takeaway", Icons.directions_walk),
      ("Sort by", Icons.expand_more),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: filters
            .map(
              (f) => ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (f.$1 == "Takeaway") const Text("🚶 "),
                    Text(f.$1),
                    if (f.$2 != Icons.directions_walk) ...[
                      const SizedBox(width: 4),
                      Icon(f.$2, size: 18),
                    ]
                  ],
                ),
                selected: false,
                onSelected: (_) {},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.grey.shade100,
              ),
            )
            .toList(),
      ),
    );
  }
}

class TopBrandsGrid extends StatelessWidget {
  const TopBrandsGrid({super.key, required this.stores});
  final List<StoreEntity> stores;

  @override
  Widget build(BuildContext context) {
    final top = stores.take(5).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Top brands", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: top.length,
            itemBuilder: (context, i) => _BrandCard(store: top[i]),
          ),
        ],
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  const _BrandCard({required this.store});
  final StoreEntity store;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              store.logoAsset,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.store_outlined,
                  size: 60,
                  color: Colors.grey.shade400,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _Badge(label: "Free"),
              SizedBox(width: 6),
              _Badge(label: "Schedule"),
            ],
          )
        ],
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  const StoreCard({super.key, required this.store});
  final StoreEntity store;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: CachedNetworkImage(
                  imageUrl: store.image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(
                      store.logoAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.store_outlined,
                          size: 40,
                          color: Colors.grey.shade400,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text("${store.rating} · ${store.deliveryMin}-${store.deliveryMax} min",
                            style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                ),
              ),
              if (store.samePriceAsStore)
                Positioned(
                  top: 12,
                  left: 12,
                  child: _ChipLabel(
                    icon: Icons.home_outlined,
                    label: "Same prices as in store",
                  ),
                ),
              if (store.isSponsored)
                Positioned(
                  top: store.samePriceAsStore ? 48 : 12,
                  left: 12,
                  child: _Badge(label: "Sponsored"),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (store.isFreeDelivery) const _Badge(label: "Free"),
                if (store.samePriceAsStore) const _Badge(label: "Same prices as in store"),
              ],
            ),
          ),
          if (store.products.isNotEmpty)
            ProductCarousel(products: store.products.take(6).toList()),
        ],
      ),
    );
  }
}

class ProductCarousel extends StatelessWidget {
  const ProductCarousel({super.key, required this.products});
  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);
    
    // Calculate responsive item height: clamp(screenHeight * 0.28, 190.0, 230.0)
    // Adjust for text scaling if > 1.2
    var baseItemHeight = (screenHeight * 0.28).clamp(190.0, 230.0);
    if (textScaleFactor > 1.2) {
      final scaleAdjustment = ((textScaleFactor - 1.2) * 20).clamp(10.0, 30.0);
      baseItemHeight += scaleAdjustment;
    }
    final itemHeight = baseItemHeight.clamp(190.0, 260.0);
    
    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final p = products[i];
          return Container(
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image section - fixed height
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      child: CachedNetworkImage(
                        imageUrl: p.image,
                        height: 110,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (p.discountPercent != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC244),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text("-${p.discountPercent!.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                              textScaleFactor: 1.0), // Prevent badge text scaling
                        ),
                      ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Material(
                        color: Colors.black,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {},
                          child: const SizedBox(
                            width: 34,
                            height: 34,
                            child: Icon(Icons.add, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Bottom info area - flexible to prevent overflow
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Product name - maxLines 2 with ellipsis
                        Flexible(
                          child: Text(
                            p.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Price row - wrapped in FittedBox to prevent overflow
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${p.price.toStringAsFixed(2)} MAD",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              if (p.discountPercent != null) ...[
                                const SizedBox(width: 6),
                                Text(
                                  "${(p.price / (1 - (p.discountPercent! / 100))).toStringAsFixed(2)} MAD",
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  const _ChipLabel({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}
