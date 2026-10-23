import 'package:get/get.dart';
import '../model/product.dart';
import '../service/remote_service.dart';

class CategoryProductController extends GetxController {
  var productList = <Product>[].obs;
  var isLoading = true.obs;

  void fetchProductsByCategory(int categoryId) async {
    try {
      isLoading(true);
      var result = await RemoteProductService.getProductsByCategory(categoryId);
      if (result != null) {
        productList.assignAll(productFromJson(result));
      } else {
        productList.clear();
      }
    } finally {
      isLoading(false);
    }
  }
}
