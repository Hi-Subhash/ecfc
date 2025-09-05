import 'package:flutter/material.dart';

class WishlistService extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addItem(Map<String, dynamic> product) {
    if (!_items.any((item) => item['title'] == product['title'])) {
      _items.add(product);
      notifyListeners();
    }
  }

  void removeItem(Map<String, dynamic> product) {
    _items.remove(product);
    notifyListeners();
  }
}
