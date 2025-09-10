import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class FirestoreProductService {
  final CollectionReference _productCollection =
  FirebaseFirestore.instance.collection('products');

  // 🔹 Stream all products as List<Product>
  Stream<List<Product>> getProducts() {
    return _productCollection.snapshots().map((snapshot) {
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
