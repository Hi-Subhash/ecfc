import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/checkout_service.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CheckoutService _checkoutService = CheckoutService();

  @override
  void dispose() {
    _checkoutService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          /// 🔹 Fashion Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🔹 Glass Checkout Card
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// 🔹 Title
                      const Text(
                        "Order Summary",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),

                      /// 🔹 Cart Items List
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          itemCount: widget.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = widget.cartItems[index];
                            final String title =
                                item['title'] as String? ?? "Unnamed Product";
                            final num price = item['price'] as num? ?? 0.0;
                            final int quantity = item['quantity'] as int? ?? 1;
                            final String? image = item['image'] as String?;

                            return Card(
                              color: Colors.white.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: image != null && image.isNotEmpty
                                      ? Image.network(
                                    image,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                    const Icon(
                                        Icons.broken_image,
                                        color: Colors.white),
                                  )
                                      : Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey.shade700,
                                    child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  "₹${price.toStringAsFixed(2)} x $quantity",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: Text(
                                  "₹${(price * quantity).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const Divider(color: Colors.white30),

                      /// 🔹 Total Amount
                      Text(
                        "Total: ₹${widget.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// 🔹 Razorpay Pay Now Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        icon: const Icon(Icons.payment, color: Colors.white),
                        label: const Text(
                          "Pay Now",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () {
                          _checkoutService.openCheckout(
                            widget.totalAmount,
                            widget.cartItems,
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      /// 🔹 COD Option
                      // OutlinedButton.icon(
                      //   style: OutlinedButton.styleFrom(
                      //     side: const BorderSide(
                      //         color: Colors.white70, width: 1.5),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 40, vertical: 15),
                      //   ),
                      //   icon: const Icon(Icons.local_shipping,
                      //       color: Colors.white),
                      //   label: const Text(
                      //     "Cash on Delivery",
                      //     style: TextStyle(fontSize: 18, color: Colors.white),
                      //   ),
                      //   onPressed: () {
                      //     _checkoutService.createCodOrder(
                      //       widget.cartItems,
                      //       widget.totalAmount,
                      //     );
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text("Order placed (COD) ✅")),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
