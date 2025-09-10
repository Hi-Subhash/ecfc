import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wishlist_service.dart';
import '../models/product_model.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Wishlist")),
      body: wishlist.items.isEmpty
          ? const Center(child: Text("Your wishlist is empty ❤️"))
          : ListView.builder(
        itemCount: wishlist.items.length,
        itemBuilder: (context, index) {
          final Product product = wishlist.items[index]; // ✅ Product object
          return Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, stack) =>
                  const Icon(Icons.broken_image, size: 40),
                ),
              ),
              title: Text(product.title),
              subtitle: Text("₹${product.price}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  wishlist.removeItem(product); // ✅ pass Product
                },
              ),
            ),
          );
        },
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/wishlist_service.dart';
//
// class WishlistPage extends StatelessWidget {
//   const WishlistPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final wishlist = Provider.of<WishlistService>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Wishlist")),
//       body: wishlist.items.isEmpty
//           ? const Center(child: Text("Your wishlist is empty ❤️"))
//           : ListView.builder(
//         itemCount: wishlist.items.length,
//         itemBuilder: (context, index) {
//           final item = wishlist.items[index];
//           return Card(
//             margin: const EdgeInsets.all(8),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16)),
//             child: ListTile(
//               leading: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(item['image'],
//                     width: 60, height: 60, fit: BoxFit.cover),
//               ),
//               title: Text(item['title']),
//               subtitle: Text("\$${item['price']}"),
//               trailing: IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red),
//                 onPressed: () {
//                   wishlist.removeItem(item);
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
