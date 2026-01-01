import 'dart:io';
import 'package:customer/features/para/data/models/para_shop_model.dart';
import 'package:customer/features/para/data/repositories/para_repository.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Admin page to create/edit shop
class ParaAdminShopEditPage extends StatefulWidget {
  const ParaAdminShopEditPage({super.key});

  @override
  State<ParaAdminShopEditPage> createState() => _ParaAdminShopEditPageState();
}

class _ParaAdminShopEditPageState extends State<ParaAdminShopEditPage> {
  final ParaRepository _repository = ParaRepository();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _opensAtTextController = TextEditingController();
  String? _selectedCategory = 'Parapharmacy';
  bool _isOpen = true;
  File? _coverImage;
  File? _logoImage;
  bool _isLoading = false;
  String? _shopId;

  final List<String> _categories = ['Promotion', 'Parapharmacy', 'Beauty'];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    _shopId = args?['shopId'] as String?;
    if (_shopId != null) {
      _loadShop();
    }
  }

  Future<void> _loadShop() async {
    if (_shopId == null) return;
    setState(() => _isLoading = true);
    try {
      final shop = await _repository.getShop(_shopId!);
      if (shop != null) {
        _nameController.text = shop.name;
        _selectedCategory = shop.category;
        _isOpen = shop.isOpen;
        _opensAtTextController.text = shop.opensAtText;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load shop: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(bool isCover) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isCover) {
          _coverImage = File(image.path);
        } else {
          _logoImage = File(image.path);
        }
      });
    }
  }

  Future<void> _saveShop() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) {
      Get.snackbar('Error', 'Not logged in');
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? coverUrl;
      String? logoUrl;

      // Upload images
      if (_shopId == null || _shopId!.isEmpty) {
        // Create new shop - need to create doc first
        final tempShop = ParaShopModel(
          id: '',
          ownerUid: uid,
          name: _nameController.text,
          coverImageUrl: '',
          category: _selectedCategory!,
          ratingPercent: 0,
          ratingCount: 0,
          deliveryTimeMin: 20,
          deliveryTimeMax: 30,
          isOpen: _isOpen,
          opensAtText: _opensAtTextController.text,
          createdAt: DateTime.now(),
        );
        _shopId = await _repository.saveShop(tempShop);
      }

      if (_coverImage != null) {
        coverUrl = await _repository.uploadCoverImage(_shopId!, _coverImage!);
      }
      if (_logoImage != null) {
        logoUrl = await _repository.uploadLogo(_shopId!, _logoImage!);
      }

      // Load existing shop or use new one
      final existingShop = _shopId != null ? await _repository.getShop(_shopId!) : null;
      final shop = existingShop?.copyWith(
            name: _nameController.text,
            category: _selectedCategory!,
            isOpen: _isOpen,
            opensAtText: _opensAtTextController.text,
            coverImageUrl: coverUrl ?? (existingShop?.coverImageUrl ?? ''),
            logoUrl: logoUrl ?? existingShop?.logoUrl,
          ) ??
          ParaShopModel(
            id: _shopId!,
            ownerUid: uid,
            name: _nameController.text,
            coverImageUrl: coverUrl ?? '',
            logoUrl: logoUrl,
            category: _selectedCategory!,
            ratingPercent: 0,
            ratingCount: 0,
            deliveryTimeMin: 20,
            deliveryTimeMax: 30,
            isOpen: _isOpen,
            opensAtText: _opensAtTextController.text,
            createdAt: DateTime.now(),
          );

      await _repository.saveShop(shop);
      Get.snackbar('Success', 'Shop saved');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save shop: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_shopId == null ? 'Create Shop' : 'Edit Shop'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Cover Image
                  GestureDetector(
                    onTap: () => _pickImage(true),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _coverImage != null
                          ? Image.file(_coverImage!, fit: BoxFit.cover)
                          : const Center(child: Icon(Icons.add_photo_alternate, size: 48)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Logo Image
                  GestureDetector(
                    onTap: () => _pickImage(false),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _logoImage != null
                          ? Image.file(_logoImage!, fit: BoxFit.cover)
                          : const Center(child: Icon(Icons.add_photo_alternate, size: 32)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Shop Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  // Category
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (value) => setState(() => _selectedCategory = value),
                  ),
                  const SizedBox(height: 16),
                  // Is Open
                  SwitchListTile(
                    title: const Text('Shop is Open'),
                    value: _isOpen,
                    onChanged: (value) => setState(() => _isOpen = value),
                  ),
                  // Opens At Text
                  TextFormField(
                    controller: _opensAtTextController,
                    decoration: const InputDecoration(
                      labelText: 'Opens At Text (e.g., "Opens tomorrow at 09:00")',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Save Button
                  ElevatedButton(
                    onPressed: _saveShop,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF7E57C2),
                    ),
                    child: const Text('Save Shop'),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _opensAtTextController.dispose();
    super.dispose();
  }
}

