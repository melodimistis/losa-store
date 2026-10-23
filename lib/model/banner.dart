import 'dart:convert';
import '../const.dart';

List<BannerModel> bannerFromJson(String str) => List<BannerModel>.from(
  json.decode(str)['data'].map((x) => BannerModel.fromJson(x)),
);

class BannerModel {
  final int id;
  final String title;
  final List<String> images;

  BannerModel({required this.id, required this.title, required this.images});

  factory BannerModel.fromJson(Map<String, dynamic> data) {
    List<String> imageList = [];

    if (data['image'] != null && data['image'] is List) {
      for (var img in data['image']) {
        String url = img['url'] ?? '';
        if (url.isNotEmpty && !url.startsWith('http')) {
          url = '$baseUrl$url';
        }
        if (url.isNotEmpty) {
          imageList.add(url);
        }
      }
    }

    return BannerModel(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      images: imageList,
    );
  }
}
