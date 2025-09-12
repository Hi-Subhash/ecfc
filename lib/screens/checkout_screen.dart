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
      body: Stack(
        children: [
          /// 🔹 Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.jpg"), // add a fashion background
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🔹 Glass checkout card
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
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

                      /// 🔹 Cart Items List (with image)
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          itemCount: widget.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = widget.cartItems[index];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                item['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "₹${item['price']}",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            );
                          },
                        ),
                      ),

                      Divider(color: Colors.white30),

                      /// 🔹 Total Amount
                      Text(
                        "Total: ₹${widget.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// 🔹 Razorpay Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        onPressed: () {
                          _checkoutService.openCheckout(
                            widget.totalAmount,
                            widget.cartItems,
                          );
                        },
                        child: const Text(
                          "Pay Now",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// 🔹 COD Option
                      // OutlinedButton(
                      //   style: OutlinedButton.styleFrom(
                      //     side:
                      //     const BorderSide(color: Colors.white70, width: 1.5),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 40, vertical: 15),
                      //   ),
                      //   onPressed: () {
                      //     _checkoutService.createCodOrder(
                      //       widget.cartItems,
                      //       widget.totalAmount,
                      //     );
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(content: Text("Order placed (COD) ✅")),
                      //     );
                      //   },
                      //   child: const Text(
                      //     "Cash on Delivery",
                      //     style: TextStyle(fontSize: 18, color: Colors.white),
                      //   ),
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
