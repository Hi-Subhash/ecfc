import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: const Center(
        child: Text(
          "This is the Notifications Page",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
