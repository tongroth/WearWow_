import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product.dart';
import '../../models/order.dart';
import '../../models/category.dart';
import '../../data/mock_data.dart'; // We share data with the main app

class AdminController extends GetxController {
  // Data Observables
  var products = <Product>[].obs;
  var orders = <Order>[].obs;
  var categories = <Category>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() {
    // In a real app, these would be API calls
    products.value = mockProducts;
    orders.value = mockOrders;
    categories.value = mockCategories;
  }

  // --- PRODUCT ACTIONS ---
  Future<void> addProduct(Product product) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    products.add(product);
    isLoading.value = false;
    Get.back();
    Get.snackbar("Success", "Product Added", backgroundColor: Colors.green.withOpacity(0.2));
  }

  Future<void> deleteProduct(String id) async {
    products.removeWhere((p) => p.id == id);
    Get.snackbar("Deleted", "Product removed");
  }

  // --- ORDER ACTIONS ---
  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final oldOrder = orders[index];
      // Create a copy with updated status
      orders[index] = Order(
          id: oldOrder.id,
          date: oldOrder.date,
          status: newStatus,
          total: oldOrder.total,
          itemCount: oldOrder.itemCount
      );
      orders.refresh();
      Get.snackbar("Updated", "Order status changed to ${newStatus.name}");
    }
  }

  // --- CATEGORY ACTIONS ---
  Future<void> addCategory(Category category) async {
    categories.add(category);
    Get.back(); // Assuming called from dialog
    Get.snackbar("Success", "Category Added");
  }
}