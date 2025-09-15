import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistButton extends StatelessWidget {
  final String productId;
  final String title;
  final double price;
  final String image;

  const WishlistButton({
    super.key,
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox();
    }

    final wishlistRef = FirebaseFirestore.instance.collection("wishlist");

    return StreamBuilder<QuerySnapshot>(
      stream: wishlistRef
          .where("userId", isEqualTo: user.uid)
          .where("productId", isEqualTo: productId)
          .snapshots(),
      builder: (context, snapshot) {
        final alreadyInWishlist =
            snapshot.hasData && snapshot.data!.docs.isNotEmpty;

        return IconButton(
          icon: Icon(
            alreadyInWishlist ? Icons.favorite : Icons.favorite_border,
            color: alreadyInWishlist ? Colors.red : Colors.grey,
            size: 30,
          ),
          onPressed: () async {
            if (alreadyInWishlist) {
              // 🔹 Remove from wishlist
              for (var doc in snapshot.data!.docs) {
                await wishlistRef.doc(doc.id).delete();
              }
              debugPrint("🗑 Removed from wishlist → productId=$productId userId=${user.uid}");
            } else {
              // 🔹 Add to wishlist
              await wishlistRef.add({
                "userId": user.uid, // ✅ always save correct userId
                "productId": productId,
                "name": title,
                "price": price,
                "image": image,
                "createdAt": FieldValue.serverTimestamp(),
              });
              debugPrint("❤️ Added to wishlist → productId=$productId userId=${user.uid}");
            }
          },
        );
      },
    );
  }
}
