import 'package:get/get.dart';
import '../model/product.dart';
import '../service/remote_service.dart';

class CategoryProductController extends GetxController {
  final int categoryId;

  CategoryProductController(this.categoryId);

  var productList = <Product>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductsByCategory(categoryId);
  }

  void fetchProductsByCategory(int id) async {
    try {
      isLoading(true);
      var result = await RemoteProductService.getProductsByCategory(id);
      if (result != null) {
        productList.assignAll(productFromJson(result));
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
