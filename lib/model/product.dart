import 'dart:convert';
import '../util/image_url.dart';

List<Product> productFromJson(String str) => List<Product>.from(
  json.decode(str)['data'].map((x) => Product.fromJson(x)),
);

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String thumb;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.thumb,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    name: (json['name'] ?? '') as String,
    description: (json['description'] ?? '') as String,
    price: num.tryParse('${json['price']}')?.toDouble() ?? 0.0,
    image: strapiImageUrl(json['image']),
    thumb: strapiImageUrl(json['image'], format: 'small'),
  );
}
