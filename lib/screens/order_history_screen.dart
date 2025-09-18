import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // ✅ for date formatting

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  Future<void> _reorderItems(
      BuildContext context, String userId, List<Map<String, dynamic>> items) async {
    final cartRef =
    FirebaseFirestore.instance.collection("carts").doc(userId).collection("items");

    for (var item in items) {
      final query = await cartRef.where("title", isEqualTo: item["title"]).limit(1).get();

      if (query.docs.isNotEmpty) {
        // ✅ Item already in cart → update quantity
        final docId = query.docs.first.id;
        final existingQty = query.docs.first["quantity"] ?? 0;
        await cartRef.doc(docId).update({
          "quantity": existingQty + (item["quantity"] ?? 1),
        });
      } else {
        // ✅ New item → add to cart
        await cartRef.add({
          "title": item["title"],
          "image": item["image"],
          "price": item["price"],
          "quantity": item["quantity"] ?? 1,
        });
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Items added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in to view your orders.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("userId", isEqualTo: user.uid)
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No orders found for this user."),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              final items = List<Map<String, dynamic>>.from(data["items"]);
              final totalAmount = data["totalAmount"];
              final status = data["paymentStatus"];
              final method = data["paymentMethod"];
              final paymentId = data["paymentId"] ?? "-";

              // ✅ Total items count
              final totalItems = items.fold<int>(
                0,
                    (sum, item) => sum + ((item["quantity"] ?? 0) as int),
              );

              // ✅ Format order date
              String orderDate = "";
              if (data["createdAt"] != null) {
                final timestamp = data["createdAt"] as Timestamp;
                orderDate =
                    DateFormat("dd MMM yyyy, hh:mm a").format(timestamp.toDate());
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ExpansionTile(
                  title: Text(
                    "₹$totalAmount  •  $status  •  $totalItems items",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: status == "Success" ? Colors.green : Colors.red,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Method: $method"),
                      if (orderDate.isNotEmpty) Text("Date: $orderDate"),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Payment ID: $paymentId"),
                          const SizedBox(height: 8),
                          const Text(
                            "Items:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          ...items.map((item) => ListTile(
                            leading: item["image"] != null
                                ? Image.network(
                              item["image"],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                                : const Icon(Icons.image_not_supported),
                            title: Text(item["title"] ?? "Unknown Item"),
                            subtitle: Text(
                                "Qty: ${item["quantity"] ?? 0}  |  Price: ₹${item["price"] ?? 0}"),
                          )),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _reorderItems(context, user.uid, items),
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text("Reorder"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
