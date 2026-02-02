import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../controllers/cart_controller.dart';

class CartIconButton extends StatelessWidget {
  final Color iconColor;
  const CartIconButton({super.key, this.iconColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.find();

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(LucideIcons.shoppingBag, color: iconColor),
          onPressed: () => Get.toNamed('/cart'),
        ),
        Obx(() {
          if (controller.itemCount == 0) return const SizedBox.shrink();
          return Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${controller.itemCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
