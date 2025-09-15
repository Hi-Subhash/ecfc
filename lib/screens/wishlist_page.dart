import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to view wishlist")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Wishlist")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("wishlist")
            .where("userId", isEqualTo: user.uid) // ✅ filter per user
            // .orderBy("createdAt", descending: true) // newest first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No favorites yet ❤️"));
          }
          if (snapshot.hasData) {
            debugPrint("🔥 Wishlist docs count: ${snapshot.data!.docs.length}");
            for (var doc in snapshot.data!.docs) {
              debugPrint("Doc: ${doc.data()}");
            }
          }


          final favorites = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final fav = favorites[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: Image.network(fav['image'], width: 50, height: 50, fit: BoxFit.cover),
                title: Text(fav['name']),
                subtitle: Text("₹${fav['price']}"),
                trailing: const Icon(Icons.favorite, color: Colors.red),
              );
            },
          );
        },
      ),
    );
  }
}

