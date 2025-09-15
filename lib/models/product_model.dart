// lib/models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final String? image;
  final double price;
  final String category;
  final DateTime? createdAt; // ✅ add createdAt field in model

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    this.createdAt,
  });

  /// Factory method to create Product from Firestore document
  factory Product.fromFirestore(Map<String, dynamic> data, String docId) {
    return Product(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      image: (data['image'] ?? '').toString().trim(),
      price: _toDouble(data['price']),
      category: data['category'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(), // ✅ convert timestamp
    );
  }

  /// Convert Product to Map (for uploading to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(), // ✅ always set timestamp
    };
  }

  /// Helper to handle price conversion safely
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
