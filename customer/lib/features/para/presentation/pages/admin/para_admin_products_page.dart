import 'package:customer/features/para/data/models/para_product_model.dart';
import 'package:customer/features/para/data/repositories/para_repository.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Admin page to manage products for a shop
class ParaAdminProductsPage extends StatefulWidget {
  const ParaAdminProductsPage({super.key});

  @override
  State<ParaAdminProductsPage> createState() => _ParaAdminProductsPageState();
}

class _ParaAdminProductsPageState extends State<ParaAdminProductsPage> {
  final ParaRepository _repository = ParaRepository();
  List<ParaProductModel> _products = [];
  bool _isLoading = true;
  String? _error;
  String? _shopId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    _shopId = args?['shopId'] as String?;
    if (_shopId == null) {
      setState(() {
        _error = 'Shop ID required';
        _isLoading = false;
      });
      return;
    }
    _checkAccess();
    _loadProducts();
  }

  Future<void> _checkAccess() async {
    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) {
      Get.snackbar('Error', 'Not logged in');
      Get.back();
      return;
    }
    final shop = await _repository.getShop(_shopId!);
    if (shop == null || shop.ownerUid != uid) {
      Get.snackbar('Error', 'Access denied');
      Get.back();
      return;
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final products = await _repository.getProducts(_shopId!);
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(ParaProductModel product) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Delete ${product.title}?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await _repository.deleteProduct(_shopId!, product.id);
        _loadProducts();
        Get.snackbar('Success', 'Product deleted');
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed('/para-admin-product-edit', arguments: {
              'shopId': _shopId,
              'productId': null,
            })?.then((_) => _loadProducts()),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No products yet',
                            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => Get.toNamed('/para-admin-product-edit', arguments: {
                              'shopId': _shopId,
                              'productId': null,
                            })?.then((_) => _loadProducts()),
                            child: const Text('Add Product'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: product.imageUrl.isNotEmpty
                                  ? NetworkImage(product.imageUrl)
                                  : null,
                              child: product.imageUrl.isEmpty ? const Icon(Icons.image) : null,
                            ),
                            title: Text(product.title),
                            subtitle: Text(
                              '${product.priceMad.toStringAsFixed(2)} MAD • Stock: ${product.stock} • ${product.isActive ? "Active" : "Inactive"}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => Get.toNamed('/para-admin-product-edit', arguments: {
                                    'shopId': _shopId,
                                    'productId': product.id,
                                  })?.then((_) => _loadProducts()),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteProduct(product),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

