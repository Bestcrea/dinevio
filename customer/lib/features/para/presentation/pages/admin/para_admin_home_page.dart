import 'package:customer/features/para/data/models/para_shop_model.dart';
import 'package:customer/features/para/data/repositories/para_repository.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Admin home page - lists shops owned by current user
class ParaAdminHomePage extends StatefulWidget {
  const ParaAdminHomePage({super.key});

  @override
  State<ParaAdminHomePage> createState() => _ParaAdminHomePageState();
}

class _ParaAdminHomePageState extends State<ParaAdminHomePage> {
  final ParaRepository _repository = ParaRepository();
  List<ParaShopModel> _shops = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  Future<void> _loadShops() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final uid = FireStoreUtils.getCurrentUid();
      if (uid == null) {
        setState(() {
          _error = 'Not logged in';
          _isLoading = false;
        });
        return;
      }
      final shops = await _repository.getShopsByOwner(uid);
      setState(() {
        _shops = shops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shops'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed('/para-admin-shop-edit', arguments: {'shopId': null}),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _shops.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.store_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No shops yet',
                            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => Get.toNamed('/para-admin-shop-edit', arguments: {'shopId': null}),
                            child: const Text('Create Shop'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _shops.length,
                      itemBuilder: (context, index) {
                        final shop = _shops[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: shop.coverImageUrl.isNotEmpty
                                  ? NetworkImage(shop.coverImageUrl)
                                  : null,
                              child: shop.coverImageUrl.isEmpty ? const Icon(Icons.store) : null,
                            ),
                            title: Text(shop.name),
                            subtitle: Text('${shop.category} • ${shop.isOpen ? "Open" : "Closed"}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => Get.toNamed('/para-admin-shop-edit', arguments: {'shopId': shop.id}),
                            ),
                            onTap: () => Get.toNamed('/para-admin-products', arguments: {'shopId': shop.id}),
                          ),
                        );
                      },
                    ),
    );
  }
}

