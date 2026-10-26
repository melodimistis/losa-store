import 'dart:convert';
import '../util/image_url.dart';

List<BannerModel> bannerFromJson(String str) => List<BannerModel>.from(
  json.decode(str)['data'].map((x) => BannerModel.fromJson(x)),
);

class BannerModel {
  final int id;
  final String title;
  final List<String> images;

  BannerModel({required this.id, required this.title, required this.images});

  factory BannerModel.fromJson(Map<String, dynamic> data) {
    final images = <String>[];
    final media = data['image'];

    if (media is List) {
      for (final img in media) {
        final url = strapiImageUrl(img, format: 'medium');
        if (url.isNotEmpty) images.add(url);
      }
    }

    return BannerModel(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      images: images,
    );
  }
}
