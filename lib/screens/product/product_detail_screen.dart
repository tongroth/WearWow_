import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../controllers/product_detail_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../widgets/cart_icon_button.dart';
import '../../models/product.dart';
import '../../core/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = Get.arguments as Product;
    final controller = Get.put(ProductDetailController());
    final cartController = Get.find<CartController>();

    // Initialize default color
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (product.colors.isNotEmpty) {
        controller.initProduct(product.colors.first);
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Image Gallery Header
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(LucideIcons.arrowLeft, color: Colors.black, size: 20),
              ),
              onPressed: () => Get.back(),
            ),
            actions: const [
              CartIconButton(),
              SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    itemCount: product.gallery.length,
                    onPageChanged: controller.updateImageIndex,
                    itemBuilder: (context, index) => Image.network(
                      product.gallery[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Image Dots
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(product.gallery.length, (index) => Obx(() => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: controller.currentImageIndex.value == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: controller.currentImageIndex.value == index ? Colors.white : Colors.white54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ))),
                    ),
                  )
                ],
              ),
            ),
          ),

          // 2. Product Info Body
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              transform: Matrix4.translationValues(0, -20, 0),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.1),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "\$${product.price}",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(" ${product.rating} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("(${120 + product.name.length} reviews)", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Color Selector
                  const Text("Select Color", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Obx(() => Row(
                    children: product.colors.map((color) {
                      final isSelected = controller.selectedColor.value == color;
                      return GestureDetector(
                        onTap: () => controller.selectColor(color),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: isSelected ? [
                                BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4))
                              ] : [],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),

                  const SizedBox(height: 24),

                  // Size Selector
                  const Text("Select Size", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Obx(() => Row(
                    children: product.sizes.map((size) {
                      final isSelected = controller.selectedSize.value == size;
                      return GestureDetector(
                        onTap: () => controller.selectSize(size),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.white,
                            border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),

                  const SizedBox(height: 24),

                  // Description
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    "Elevate your style with the ${product.name}. Crafted from premium materials, this piece offers both comfort and durability. Perfect for any occasion, whether you're dressing up for a night out or keeping it casual.",
                    style: const TextStyle(color: Colors.grey, height: 1.6),
                  ),

                  // Bottom Spacer
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. Bottom Action Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Quantity Selector
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.minus, size: 20),
                    onPressed: controller.decrementQty,
                    constraints: const BoxConstraints(minWidth: 40),
                  ),
                  Obx(() => Text(
                    "${controller.quantity.value}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                  IconButton(
                    icon: const Icon(LucideIcons.plus, size: 20),
                    onPressed: controller.incrementQty,
                    constraints: const BoxConstraints(minWidth: 40),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Add to Cart Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  cartController.addToCart(
                    product,
                    controller.selectedSize.value,
                    controller.selectedColor.value,
                    controller.quantity.value,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.shoppingBag, size: 20),
                    SizedBox(width: 8),
                    Text("Add to Cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}