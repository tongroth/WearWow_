import 'package:flutter/material.dart';
import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final String selectedSize;
  final Color selectedColor;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() => {
    'id': id,
    'product': product.toJson(),
    'selectedSize': selectedSize,
    'selectedColor': selectedColor.toARGB32(),
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'] ?? '',
    product: Product.fromJson(json['product'] ?? {}),
    selectedSize: json['selectedSize'] ?? '',
    selectedColor: Color(json['selectedColor'] ?? 0xFF000000),
    quantity: json['quantity'] ?? 1,
  );
}
