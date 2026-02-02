import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final String image;
  final List<String> gallery;
  final String category;
  final double rating;
  final bool isNew;
  final bool isTrending;
  final List<String> sizes;
  final List<Color> colors;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.image,
    List<String>? gallery,
    required this.category,
    this.rating = 0.0,
    this.isNew = false,
    this.isTrending = false,
    this.sizes = const ['S', 'M', 'L', 'XL'],
    this.colors = const [Colors.black, Colors.white, Color(0xFFF42C8F)],
  }) : gallery = gallery ?? [image, image, image];
}
