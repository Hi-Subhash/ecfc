import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/order_success_screen.dart';
import '../screens/order_failed_screen.dart';
import '../main.dart'; // contains navigatorKey

class CheckoutService {
  final _razorpay = Razorpay();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CheckoutService() {
    // ✅ Attach event listeners once
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(double amount, List<Map<String, dynamic>> items) {
    var options = {
      'key': 'rzp_test_RGfZJEkqwRzlgM', // Replace with Razorpay key
      'amount': (amount * 100).toInt(), // Razorpay expects amount in paise
      'name': 'CustFashionCart',
      'description': 'Fashion Order Payment',
      'prefill': {
        'contact': '9999999999',
        'email': _auth.currentUser?.email ?? "test@example.com"
      }
    };

    // ✅ Store items & amount temporarily for callback
    _checkoutItems = items;
    _checkoutAmount = amount;

    _razorpay.open(options);
  }

  // temporary storage
  List<Map<String, dynamic>> _checkoutItems = [];
  double _checkoutAmount = 0.0;

  Future<void> _createOrder(List<Map<String, dynamic>> items, double amount,
      String method, String status, String? paymentId) async {
    await _firestore.collection("orders").add({
      "userId": _auth.currentUser?.uid,
      "items": items,
      "totalAmount": amount,
      "paymentMethod": method,
      "paymentStatus": status,
      "paymentId": paymentId,
      "createdAt": FieldValue.serverTimestamp()
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Save order in Firestore and get doc reference
    // Ensure each item has full details
    final orderItems = _checkoutItems.map((item) {
      return {
        "productId": item["productId"],
        "name": item["name"],         // ✅ now included
        "imageUrl": item["imageUrl"], // ✅ now included
        "price": item["price"],
        "qty": item["qty"],
      };
    }).toList();

    final docRef = await _firestore.collection("orders").add({
      "userId": _auth.currentUser?.uid,
      "items": orderItems, // ✅ save with details
      "totalAmount": _checkoutAmount,
      "paymentMethod": "Razorpay",
      "paymentStatus": "Success",
      "paymentId": response.paymentId,
      "createdAt": FieldValue.serverTimestamp()
    });

    // ✅ Navigate to success screen with Firestore orderId
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          orderDocId: docRef.id, // pass Firestore doc id
        ),
      ),
    );
  }


  void _handlePaymentError(PaymentFailureResponse response) async {
    await _createOrder(
        _checkoutItems, _checkoutAmount, "Razorpay", "Failed", null);

    // ✅ Navigate to failed screen
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => OrderFailedScreen(
          code: response.code,
          message: response.message ?? "Unknown error",
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet Selected: ${response.walletName}");
  }

  void dispose() {
    _razorpay.clear();
  }
}
