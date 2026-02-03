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

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'status': status.name,
    'total': total,
    'itemCount': itemCount,
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'] ?? '',
    date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    status: OrderStatus.values.byName(json['status'] ?? 'processing'),
    total: (json['total'] ?? 0.0).toDouble(),
    itemCount: json['itemCount'] ?? 0,
  );
}