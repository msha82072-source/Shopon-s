import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(ProductModel product, ProductVariant? variant, int quantity) {
    // Check if item with same variant already exists
    final index = items.indexWhere(
        (item) => item.product.id == product.id && item.variant?.id == variant?.id);

    if (index != -1) {
      items[index].quantity += quantity;
      items.refresh();
    } else {
      items.add(CartItemModel(
        product: product,
        variant: variant,
        quantity: quantity,
      ));
    }
    
    Get.snackbar(
      'SUCCESS',
      'Item added to your bag',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFFD700),
      colorText: Colors.black,
    );
  }

  void removeFromCart(CartItemModel item) {
    items.remove(item);
  }

  void updateQuantity(CartItemModel item, int delta) {
    final newQuantity = item.quantity + delta;
    if (newQuantity > 0) {
      item.quantity = newQuantity;
      items.refresh();
    }
  }

  void clearCart() {
    items.clear();
  }
}
