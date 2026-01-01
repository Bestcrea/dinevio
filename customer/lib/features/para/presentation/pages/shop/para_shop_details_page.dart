import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/features/para/data/models/para_product_model.dart';
import 'package:customer/features/para/data/models/para_shop_model.dart';
import 'package:customer/features/para/data/repositories/para_repository.dart';
import 'package:customer/features/para/state/para_cart_controller.dart';
import 'package:customer/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

/// Shop details page with products
class ParaShopDetailsPage extends StatefulWidget {
  const ParaShopDetailsPage({super.key});

  @override
  State<ParaShopDetailsPage> createState() => _ParaShopDetailsPageState();
}

class _ParaShopDetailsPageState extends State<ParaShopDetailsPage> {
  final ParaRepository _repository = ParaRepository();
  final ParaCartController _cartController = Get.find<ParaCartController>();
  ParaShopModel? shop;
  List<ParaProductModel> products = [];
  bool isLoading = true;
  String? error;

  static const Color _primaryPurple = Color(0xFF7E57C2);

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    final shopId = args?['shopId'] as String?;
    if (shopId != null) {
      _loadShopAndProducts(shopId);
    } else {
      setState(() {
        error = 'Shop ID required';
        isLoading = false;
      });
    }
  }

  Future<void> _loadShopAndProducts(String shopId) async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final shopData = await _repository.getShop(shopId);
      final productsData = await _repository.getProducts(shopId, activeOnly: true);
      setState(() {
        shop = shopData;
        products = productsData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load shop: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _addToCart(ParaProductModel product) async {
    if (shop == null) return;

    final success = await _cartController.addToCart(shop!, product);
    if (!success) {
      // Show conflict dialog
      final shouldClear = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Cart Conflict'),
          content: const Text(
            'Your cart contains items from another store. Clear cart and continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear & Continue'),
            ),
          ],
        ),
      );

      if (shouldClear == true) {
        await _cartController.handleCartConflict(shop!);
        final retrySuccess = await _cartController.addToCart(shop!, product);
        if (retrySuccess) {
          Get.snackbar('Success', 'Added to cart');
        }
      }
    } else {
      Get.snackbar('Success', 'Added to cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shop Details')),
        body: _buildLoadingState(),
      );
    }

    if (error != null || shop == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shop Details')),
        body: Center(child: Text(error ?? 'Shop not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Shop Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: shop!.coverImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[200]),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.store, size: 48),
                ),
              ),
            ),
            title: Text(shop!.name),
          ),
          // Products List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (products.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No products available',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...products.map((product) => _buildProductCard(product)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ParaProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
              ),
              errorWidget: (context, url, error) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (product.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyFormatter.formatMoneyMAD(product.priceMad),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _primaryPurple,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 200,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        ...List.generate(3, (index) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 120,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            )),
      ],
    );
  }
}

