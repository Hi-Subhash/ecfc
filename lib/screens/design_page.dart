import 'package:flutter/material.dart';

class DesignPage extends StatelessWidget {
  const DesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: Center(
        child: Text(
          "❤️ Design Page",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
