import 'package:get/get.dart';
import '../model/category.dart';
import '../service/remote_service.dart';
import '../service/hive_service.dart';

class CategoryController extends GetxController {
  var categoryList = <Category>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      var cachedData = HiveService.getCategories();
      if (cachedData != null) {
        categoryList.assignAll(categoryFromJson(cachedData));
      }

      var result = await RemoteCategoryService.getCategories();
      if (result != null) {
        categoryList.assignAll(categoryFromJson(result));
        HiveService.saveCategories(result);
      }
    } catch (errorMessage) {
      if (categoryList.isEmpty) {
        Get.snackbar('Koneksi Gagal', errorMessage.toString());
      }
    } finally {
      isLoading(false);
    }
  }
}
