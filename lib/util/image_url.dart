import '../const.dart';

String strapiImageUrl(dynamic media, {String? format}) {
  Map? img;
  if (media is List && media.isNotEmpty) img = media.first as Map?;
  if (media is Map) img = media;
  if (img == null) return '';

  final formats = img['formats'];
  final picked = (format != null && formats is Map && formats[format] is Map)
      ? formats[format]['url']
      : img['url'];

  var url = (picked ?? '') as String;
  if (url.isNotEmpty && !url.startsWith('http')) url = '$baseUrl$url';
  return url;
}
