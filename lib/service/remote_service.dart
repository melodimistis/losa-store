import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../const.dart';

const _timeout = Duration(seconds: 30);

Future<String?> getJson(Uri uri) async {
  try {
    final res = await http.get(uri).timeout(_timeout);
    return res.statusCode == 200 ? res.body : null;
  } on SocketException {
    throw 'Tidak ada koneksi internet. Mohon cek jaringan kamu.';
  } on TimeoutException {
    throw 'Server mengalami kelambatan dalam merespon. Mohon untuk menunggu.';
  }
}

Uri apiUri(String path, [Map<String, String>? query]) =>
    Uri.parse('$baseUrl$path').replace(queryParameters: query);

class RemoteCategoryService {
  static Future<String?> getCategories() =>
      getJson(apiUri('/api/categories', {'populate': '*'}));
}

class RemoteBannerService {
  static Future<String?> getBanner() =>
      getJson(apiUri('/api/banners', {'populate': '*'}));
}

class RemoteProductService {
  static const _page = {'populate': '*', 'pagination[pageSize]': '100'};

  static Future<String?> getProducts() =>
      getJson(apiUri('/api/products', _page));

  static Future<String?> getProductsByCategory(int categoryId) => getJson(
    apiUri('/api/products', {
      ..._page,
      'filters[category][id][\$eq]': '$categoryId',
    }),
  );

  static Future<String?> searchProducts(String query) => getJson(
    apiUri('/api/products', {..._page, 'filters[name][\$contains]': query}),
  );
}

Future<http.Response?> fetchData(String endpoint) async {
  try {
    final response = await http
        .get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {'ngrok-skip-browser-warning': 'true'},
        )
        .timeout(const Duration(seconds: 10));

    return response;
  } on SocketException {
    throw 'Tidak ada koneksi internet. Cek jaringan kamu.';
  } on TimeoutException {
    throw 'Koneksi ke server lambat. Silahkan coba lagi.';
  } catch (e) {
    throw 'Terjadi kesalahan: $e';
  }
}

class RemoteOrderService {
  static var client = http.Client();

  static Future<bool> createOrder({
    required List<Map<String, dynamic>> items,
    required double totalPrice,
    required String address,
  }) async {
    try {
      var response = await client.post(
        Uri.parse('$baseUrl/api/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'data': {
            'items': items,
            'total_price': totalPrice,
            'address': address,
            'status_checkout': 'pending',
          },
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error create order: $e");
      return false;
    }
  }
}
