import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartService with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void addItem(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.price);
  }

}




// import 'package:flutter/material.dart';
//
// class CartService extends ChangeNotifier {
//   final List<Map<String, dynamic>> _items = [];
//
//   List<Map<String, dynamic>> get items => _items;
//
//   void addItem(Map<String, dynamic> product) {
//     _items.add(product);
//     notifyListeners();
//   }
//
//   void removeItem(int index) {
//     _items.removeAt(index);
//     notifyListeners();
//   }
//
//   double get totalPrice =>
//       _items.fold(0, (sum, item) => sum + double.parse(item['price'].toString()));
// }
