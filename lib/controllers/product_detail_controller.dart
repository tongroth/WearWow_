import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  // Observables
  var quantity = 1.obs;
  var selectedSize = 'M'.obs;
  var selectedColor = Colors.black.obs;
  var currentImageIndex = 0.obs;

  // Actions
  void selectSize(String size) => selectedSize.value = size;

  void selectColor(Color color) {
    selectedColor.value = color;
  }

  void updateImageIndex(int index) => currentImageIndex.value = index;

  void incrementQty() {
    if (quantity.value < 10) quantity.value++;
  }

  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }

  // Reset state when entering screen with a new product
  void initProduct(Color defaultColor) {
    selectedColor.value = defaultColor;
    quantity.value = 1;
    selectedSize.value = 'M';
    currentImageIndex.value = 0;
  }
}