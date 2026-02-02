import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/admin_layout.dart';
import '../controllers/admin_controller.dart';
import '../../models/category.dart';

class AdminCategoryListScreen extends StatelessWidget {
  const AdminCategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

    return AdminLayout(
      title: "Categories",
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryDialog(context),
        backgroundColor: const Color(0xFFF42C8F),
        icon: const Icon(LucideIcons.plus, color: Colors.white),
        label: const Text("New Category", style: TextStyle(color: Colors.white)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Product Categories",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Obx(() {
              if (controller.categories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.layoutGrid, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      const Text("No categories created yet", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 350,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return _CategoryAdminCard(
                    category: category,
                    onEdit: () => _showCategoryDialog(context, category: category),
                    onDelete: () => _showDeleteConfirmation(category.id),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, {Category? category}) {
    final nameCtrl = TextEditingController(text: category?.name ?? "");
    final iconCtrl = TextEditingController(text: category?.icon ?? "");
    final imgCtrl = TextEditingController(text: category?.image ?? "");
    final controller = Get.find<AdminController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? "Add Category" : "Edit Category"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Category Name", hintText: "e.g. Summer Wear"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: iconCtrl,
                decoration: const InputDecoration(labelText: "Icon (Emoji)", hintText: "e.g. 👗"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imgCtrl,
                decoration: const InputDecoration(labelText: "Image URL", hintText: "https://..."),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty) return;

              final newCategory = Category(
                id: category?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameCtrl.text,
                icon: iconCtrl.text,
                image: imgCtrl.text.isNotEmpty ? imgCtrl.text : "https://via.placeholder.com/300",
                subcategories: category?.subcategories ?? [],
              );

              if (category == null) {
                controller.addCategory(newCategory);
              } else {
                // Update logic: Replace the item in the list
                int idx = controller.categories.indexWhere((c) => c.id == category.id);
                if (idx != -1) {
                  controller.categories[idx] = newCategory;
                  controller.categories.refresh(); // Ensure UI updates
                }
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF42C8F), foregroundColor: Colors.white),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Category?"),
        content: const Text("This will remove the category from the app. Products linked to this category won't be deleted but might become harder to find."),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Get.find<AdminController>().categories.removeWhere((c) => c.id == id);
                Get.back();
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}

class _CategoryAdminCard extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryAdminCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          // Background Image with Darken Blend
          Positioned.fill(
            child: Image.network(
              category.image,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[300],
                child: const Icon(LucideIcons.image, color: Colors.grey, size: 40),
              ),
            ),
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(category.icon, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),

          // Actions
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                _CircleAction(icon: LucideIcons.pencil, color: Colors.blue, onTap: onEdit),
                const SizedBox(width: 8),
                _CircleAction(icon: LucideIcons.trash2, color: Colors.red, onTap: onDelete),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _CircleAction({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }
}// TODO Implement this library.