import 'package:get/get.dart';
import '../model/banner.dart';
import '../service/remote_service.dart';

class BannerController extends GetxController {
  var bannerList = <BannerModel>[].obs;
  var imageList = <String>[].obs;
  var isLoading = true.obs;
  var currentIndex = 0.obs;

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  void fetchBanners() async {
    try {
      isLoading(true);
      var result = await RemoteBannerService.getBanner();
      if (result != null) {
        bannerList.assignAll(bannerFromJson(result));
        imageList.assignAll(bannerList.expand((b) => b.images));
      }
    } catch (e) {
      Get.snackbar('Koneksi gagal', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void updateIndex(int index) {
    currentIndex.value = index;
  }
}
