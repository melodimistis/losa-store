import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final _categoryBox = Hive.box('category_box');
  static final _productBox = Hive.box('product_box');

  static void saveCategories(String rawJson) {
    _categoryBox.put('data', rawJson);
  }

  static String? getCategories() {
    return _categoryBox.get('data');
  }

  static void saveProducts(String rawJson) {
    _productBox.put('data', rawJson);
  }

  static String? getProducts() {
    return _productBox.get('data');
  }
}
