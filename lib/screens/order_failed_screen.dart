import 'package:flutter/material.dart';

class OrderFailedScreen extends StatelessWidget {
  final int? code;
  final String message;

  const OrderFailedScreen({
    Key? key,
    required this.code,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel, color: Colors.red, size: 100),
              const SizedBox(height: 20),
              const Text(
                "Payment Failed!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("Code: $code"),
              Text("Reason: $message"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Retry or go back
                },
                child: const Text("Try Again"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
