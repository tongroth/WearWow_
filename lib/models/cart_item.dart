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
}
