import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class WishlistService with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void addItem(Product product) {
    if (!_items.contains(product)) {
      _items.add(product);
      notifyListeners();
    }
  }

  void removeItem(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  bool isInWishlist(Product product) {
    return _items.contains(product);
  }
}





// import 'package:flutter/material.dart';
//
// class WishlistService extends ChangeNotifier {
//   final List<Map<String, dynamic>> _items = [];
//
//   List<Map<String, dynamic>> get items => _items;
//
//   void addItem(Map<String, dynamic> product) {
//     if (!_items.any((item) => item['title'] == product['title'])) {
//       _items.add(product);
//       notifyListeners();
//     }
//   }
//
//   void removeItem(Map<String, dynamic> product) {
//     _items.remove(product);
//     notifyListeners();
//   }
// }
