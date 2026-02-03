import 'package:get/get.dart';
import '../models/order.dart';
import '../data/mock_data.dart';

abstract class OrderService extends GetxService {
  Future<List<Order>> getOrders();
  Future<void> placeOrder(Order order);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
}

class MockOrderService extends OrderService {
  final _orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    _orders.value = List.from(mockOrders);
  }

  @override
  Future<List<Order>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _orders;
  }

  @override
  Future<void> placeOrder(Order order) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _orders.insert(0, order);
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final oldOrder = _orders[index];
      _orders[index] = Order(
        id: oldOrder.id,
        date: oldOrder.date,
        status: status,
        total: oldOrder.total,
        itemCount: oldOrder.itemCount,
      );
    }
  }
}

class FirebaseOrderService extends OrderService {
  @override
  Future<List<Order>> getOrders() async => [];
  @override
  Future<void> placeOrder(Order order) async {}
  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {}
}
