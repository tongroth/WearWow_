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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'originalPrice': originalPrice,
    'image': image,
    'gallery': gallery,
    'category': category,
    'rating': rating,
    'isNew': isNew,
    'isTrending': isTrending,
    'sizes': sizes,
    'colors': colors.map((c) => c.toARGB32()).toList(),
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    price: (json['price'] ?? 0.0).toDouble(),
    originalPrice: json['originalPrice'] != null ? (json['originalPrice'] as num).toDouble() : null,
    image: json['image'] ?? '',
    gallery: List<String>.from(json['gallery'] ?? []),
    category: json['category'] ?? '',
    rating: (json['rating'] ?? 0.0).toDouble(),
    isNew: json['isNew'] ?? false,
    isTrending: json['isTrending'] ?? false,
    sizes: List<String>.from(json['sizes'] ?? []),
    colors: (json['colors'] as List?)?.map((c) => Color(c as int)).toList() ?? [],
  );
}
