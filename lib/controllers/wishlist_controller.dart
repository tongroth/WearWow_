import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistController extends GetxController {
  var wishlistItems = <Product>[].obs;

  bool isFavorite(String productId) {
    return wishlistItems.any((p) => p.id == productId);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      wishlistItems.removeWhere((p) => p.id == product.id);
    } else {
      wishlistItems.add(product);
      Get.snackbar(
        "Saved",
        "Added to wishlist",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
    wishlistItems.refresh();
  }
}
