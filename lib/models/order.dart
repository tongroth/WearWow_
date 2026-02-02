enum OrderStatus { processing, shipped, delivered, cancelled }

class Order {
  final String id;
  final DateTime date;
  final OrderStatus status;
  final double total;
  final int itemCount;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.itemCount
  });
}