// Safe Firestore Utilities with Defensive Null Checks
// Use these utilities to prevent crashes when documents are missing

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SafeFirestoreUtils {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Safely get a document with null checks
  static Future<Map<String, dynamic>?> getDocumentSafely({
    required String collection,
    required String documentId,
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(documentId).get();
      
      if (!doc.exists) {
        debugPrint('[SafeFirestore] Document does not exist: $collection/$documentId');
        return null;
      }
      
      final data = doc.data();
      if (data == null) {
        debugPrint('[SafeFirestore] Document data is null: $collection/$documentId');
        return null;
      }
      
      return data;
    } catch (e, stackTrace) {
      debugPrint('[SafeFirestore] Error getting document: $e');
      debugPrint('[SafeFirestore] Stack trace: $stackTrace');
      return null;
    }
  }

  /// Safely get a collection with null checks
  static Future<List<Map<String, dynamic>>> getCollectionSafely({
    required String collection,
    Query Function(Query)? queryBuilder,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collection);
      
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      
      if (snapshot.docs.isEmpty) {
        debugPrint('[SafeFirestore] Collection is empty: $collection');
        return [];
      }
      
      final results = <Map<String, dynamic>>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data != null && data is Map<String, dynamic> && data.isNotEmpty) {
          results.add(data);
        } else {
          debugPrint('[SafeFirestore] Document data is null or invalid in collection: $collection/${doc.id}');
        }
      }
      return results;
    } catch (e, stackTrace) {
      debugPrint('[SafeFirestore] Error getting collection: $e');
      debugPrint('[SafeFirestore] Stack trace: $stackTrace');
      return [];
    }
  }

  /// Safely get a field value with type checking
  static T? getFieldSafely<T>(Map<String, dynamic>? data, String fieldName) {
    if (data == null) {
      debugPrint('[SafeFirestore] Data is null, cannot get field: $fieldName');
      return null;
    }
    
    if (!data.containsKey(fieldName)) {
      debugPrint('[SafeFirestore] Field does not exist: $fieldName');
      return null;
    }
    
    final value = data[fieldName];
    
    if (value == null) {
      return null;
    }
    
    // Type checking
    if (value is T) {
      return value;
    }
    
    debugPrint('[SafeFirestore] Type mismatch for field $fieldName. Expected $T, got ${value.runtimeType}');
    return null;
  }

  /// Safely get a nested field value
  static T? getNestedFieldSafely<T>(
    Map<String, dynamic>? data,
    List<String> fieldPath,
  ) {
    if (data == null || fieldPath.isEmpty) {
      return null;
    }
    
    dynamic current = data;
    
    for (int i = 0; i < fieldPath.length; i++) {
      final field = fieldPath[i];
      
      if (current is! Map<String, dynamic>) {
        debugPrint('[SafeFirestore] Path invalid at $field. Current value is not a Map.');
        return null;
      }
      
      if (!current.containsKey(field)) {
        debugPrint('[SafeFirestore] Field does not exist in path: ${fieldPath.sublist(0, i + 1).join('.')}');
        return null;
      }
      
      current = current[field];
      
      if (current == null) {
        return null;
      }
      
      // Last field - check type
      if (i == fieldPath.length - 1) {
        if (current is! T) {
          debugPrint('[SafeFirestore] Type mismatch for nested field ${fieldPath.join('.')}. Expected $T, got ${current.runtimeType}');
          return null;
        }
        return current;
      }
    }
    
    return null;
  }

  /// Safely convert Timestamp to DateTime
  static DateTime? timestampToDateTime(dynamic value) {
    if (value == null) return null;
    
    if (value is Timestamp) {
      return value.toDate();
    }
    
    if (value is DateTime) {
      return value;
    }
    
    debugPrint('[SafeFirestore] Cannot convert to DateTime: ${value.runtimeType}');
    return null;
  }

  /// Safely convert to double
  static double safeDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    
    debugPrint('[SafeFirestore] Cannot convert to double: ${value.runtimeType}');
    return defaultValue;
  }

  /// Safely convert to int
  static int safeInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    
    debugPrint('[SafeFirestore] Cannot convert to int: ${value.runtimeType}');
    return defaultValue;
  }

  /// Safely convert to bool
  static bool safeBool(dynamic value, [bool defaultValue = false]) {
    if (value == null) return defaultValue;
    
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    if (value is int) {
      return value != 0;
    }
    
    debugPrint('[SafeFirestore] Cannot convert to bool: ${value.runtimeType}');
    return defaultValue;
  }

  /// Safely convert to String
  static String safeString(dynamic value, [String defaultValue = '']) {
    if (value == null) return defaultValue;
    
    if (value is String) return value;
    
    return value.toString();
  }

  /// Safely convert List
  static List<T> safeList<T>(dynamic value, [List<T> defaultValue = const []]) {
    if (value == null) return defaultValue;
    
    if (value is! List) {
      debugPrint('[SafeFirestore] Value is not a List: ${value.runtimeType}');
      return defaultValue;
    }
    
    try {
      return List<T>.from(value);
    } catch (e) {
      debugPrint('[SafeFirestore] Cannot cast List to List<$T>: $e');
      return defaultValue;
    }
  }

  /// Check if document exists
  static Future<bool> documentExists({
    required String collection,
    required String documentId,
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(documentId).get();
      return doc.exists;
    } catch (e) {
      debugPrint('[SafeFirestore] Error checking document existence: $e');
      return false;
    }
  }

  /// Safely set a document
  static Future<bool> setDocumentSafely({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    SetOptions? options,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(documentId)
          .set(data, options ?? SetOptions(merge: false));
      return true;
    } catch (e, stackTrace) {
      debugPrint('[SafeFirestore] Error setting document: $e');
      debugPrint('[SafeFirestore] Stack trace: $stackTrace');
      return false;
    }
  }

  /// Safely update a document
  static Future<bool> updateDocumentSafely({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Check if document exists first
      final exists = await documentExists(
        collection: collection,
        documentId: documentId,
      );
      
      if (!exists) {
        debugPrint('[SafeFirestore] Cannot update non-existent document: $collection/$documentId');
        return false;
      }
      
      await _firestore
          .collection(collection)
          .doc(documentId)
          .update(data);
      return true;
    } catch (e, stackTrace) {
      debugPrint('[SafeFirestore] Error updating document: $e');
      debugPrint('[SafeFirestore] Stack trace: $stackTrace');
      return false;
    }
  }

  /// Safely delete a document
  static Future<bool> deleteDocumentSafely({
    required String collection,
    required String documentId,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(documentId)
          .delete();
      return true;
    } catch (e, stackTrace) {
      debugPrint('[SafeFirestore] Error deleting document: $e');
      debugPrint('[SafeFirestore] Stack trace: $stackTrace');
      return false;
    }
  }
}

