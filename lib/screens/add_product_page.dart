import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firestore_product_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();

  final FirestoreProductService _firestoreService = FirestoreProductService();

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: '', // Firestore auto-generates
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        image: _imageController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0, // ✅ convert to double
        category: "General", // ✅ or add a TextField/dropdown for category
      );


      await _firestoreService.addProduct(product);

      if (mounted) {
        Navigator.pop(context); // go back to ShopPage
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter title" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: "Image URL"),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter image URL" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? "Enter price" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.save),
                label: const Text("Save Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
