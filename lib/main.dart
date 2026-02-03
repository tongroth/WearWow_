import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_2/screens/main_layout_screen.dart';
import 'package:test_2/screens/product/product_detail_screen.dart';
import 'package:test_2/screens/cart/cart_screen.dart';
import 'package:test_2/screens/categories/categories_screen.dart';
import 'package:test_2/screens/wishlist/wishlist_screen.dart';
import 'package:test_2/screens/profile/profile_screen.dart';
import 'package:test_2/screens/checkout/checkout_screen.dart';
import 'core/app_theme.dart';
import 'services/auth_service.dart';
import 'services/product_service.dart';
import 'services/order_service.dart';
import 'services/payment_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (will require platform-specific configuration files)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
    // Continue in Mock mode if Firebase fails
  }

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
      initialBinding: BindingsBuilder(() {
        // Switch between Mock and Firebase implementations here
        Get.put<AuthService>(MockAuthService());
        Get.put<ProductService>(MockProductService());
        Get.put<OrderService>(MockOrderService());
        Get.put<PaymentService>(MockPaymentService());
      }),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MainLayoutScreen()),
        GetPage(name: '/home', page: () => const MainLayoutScreen()),
        GetPage(name: '/product/:id', page: () => const ProductDetailScreen()),
        GetPage(name: '/cart', page: () => const CartScreen()),
        GetPage(name: '/categories', page: () => const CategoriesScreen()),
        GetPage(name: '/wishlist', page: () => const WishlistScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/checkout', page: () => const CheckoutScreen()),
      ],
    );
  }
}
