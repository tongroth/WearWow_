import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product.dart';
import '../../models/order.dart';
import '../../models/category.dart';
import '../../services/product_service.dart';
import '../../services/order_service.dart';

class AdminController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final OrderService _orderService = Get.find<OrderService>();

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

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      products.value = await _productService.getProducts();
      orders.value = await _orderService.getOrders();
      categories.value = await _productService.getCategories();
    } finally {
      isLoading.value = false;
    }
  }

  // --- PRODUCT ACTIONS ---
  Future<void> addProduct(Product product) async {
    isLoading.value = true;
    await _productService.addProduct(product);
    products.value = await _productService.getProducts();
    isLoading.value = false;
    Get.back();
    Get.snackbar("Success", "Product Added", backgroundColor: Colors.green.withValues(alpha: 0.2));
  }

  Future<void> updateProduct(Product product) async {
    isLoading.value = true;
    await _productService.updateProduct(product);
    products.value = await _productService.getProducts();
    isLoading.value = false;
    Get.back();
    Get.snackbar("Success", "Product Updated", backgroundColor: Colors.blue.withValues(alpha: 0.2));
  }

  Future<void> deleteProduct(String id) async {
    await _productService.deleteProduct(id);
    products.value = await _productService.getProducts();
    Get.snackbar("Deleted", "Product removed");
  }

  // --- ORDER ACTIONS ---
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await _orderService.updateOrderStatus(orderId, newStatus);
    orders.value = await _orderService.getOrders();
    Get.snackbar("Updated", "Order status changed to ${newStatus.name}");
  }

  // --- CATEGORY ACTIONS ---
  Future<void> addCategory(Category category) async {
    await _productService.addCategory(category);
    categories.value = await _productService.getCategories();
    Get.back();
    Get.snackbar("Success", "Category Added");
  }
}