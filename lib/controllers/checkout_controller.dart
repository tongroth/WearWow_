import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/payment_service.dart';
import '../services/order_service.dart';
import '../controllers/cart_controller.dart';
import '../models/order.dart';

class CheckoutController extends GetxController {
  final PaymentService _paymentService = Get.find<PaymentService>();
  final OrderService _orderService = Get.find<OrderService>();
  final CartController _cartController = Get.find<CartController>();

  var isProcessing = false.obs;

  Future<void> processCheckout() async {
    if (_cartController.cartItems.isEmpty) return;

    isProcessing.value = true;
    try {
      final total = _cartController.totalAmount;
      final success = await _paymentService.processPayment(total);

      if (success) {
        final newOrder = Order(
          id: '#ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          date: DateTime.now(),
          status: OrderStatus.processing,
          total: total,
          itemCount: _cartController.itemCount,
        );

        await _orderService.placeOrder(newOrder);

        // Clear cart
        _cartController.cartItems.clear();

        Get.offAllNamed('/');
        Get.snackbar(
          "Success",
          "Your order has been placed successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Payment Failed",
          "Please try again or use a different payment method.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isProcessing.value = false;
    }
  }
}
