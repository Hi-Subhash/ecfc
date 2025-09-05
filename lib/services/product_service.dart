import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui';


class ProductService {
  final String baseUrl = "https://fakestoreapi.com"; // temporary API

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load products");
    }
  }

  Future<List<dynamic>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load category products");
    }
  }
}
