import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/admin_layout.dart';
import '../controllers/admin_controller.dart';
import '../../models/product.dart';

class AdminProductListScreen extends StatelessWidget {
  const AdminProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

    return AdminLayout(
      title: "Products",
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/admin/products/add'),
        backgroundColor: const Color(0xFFF42C8F),
        icon: const Icon(LucideIcons.plus, color: Colors.white),
        label: const Text("Add Product", style: TextStyle(color: Colors.white)),
      ),
      child: Column(
        children: [
          // 1. Search & Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.search, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search products...",
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: (val) {
                      // Implement filter logic in controller if needed
                    },
                  ),
                ),
                IconButton(icon: const Icon(LucideIcons.slidersHorizontal), onPressed: () {}),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Product Grid
          Expanded(
            child: Obx(() {
              if (controller.products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.packageOpen, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      const Text("No products found", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250, // Responsive card width
                  childAspectRatio: 0.75, // Taller cards for images
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  final product = controller.products[index];
                  return _AdminProductCard(
                    product: product,
                    onEdit: () {}, // Navigate to edit
                    onDelete: () => controller.deleteProduct(product.id),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _AdminProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AdminProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_,__,___) => Container(color: Colors.grey.shade100, child: const Icon(LucideIcons.image, color: Colors.grey)),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: PopupMenuButton(
                    icon: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: Icon(LucideIcons.moreVertical, size: 16, color: Colors.black),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: onEdit,
                        child: const Row(children: [Icon(LucideIcons.pencil, size: 16), SizedBox(width: 8), Text("Edit")]),
                      ),
                      PopupMenuItem(
                        onTap: onDelete,
                        child: const Row(children: [Icon(LucideIcons.trash2, size: 16, color: Colors.red), SizedBox(width: 8), Text("Delete", style: TextStyle(color: Colors.red))]),
                      ),
                    ],
                  ),
                ),
                if (product.isTrending)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                      child: const Text("Trending", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),

          // Details Area
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${product.price}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF42C8F))),
                    Text("Stock: 24", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)), // Mock stock
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}