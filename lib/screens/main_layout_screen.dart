import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_2/screens/categories/categories_screen.dart';
import 'package:test_2/screens/home/home_screen.dart';
import 'package:test_2/screens/profile/profile_screen.dart';
import 'package:test_2/screens/wishlist/wishlist_screen.dart';
import '../controllers/main_layout_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';

import 'package:lucide_icons/lucide_icons.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainLayoutController());
    Get.put(CartController());
    if (!Get.isRegistered<WishlistController>()) {
      Get.put(WishlistController());
    }

    final List<Widget> pages = [
      const HomeScreen(),
      const CategoriesScreen(),
      const WishlistScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(() => Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changeTabIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(LucideIcons.layoutGrid), label: 'Categories'),
                BottomNavigationBarItem(icon: Icon(LucideIcons.heart), label: 'Wishlist'),
                BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profile'),
              ],
            ),
          )),
    );
  }
}
