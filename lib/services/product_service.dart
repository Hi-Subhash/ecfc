import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart'; // ✅ added import

class ProductService {
  final String baseUrl = "https://fakestoreapi.com"; // temporary API

  // ❌ Old: Future<List<dynamic>> fetchProducts()
  // ✅ New:
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      // ✅ Convert each JSON item into Product
      return data.map((item) => Product.fromFirestore(item, item['id'].toString())).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  // ❌ Old: Future<List<dynamic>> fetchProductsByCategory(String category)
  // ✅ New:
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      // ✅ Convert each JSON item into Product
      return data.map((item) => Product.fromFirestore(item, item['id'].toString())).toList();
    } else {
      throw Exception("Failed to load category products");
    }
  }
}





// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:ui';
// import '../models/product_model.dart';
//
//
// class ProductService {
//   final String baseUrl = "https://fakestoreapi.com"; // temporary API
//
//   Future<List<dynamic>> fetchProducts() async {
//     final response = await http.get(Uri.parse('$baseUrl/products'));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to load products");
//     }
//   }
//
//   Future<List<dynamic>> fetchProductsByCategory(String category) async {
//     final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to load category products");
//     }
//   }
// }
