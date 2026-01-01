import 'dart:io';
import 'package:customer/features/para/data/models/para_product_model.dart';
import 'package:customer/features/para/data/repositories/para_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Admin page to create/edit product
class ParaAdminProductEditPage extends StatefulWidget {
  const ParaAdminProductEditPage({super.key});

  @override
  State<ParaAdminProductEditPage> createState() => _ParaAdminProductEditPageState();
}

class _ParaAdminProductEditPageState extends State<ParaAdminProductEditPage> {
  final ParaRepository _repository = ParaRepository();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  bool _isActive = true;
  File? _imageFile;
  bool _isLoading = false;
  String? _shopId;
  String? _productId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    _shopId = args?['shopId'] as String?;
    _productId = args?['productId'] as String?;
    if (_productId != null) {
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    if (_shopId == null || _productId == null) return;
    setState(() => _isLoading = true);
    try {
      final product = await _repository.getProduct(_shopId!, _productId!);
      if (product != null) {
        _titleController.text = product.title;
        _descriptionController.text = product.description;
        _categoryController.text = product.category;
        _priceController.text = product.priceMad.toString();
        _stockController.text = product.stock.toString();
        _isActive = product.isActive;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageFile = File(image.path));
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_shopId == null) {
      Get.snackbar('Error', 'Shop ID required');
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? imageUrl;

      // Upload image if new
      if (_imageFile != null) {
        if (_productId == null || _productId!.isEmpty) {
          // Create temp product to get ID
          final tempProduct = ParaProductModel(
            id: '',
            shopId: _shopId!,
            title: _titleController.text,
            description: _descriptionController.text,
            imageUrl: '',
            category: _categoryController.text,
            priceMad: double.parse(_priceController.text),
            stock: int.parse(_stockController.text),
            isActive: _isActive,
            createdAt: DateTime.now(),
          );
          _productId = await _repository.saveProduct(tempProduct);
        }
        imageUrl = await _repository.uploadProductImage(_shopId!, _productId!, _imageFile!);
      }

      // Load existing or create new
      final existingProduct = _productId != null ? await _repository.getProduct(_shopId!, _productId!) : null;
      final product = existingProduct?.copyWith(
            title: _titleController.text,
            description: _descriptionController.text,
            category: _categoryController.text,
            priceMad: double.parse(_priceController.text),
            stock: int.parse(_stockController.text),
            isActive: _isActive,
            imageUrl: imageUrl ?? (existingProduct?.imageUrl ?? ''),
          ) ??
          ParaProductModel(
            id: _productId ?? '',
            shopId: _shopId!,
            title: _titleController.text,
            description: _descriptionController.text,
            imageUrl: imageUrl ?? '',
            category: _categoryController.text,
            priceMad: double.parse(_priceController.text),
            stock: int.parse(_stockController.text),
            isActive: _isActive,
            createdAt: DateTime.now(),
          );

      await _repository.saveProduct(product);
      Get.snackbar('Success', 'Product saved');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save product: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_productId == null ? 'Create Product' : 'Edit Product'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Image
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _imageFile != null
                          ? Image.file(_imageFile!, fit: BoxFit.cover)
                          : const Center(child: Icon(Icons.add_photo_alternate, size: 48)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Product Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  // Category
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  // Price (MAD)
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price (MAD)',
                      border: OutlineInputBorder(),
                      prefixText: 'MAD ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      if (double.tryParse(value!) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Stock
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      if (int.tryParse(value!) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Is Active
                  SwitchListTile(
                    title: const Text('Product is Active'),
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                  ),
                  const SizedBox(height: 24),
                  // Save Button
                  ElevatedButton(
                    onPressed: _saveProduct,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF7E57C2),
                    ),
                    child: const Text('Save Product'),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}

