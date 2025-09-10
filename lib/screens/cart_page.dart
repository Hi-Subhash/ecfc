import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: cart.items.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final product = cart.items[index];
          return ListTile(
            leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(product.title),
            subtitle: Text("₹${product.price}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                cart.removeItem(product);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Checkout logic
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Proceeding to Checkout...")),
            );
          },
          child: Text("Checkout (₹${cart.totalPrice.toStringAsFixed(2)})"),
        ),
      ),
    );
  }
}





// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/cart_service.dart';
//
// class CartPage extends StatelessWidget {
//   const CartPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<CartService>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Cart")),
//       body: cart.items.isEmpty
//           ? const Center(child: Text("Your cart is empty"))
//           : ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: cart.items.length,
//         itemBuilder: (context, index) {
//           final item = cart.items[index];
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//               child: Container(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   children: [
//                     Image.network(item['image'], height: 60, width: 60, fit: BoxFit.cover),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(item['title'], maxLines: 1, overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(color: Colors.white)),
//                           Text("₹${item['price']}",
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, color: Colors.amber)),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => cart.removeItem(index),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: cart.items.isEmpty
//           ? null
//           : Container(
//         padding: const EdgeInsets.all(16),
//         color: Colors.black.withOpacity(0.6),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text("Total: ₹${cart.totalPrice.toStringAsFixed(2)}",
//                 style: const TextStyle(color: Colors.white, fontSize: 18)),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Checkout not implemented yet")),
//                 );
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
//               child: const Text("Checkout"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
