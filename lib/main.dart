import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_2/screens/main_layout_screen.dart';
import 'package:test_2/screens/product/product_detail_screen.dart';
import 'package:test_2/screens/cart/cart_screen.dart';
import 'package:test_2/screens/categories/categories_screen.dart';
import 'package:test_2/screens/wishlist/wishlist_screen.dart';
import 'package:test_2/screens/profile/profile_screen.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const WearWowApp());
}

class WearWowApp extends StatelessWidget {
  const WearWowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WearWow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MainLayoutScreen()),
        GetPage(name: '/home', page: () => const MainLayoutScreen()),
        GetPage(name: '/product/:id', page: () => const ProductDetailScreen()),
        GetPage(name: '/cart', page: () => const CartScreen()),
        GetPage(name: '/categories', page: () => const CategoriesScreen()),
        GetPage(name: '/wishlist', page: () => const WishlistScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
      ],
    );
  }
}
