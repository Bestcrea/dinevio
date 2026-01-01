import 'package:customer/features/para/data/models/para_product_model.dart';
import 'package:customer/features/para/data/models/para_shop_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

/// Repository for ParaShop and ParaProduct Firestore operations
class ParaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ========== SHOPS ==========

  /// Get all shops, optionally filtered by category
  Future<List<ParaShopModel>> getShops({String? category}) async {
    try {
      Query query = _firestore.collection('para_shops');
      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }
      final snapshot = await query.orderBy('createdAt', descending: true).get();
      return snapshot.docs.map((doc) => ParaShopModel.fromDoc(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch shops: $e');
    }
  }

  /// Get shop by ID
  Future<ParaShopModel?> getShop(String shopId) async {
    try {
      final doc = await _firestore.collection('para_shops').doc(shopId).get();
      if (!doc.exists) return null;
      return ParaShopModel.fromDoc(doc);
    } catch (e) {
      throw Exception('Failed to fetch shop: $e');
    }
  }

  /// Get shops owned by a user
  Future<List<ParaShopModel>> getShopsByOwner(String ownerUid) async {
    try {
      final snapshot = await _firestore
          .collection('para_shops')
          .where('ownerUid', isEqualTo: ownerUid)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => ParaShopModel.fromDoc(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch owner shops: $e');
    }
  }

  /// Search shops by name
  Future<List<ParaShopModel>> searchShops(String query) async {
    try {
      final snapshot = await _firestore
          .collection('para_shops')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
      return snapshot.docs.map((doc) => ParaShopModel.fromDoc(doc)).toList();
    } catch (e) {
      // Fallback: fetch all and filter client-side
      final allShops = await getShops();
      return allShops
          .where((shop) => shop.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  /// Create or update shop
  Future<String> saveShop(ParaShopModel shop) async {
    try {
      if (shop.id.isEmpty) {
        // Create new
        final docRef = await _firestore.collection('para_shops').add(shop.toJson());
        return docRef.id;
      } else {
        // Update existing
        await _firestore.collection('para_shops').doc(shop.id).update(shop.toJson());
        return shop.id;
      }
    } catch (e) {
      throw Exception('Failed to save shop: $e');
    }
  }

  /// Delete shop
  Future<void> deleteShop(String shopId) async {
    try {
      // Delete products first
      final products = await getProducts(shopId);
      for (var product in products) {
        await deleteProduct(shopId, product.id);
      }
      // Delete shop
      await _firestore.collection('para_shops').doc(shopId).delete();
    } catch (e) {
      throw Exception('Failed to delete shop: $e');
    }
  }

  /// Upload shop cover image
  Future<String> uploadCoverImage(String shopId, File imageFile) async {
    try {
      final ref = _storage.ref().child('para_shops/$shopId/cover.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload cover image: $e');
    }
  }

  /// Upload shop logo
  Future<String> uploadLogo(String shopId, File imageFile) async {
    try {
      final ref = _storage.ref().child('para_shops/$shopId/logo.png');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload logo: $e');
    }
  }

  // ========== PRODUCTS ==========

  /// Get products for a shop
  Future<List<ParaProductModel>> getProducts(String shopId, {bool? activeOnly}) async {
    try {
      Query query = _firestore
          .collection('para_shops')
          .doc(shopId)
          .collection('products');
      if (activeOnly == true) {
        query = query.where('isActive', isEqualTo: true);
      }
      final snapshot = await query.orderBy('createdAt', descending: true).get();
      return snapshot.docs.map((doc) => ParaProductModel.fromDoc(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  /// Get product by ID
  Future<ParaProductModel?> getProduct(String shopId, String productId) async {
    try {
      final doc = await _firestore
          .collection('para_shops')
          .doc(shopId)
          .collection('products')
          .doc(productId)
          .get();
      if (!doc.exists) return null;
      return ParaProductModel.fromDoc(doc);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  /// Create or update product
  Future<String> saveProduct(ParaProductModel product) async {
    try {
      if (product.id.isEmpty) {
        // Create new
        final docRef = await _firestore
            .collection('para_shops')
            .doc(product.shopId)
            .collection('products')
            .add(product.toJson());
        return docRef.id;
      } else {
        // Update existing
        await _firestore
            .collection('para_shops')
            .doc(product.shopId)
            .collection('products')
            .doc(product.id)
            .update(product.toJson());
        return product.id;
      }
    } catch (e) {
      throw Exception('Failed to save product: $e');
    }
  }

  /// Delete product
  Future<void> deleteProduct(String shopId, String productId) async {
    try {
      await _firestore
          .collection('para_shops')
          .doc(shopId)
          .collection('products')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  /// Upload product image
  Future<String> uploadProductImage(String shopId, String productId, File imageFile) async {
    try {
      final ref = _storage.ref().child('para_shops/$shopId/products/$productId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload product image: $e');
    }
  }
}

