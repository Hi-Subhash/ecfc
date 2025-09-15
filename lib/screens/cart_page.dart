import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cart_service.dart';
import 'checkout_screen.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final userId = cartService.firebaseAuth.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Cart")),
        body: const Center(
          child: Text("Please log in to view your cart."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: cartService.getCartItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading cart."));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          final cartDocs = snapshot.data!.docs;
          double totalPrice = 0;
          for (var doc in cartDocs) {
            final data = doc.data();
            totalPrice +=
                (data['price'] as num? ?? 0.0) * (data['quantity'] as int? ?? 0);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartDocs.length,
                  itemBuilder: (context, index) {
                    final cartItemDoc = cartDocs[index];
                    final data = cartItemDoc.data();

                    final String name = data['title'] as String? ?? 'Unnamed Item';
                    final num price = data['price'] as num? ?? 0.0;
                    final int quantity = data['quantity'] as int? ?? 1;
                    final String? image = data['image'] as String?;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: image != null && image.isNotEmpty
                                  ? Image.network(
                                image,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Product Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "₹${price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Quantity controls
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline),
                                        onPressed: () {
                                          if (quantity > 1) {
                                            cartService.updateItemQuantity(
                                                cartItemDoc.id, quantity - 1);
                                          }
                                        },
                                      ),
                                      Text(
                                        "$quantity",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline),
                                        onPressed: () {
                                          cartService.updateItemQuantity(
                                              cartItemDoc.id, quantity + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Delete Button
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                cartService.removeItem(cartItemDoc.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Total + Checkout
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ₹${totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (cartDocs.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Your cart is empty.")),
                          );
                          return;
                        }

                        final checkoutItems = cartDocs.map((doc) {
                          final data = doc.data();
                          return {
                            "title": data['title'] as String? ?? 'N/A',
                            "price": data['price'] as num? ?? 0.0,
                            "image": data['image'] as String?,
                            "quantity": data['quantity'] as int? ?? 0,
                          };
                        }).toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              cartItems: checkoutItems,
                              totalAmount: totalPrice,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
