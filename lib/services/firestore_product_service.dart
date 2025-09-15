import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class FirestoreProductService {
  final CollectionReference _productCollection =
  FirebaseFirestore.instance.collection('products');

  // 🔹 Stream all products as List<Product>
  Stream<List<Product>> getProducts() {
    return _productCollection
        .orderBy("createdAt", descending: true) // ✅ FIX: newest first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // 🔹 Add new product
  Future<void> addProduct(Product product) async {
    await _productCollection.add(product.toMap());
  }

  // 🔹 Update product
  Future<void> updateProduct(String id, Product product) async {
    await _productCollection.doc(id).update(product.toMap());
  }

  // 🔹 Delete product
  Future<void> deleteProduct(String id) async {
    await _productCollection.doc(id).delete();
  }
}

// lib/services/firestore_product_service.dart
Future<void> fixProductsCreatedAt() async {
  final snapshot = await FirebaseFirestore.instance.collection("products").get();

  int updated = 0;
  for (var doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    if (!data.containsKey("createdAt") || data["createdAt"] == null) {
      await doc.reference.update({
        "createdAt": FieldValue.serverTimestamp(),
      });
      updated++;
    }
  }

  debugPrint("✅ Fixed $updated product docs with missing createdAt");
}
