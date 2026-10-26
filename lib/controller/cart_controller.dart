import 'package:get/get.dart';
import '../service/remote_service.dart';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/cart_item.dart';
import '../model/product.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var isCheckingOut = false.obs;
  late Box cartBox;

  void clearCart() {
    cartItems.clear();
    cartBox.delete('items');
  }

  Future<String?> processCheckout(String address) async {
    if (cartItems.isEmpty) return 'Keranjang masih kosong.';
    if (address.trim().isEmpty) return 'Alamat pengiriman harus diisi.';

    try {
      isCheckingOut(true);

      final itemsJson = cartItems.map((item) {
        return {
          'product_id': item.product.id,
          'name': item.product.name,
          'price': item.product.price,
          'quantity': item.quantity,
        };
      }).toList();

      await RemoteOrderService.createOrder(
        items: itemsJson,
        totalPrice: totalPrice,
        address: address.trim(),
      );

      clearCart();
      return null;
    } catch (e) {
      return e is String ? e : 'Terjadi kesalahan.';
    } finally {
      isCheckingOut(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    cartBox = Hive.box('cart_box');
    loadCart();
  }

  double get totalPrice => cartItems.fold(
    0,
    (sum, item) => sum + item.product.price * item.quantity,
  );

  int get totalCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(Product product) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product));
    }
    saveCart();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      cartItems.refresh();
    } else {
      cartItems.remove(item);
    }
    saveCart();
  }

  void removeFromCart(CartItem item) {
    cartItems.remove(item);
    saveCart();
  }

  void saveCart() {
    List<Map<String, dynamic>> rawList = cartItems.map((item) {
      return {
        'product_id': item.product.id,
        'name': item.product.name,
        'price': item.product.price,
        'image': item.product.image,
        'quantity': item.quantity,
      };
    }).toList();

    cartBox.put('items', jsonEncode(rawList));
  }

  void loadCart() {
    try {
      final raw = cartBox.get('items');
      if (raw == null) return;
      final list = jsonDecode(raw) as List;
      cartItems.assignAll(
        list.map(
          (d) => CartItem(
            product: Product(
              id: d['product_id'] as int,
              name: (d['name'] ?? '') as String,
              price: (d['price'] as num).toDouble(),
              description: '',
              image: (d['image'] ?? '') as String,
              thumb: (d['image'] ?? ''),
            ),
          ),
        ),
      );
    } catch (_) {
      cartBox.delete('items');
    }
  }
}
