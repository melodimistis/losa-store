import 'package:get/get.dart';
import '../model/product.dart';
import '../service/remote_service.dart';
import '../service/hive_service.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;
  var isLoading = true.obs;

  final searchQuery = ''.obs;
  int _searchId = 0;

  @override
  void onInit() {
    fetchProducts();
    debounce(
      searchQuery,
      searchProducts,
      time: const Duration(milliseconds: 400),
    );
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      var cachedData = HiveService.getProducts();
      if (cachedData != null) {
        productList.assignAll(productFromJson(cachedData));
        isLoading(false);
      }

      var result = await RemoteProductService.getProducts();
      if (result != null) {
        productList.assignAll(productFromJson(result));
        HiveService.saveProducts(result);
      }
    } catch (errorMessage) {
      if (productList.isEmpty) {
        Get.snackbar('Koneksi Gagal', errorMessage.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchProducts(String query) async {
    final myId = ++_searchId;
    final q = query.trim();

    if (q.isEmpty) {
      await fetchProducts();
      return;
    }

    try {
      final result = await RemoteProductService.searchProducts(q);

      if (myId != _searchId) return;

      if (result != null) {
        productList.assignAll(productFromJson(result));
      } else {
        productList.clear();
      }
    } catch (e) {
      if (myId == _searchId) Get.snackbar('Koneksi gagal', e.toString());
    }
  }
}
