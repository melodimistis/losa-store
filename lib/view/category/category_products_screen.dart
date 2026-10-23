import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/category_product_controller.dart';
import '../../model/category.dart';
import '../product/product_detail_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final Category category;

  CategoryProductsScreen({Key? key, required this.category}) : super(key: key);

  final CategoryProductController controller = Get.put(
    CategoryProductController(),
  );

  @override
  Widget build(BuildContext context) {
    controller.fetchProductsByCategory(category.id);

    return Scaffold(
      appBar: AppBar(title: Text(category.name), backgroundColor: Colors.green),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.productList.isEmpty) {
          return const Center(child: Text('Belum ada produk di kategori ini'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.productList.length,
          itemBuilder: (context, index) {
            var product = controller.productList[index];
            return InkWell(
              onTap: () {
                Get.to(() => ProductDetailScreen(product: product));
              },
              child: Card(
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: product.image.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: product.image,
                                httpHeaders: const {
                                  'ngrok-skip-browser-warning': 'true',
                                },
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                              )
                            : const Icon(
                                Icons.shopping_bag,
                                size: 50,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rp ${product.price}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
