import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProductService {
  final CollectionReference productsCollection =
  FirebaseFirestore.instance.collection('products');

  // Create Product
  Future<void> addProduct(Map<String, dynamic> product) async {
    await productsCollection.add(product);
  }

  // Read Products (Realtime)
  Stream<QuerySnapshot> getProducts() {
    return productsCollection.snapshots();
  }

  // Update Product
  Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    await productsCollection.doc(id).update(product);
  }

  // Delete Product
  Future<void> deleteProduct(String id) async {
    await productsCollection.doc(id).delete();
  }
}
