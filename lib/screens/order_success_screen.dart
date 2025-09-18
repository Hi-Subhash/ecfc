import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderDocId;

  const OrderSuccessScreen({Key? key, required this.orderDocId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("Order Confirmation"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("orders")
            .doc(orderDocId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Order not found"),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final items = List<Map<String, dynamic>>.from(data["items"]);

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(Icons.check_circle,
                      color: Colors.green, size: 100),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    "Payment Successful!",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Text("Payment ID: ${data["paymentId"] ?? "-"}"),
                Text("Total Amount: ₹${data["totalAmount"]}"),
                Text("Status: ${data["paymentStatus"]}"),
                const SizedBox(height: 15),
                const Text(
                  "Ordered Items:",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(item["name"] ?? "Unknown Item"),
                          subtitle: Text(
                              "Qty: ${item["qty"]}  |  Price: ₹${item["price"]}"),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.pop(context); // go back to home
                    },
                    child: const Text("Continue Shopping"),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
