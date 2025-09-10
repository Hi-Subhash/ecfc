import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';
import 'cart_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product; // 👈 Now takes the whole Product object

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background image
          Hero(
            tag: product.image,
            child: Image.network(
              product.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),

          // Overlay
          Container(color: Colors.black.withOpacity(0.35)),

          // Scrollable glass card content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 140),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Price
                        Text(
                          "₹${product.price}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Text(
                          product.description,
                          style: const TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        const SizedBox(height: 20),

                        // Sizes
                        const Text(
                          "Available Sizes",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: ["S", "M", "L", "XL"]
                              .map(
                                (size) => Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                size,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                        const SizedBox(height: 20),

                        // Colors
                        const Text(
                          "Available Colors",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [Colors.red, Colors.blue, Colors.green, Colors.black]
                              .map(
                                (c) => Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  final cart = Provider.of<CartService>(context, listen: false);
                  cart.addItem(product); // 👈 Now add full Product
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Added to Cart!")),
                  );
                },
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                final wishlist = Provider.of<WishlistService>(context, listen: false);
                wishlist.addItem(product); // 👈 Add full Product
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Added to Wishlist!")),
                );
              },
              icon: const Icon(Icons.favorite_border, color: Colors.red),
              label: const Text("Wishlist"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






// // lib/screens/product_details_page.dart
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/cart_service.dart';
// import 'cart_page.dart';
// import '../services/wishlist_service.dart';
//
// class ProductDetailsPage extends StatelessWidget {
//   final String title;
//   final String price;
//   final String image;
//   final String description; // <-- added
//
//   const ProductDetailsPage({
//     super.key,
//     required this.title,
//     required this.price,
//     required this.image,
//     required this.description, // <-- added
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Stack(
//         children: [
//           // Background image (Hero for smooth transition)
//           Hero(
//             tag: image,
//             child: Image.network(
//               image,
//               width: double.infinity,
//               height: double.infinity,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, progress) {
//                 if (progress == null) return child;
//                 return const Center(child: CircularProgressIndicator());
//               },
//             ),
//           ),
//
//           // Dark translucent overlay so foreground is readable
//           Container(color: Colors.black.withOpacity(0.35)),
//
//           // Scrollable glass card content
//           SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.fromLTRB(16, 100, 16, 140),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(24),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(24),
//                       border: Border.all(color: Colors.white.withOpacity(0.18)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Title
//                         Text(
//                           title,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//
//                         // Price
//                         Text(
//                           "₹$price",
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.amber,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Description (from API)
//                         Text(
//                           description,
//                           style: const TextStyle(fontSize: 16, color: Colors.white70),
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Sizes
//                         const Text(
//                           "Available Sizes",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: ["S", "M", "L", "XL"]
//                               .map(
//                                 (size) => Container(
//                               margin: const EdgeInsets.only(right: 12),
//                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.18),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 size,
//                                 style: const TextStyle(color: Colors.white, fontSize: 16),
//                               ),
//                             ),
//                           )
//                               .toList(),
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Colors
//                         const Text(
//                           "Available Colors",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [Colors.red, Colors.blue, Colors.green, Colors.black]
//                               .map(
//                                 (c) => Container(
//                               margin: const EdgeInsets.only(right: 12),
//                               width: 34,
//                               height: 34,
//                               decoration: BoxDecoration(
//                                 color: c,
//                                 shape: BoxShape.circle,
//                                 border: Border.all(color: Colors.white, width: 2),
//                               ),
//                             ),
//                           )
//                               .toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//
//       // Persistent bottom bar for actions (no overflow)
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.6),
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.amber,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 onPressed: () {
//                   // TODO: add add-to-cart logic (Provider/Firebase)
//                   final cart = Provider.of<CartService>(context, listen: false);
//                   cart.addItem({
//                     "title": title,
//                     "price": price,
//                     "image": image,
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Added to Cart!")),
//                   );
//                 },
//                 child: const Text("Add to Cart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.shopping_cart),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const CartPage()),
//                 );
//               },
//             ),
//             const SizedBox(width: 12),
//             ElevatedButton.icon(
//               onPressed: () {
//                 final wishlist = Provider.of<WishlistService>(context, listen: false);
//                 wishlist.addItem({
//                   "title": title,
//                   "price": price,
//                   "image": image,
//                   "description": description,
//                 });
//                 // TODO: add wishlist logic
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Added to Wishlist!")),
//                 );
//               },
//               icon: const Icon(Icons.favorite_border, color: Colors.red),
//               label: const Text("Wishlist"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.red,
//                 side: const BorderSide(color: Colors.red),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
