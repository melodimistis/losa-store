import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/cart_controller.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({Key? key}) : super(key: key);

  final CartController cartController = Get.find<CartController>();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Pesanan'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alamat Pengiriman',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Masukkan alamat lengkap pengiriman...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Column(
                children: cartController.cartItems.map((item) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.product.name),
                    subtitle: Text(
                      '${item.quantity} x Rp ${item.product.price}',
                    ),
                    trailing: Text('Rp ${item.product.price * item.quantity}'),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => Text(
                    'Rp ${cartController.totalPrice}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => ElevatedButton(
            onPressed: cartController.isCheckingOut.value
                ? null
                : () async {
                    if (addressController.text.trim().isEmpty) {
                      Get.snackbar(
                        'Peringatan',
                        'Alamat pengiriman harus diisi.',
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    bool success = await cartController.processCheckout(
                      addressController.text,
                    );
                    if (success) {
                      Get.offAllNamed('/');
                      Get.snackbar(
                        'Sukses',
                        'Pesanan berhasil dibuat!',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        'Gagal',
                        'Gagal membuat pesanan. Cek koneksi anda.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: cartController.isCheckingOut.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Buat Pesanan Sekarang',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
