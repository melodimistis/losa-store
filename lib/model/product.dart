import 'dart:convert';
import '../const.dart';

List<Product> productFromJson(String str) => List<Product>.from(
  json.decode(str)['data'].map((x) => Product.fromJson(x)),
);

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> data) {
    String imageUrl = '';

    if (data['image'] != null &&
        data['image'] is List &&
        data['image'].isNotEmpty) {
      imageUrl = data['image'][0]['url'] ?? '';
    } else if (data['image'] != null && data['image'] is Map) {
      imageUrl = data['image']['url'] ?? '';
    }

    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      imageUrl = '$baseUrl$imageUrl';
    }

    return Product(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      image: imageUrl,
    );
  }
}
