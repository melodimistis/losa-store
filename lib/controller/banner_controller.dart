import 'package:get/get.dart';
import '../model/banner.dart';
import '../service/remote_service.dart';

class BannerController extends GetxController {
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
        var banners = bannerFromJson(result);
        List<String> tempImages = [];

        for (var banner in banners) {
          tempImages.addAll(banner.images);
        }

        imageList.assignAll(tempImages);
      }
    } finally {
      isLoading(false);
    }
  }

  void updateIndex(int index) {
    currentIndex.value = index;
  }
}
