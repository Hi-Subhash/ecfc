import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cart_page.dart'; // ✅ Make sure CartPage exists

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  Future<void> _removeFromWishlist(String docId) async {
    await FirebaseFirestore.instance.collection("wishlist").doc(docId).delete();
  }

  Future<void> _moveToCart(Map<String, dynamic> product, String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // ✅ Add to cart
    await FirebaseFirestore.instance.collection("carts").add({
      "userId": user.uid,
      "productId": product["productId"] ?? "",
      "name": product["name"] ?? "Unnamed",
      "image": product["image"] ?? "",
      "price": product["price"] ?? 0,
      "quantity": 1,
      "createdAt": FieldValue.serverTimestamp(),
    });

    // ✅ Remove from wishlist
    await _removeFromWishlist(docId);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to view wishlist")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wishlist"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("wishlist")
            .where("userId", isEqualTo: user.uid)
            // .orderBy("createdAt", descending: true) // ✅ newest first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No favorites yet ❤️"));
          }

          final favorites = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final doc = favorites[index];
              final fav = doc.data() as Map<String, dynamic>;

              final name = fav["name"] ?? "Unnamed";
              final image = fav["image"] ??
                  "https://via.placeholder.com/150"; // placeholder
              final price = fav["price"] ?? 0;

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    "₹$price",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.green),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: "Move to cart",
                        icon: const Icon(Icons.shopping_cart,
                            color: Colors.blue),
                        onPressed: () async {
                          await _moveToCart(fav, doc.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Moved to cart ✅")),
                          );
                        },
                      ),
                      IconButton(
                        tooltip: "Remove from wishlist",
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _removeFromWishlist(doc.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Removed from wishlist ❌")),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
