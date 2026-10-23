import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../const.dart';

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

class RemoteCategoryService {
  static var client = http.Client();

  static Future<dynamic> getCategories() async {
    var response = await client.get(
      Uri.parse('$baseUrl/api/categories?populate=*'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
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

class RemoteProductService {
  static var client = http.Client();

  static Future<dynamic> getProducts() async {
    var response = await client.get(
      Uri.parse('$baseUrl/api/products?populate=*'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  static Future<dynamic> getProductsByCategory(int categoryId) async {
    var response = await client.get(
      Uri.parse(
        '$baseUrl/api/products?filters[category][id][\$eq]=$categoryId&populate=*',
      ),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  static Future<dynamic> searchProducts(String query) async {
    var response = await client.get(
      Uri.parse(
        '$baseUrl/api/products?filters[name][\$containsi]=$query&populate=*',
      ),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }
}

class RemoteBannerService {
  static var client = http.Client();

  static Future<dynamic> getBanner() async {
    var response = await client.get(
      Uri.parse('$baseUrl/api/banners?populate=*'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }
}
