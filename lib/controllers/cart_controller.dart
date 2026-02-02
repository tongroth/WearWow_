import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  // Initialize and register the controller
  static CartController get to => Get.find();
  double get totalAmount =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(Product product, String size, Color color, int quantity) {
    final cartId = "${product.id}-$size-${color.value}";
    final index = cartItems.indexWhere((item) => item.id == cartId);

    if (index >= 0) {
      cartItems[index].quantity += quantity;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          id: cartId,
          product: product,
          selectedSize: size,
          selectedColor: color,
          quantity: quantity,
        ),
      );
    }

    Get.snackbar(
      "Added to Cart",
      "$quantity x ${product.name}",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void incrementItem(CartItem item) {
    item.quantity++;
    cartItems.refresh();
  }

  void decrementItem(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      cartItems.refresh();
    } else {
      cartItems.remove(item);
    }
  }
}
