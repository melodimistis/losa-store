import 'package:get/get.dart';
import '../model/product.dart';
import '../service/remote_service.dart';
import '../service/hive_service.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var cachedData = HiveService.getProducts();
      if (cachedData != null) {
        productList.assignAll(productFromJson(cachedData));
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

  void searchProducts(String query) async {
    try {
      isLoading(true);
      if (query.trim().isEmpty) {
        fetchProducts();
      } else {
        var result = await RemoteProductService.searchProducts(query);
        if (result != null) {
          productList.assignAll(productFromJson(result));
        } else {
          productList.clear();
        }
      }
    } catch (e) {
      print("Error pencarian: $e");
    } finally {
      isLoading(false);
    }
  }
}
