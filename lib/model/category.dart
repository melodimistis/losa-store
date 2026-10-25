import 'dart:convert';
import '../util/image_url.dart';

List<Category> categoryFromJson(String str) => List<Category>.from(
  json.decode(str)['data'].map((x) => Category.fromJson(x)),
);

class Category {
  final int id;
  final String name;
  final String image;
  final String thumb;

  Category({
    required this.id,
    required this.name,
    required this.image,
    this.thumb = '',
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] as int,
    name: (json['title'] ?? '') as String,
    image: strapiImageUrl(json['image']),
    thumb: strapiImageUrl(json['image'], format: 'thumbnail'),
  );
}
