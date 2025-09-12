import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutService {
  final _razorpay = Razorpay();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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

    _razorpay.open(options);

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
            (PaymentSuccessResponse response) {
          _createOrder(items, amount, "Razorpay", "Success", response.paymentId);
        });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
            (PaymentFailureResponse response) {
          _createOrder(items, amount, "Razorpay", "Failed", null);
        });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
            (ExternalWalletResponse response) {
          // handle wallet payments
        });
  }

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

  void dispose() {
    _razorpay.clear();
  }
}

//
// Future<void> createCodOrder(
//     List<Map<String, dynamic>> items, double amount) async {
//   await _firestore.collection("orders").add({
//     "userId": _auth.currentUser?.uid,
//     "items": items,
//     "totalAmount": amount,
//     "paymentMethod": "COD",
//     "paymentStatus": "Pending",
//     "createdAt": FieldValue.serverTimestamp()
//   });
// }
