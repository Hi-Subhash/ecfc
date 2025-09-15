import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/product_model.dart'; // Corrected path assuming models is a sibling to services

class CartService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Public getter for FirebaseAuth instance
  FirebaseAuth get firebaseAuth => _auth;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? _userCartItemsCollection() {
    final userId = _userId;
    if (userId == null) return null;
    return _firestore.collection('carts').doc(userId).collection('items');
  }

  Future<void> addItem(Product product, {int quantity = 1}) async {
    final userId = _userId;
    if (userId == null) {
      debugPrint("User not logged in. Cannot add to cart.");
      return;
    }

    final cartItemsCollection = _userCartItemsCollection();
    if (cartItemsCollection == null) return;

    final querySnapshot = await cartItemsCollection
        .where('productId', isEqualTo: product.id)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      await doc.reference.update({
        'quantity': doc.data()['quantity'] + quantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Data to be stored in the cart item document in Firestore
      Map<String, dynamic> cartItemData = {
        'productId': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.image,
        'quantity': quantity,
        'addedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await cartItemsCollection.add(cartItemData);
    }
    // notifyListeners(); // Only if non-stream based UI needs updates
  }

  Future<void> removeItem(String cartItemDocId) async {
    final userId = _userId;
    if (userId == null) {
      debugPrint("User not logged in. Cannot remove item.");
      return;
    }
    final cartItemsCollection = _userCartItemsCollection();
    if (cartItemsCollection == null) return;

    await cartItemsCollection.doc(cartItemDocId).delete();
    // notifyListeners();
  }

  Future<void> updateItemQuantity(String cartItemDocId, int newQuantity) async {
    final userId = _userId;
    if (userId == null) {
      debugPrint("User not logged in. Cannot update quantity.");
      return;
    }
    final cartItemsCollection = _userCartItemsCollection();
    if (cartItemsCollection == null) return;

    if (newQuantity <= 0) {
      await removeItem(cartItemDocId);
    } else {
      await cartItemsCollection.doc(cartItemDocId).update({
        'quantity': newQuantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    // notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getCartItemsStream() {
    final userId = _userId;
    if (userId == null) {
      debugPrint("User not logged in. Cannot get cart stream.");
      return Stream.empty();
    }
    return _userCartItemsCollection()?.orderBy('addedAt', descending: true).snapshots();
  }

  Future<void> clearCart() async {
    final userId = _userId;
    if (userId == null) {
      debugPrint("User not logged in. Cannot clear cart.");
      return;
    }
    final cartItemsCollection = _userCartItemsCollection();
    if (cartItemsCollection == null) return;

    final WriteBatch batch = _firestore.batch();
    final snapshot = await cartItemsCollection.get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    // notifyListeners();
  }
}
