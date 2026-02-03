import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/dashboard_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/order_list_screen.dart';
import 'screens/category_list_screen.dart';
import 'controllers/admin_controller.dart';
import 'controllers/order_list_controller.dart';
import '../core/app_theme.dart';

void main() {
  runApp(const WearWowAdminApp());
}

class WearWowAdminApp extends StatelessWidget {
  const WearWowAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WearWow Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light.copyWith(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: AppTheme.light.appBarTheme.copyWith(
          backgroundColor: Colors.white,
          centerTitle: false,
          elevation: 1,
        ),
      ),
      // FIX: Initialize AdminController once globally and keep it alive
      initialBinding: BindingsBuilder(() {
        Get.put(AdminController(), permanent: true);
      }),
      initialRoute: '/admin/dashboard',
      getPages: [
        GetPage(
          name: '/admin/dashboard',
          page: () => const AdminDashboardScreen(),
        ),
        GetPage(
          name: '/admin/products',
          page: () => const AdminProductListScreen(),
        ),
        GetPage(
          name: '/admin/products/add',
          page: () => const AddProductScreen(),
        ),
        GetPage(
          name: '/admin/products/edit',
          page: () => const AddProductScreen(),
        ),
        GetPage(
          name: '/admin/orders',
          page: () => const AdminOrderListScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => OrderListController()); // Specific logic for order UI
          }),
        ),
        GetPage(
          name: '/admin/categories',
          page: () => const AdminCategoryListScreen(),
        ),
        GetPage(
          name: '/admin/settings',
          page: () => Scaffold(
            appBar: AppBar(title: const Text("Settings")),
            body: const Center(child: Text("Admin Settings - Coming Soon")),
          ),
        ),
        GetPage(
          name: '/login',
          page: () => Scaffold(
            appBar: AppBar(title: const Text("Login")),
            body: const Center(child: Text("Login Screen - Coming Soon")),
          ),
        ),
      ],
    );
  }
}