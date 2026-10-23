import 'dart:convert';
import '../const.dart';

List<Category> categoryFromJson(String str) => List<Category>.from(
  json.decode(str)['data'].map((x) => Category.fromJson(x)),
);

class Category {
  final int id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> data) {
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

    return Category(
      id: data['id'] ?? 0,
      name: data['title'] ?? data['name'] ?? '',
      image: imageUrl,
    );
  }
}
