class Product {
  final String id;
  final String title;
  final String price;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'image': image,
      'description': description,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      title: map['title'],
      price: map['price'],
      image: map['image'],
      description: map['description'],
    );
  }
}
