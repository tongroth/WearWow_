import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/cart_icon_button.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_skeleton.dart';
import '../../data/mock_data.dart';
import '../../core/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. App Bar with Logo & Actions
          SliverAppBar(
            floating: true,
            //pinned: true, // Keep it pinned for better UX
            backgroundColor: AppTheme.backgroundColor,
            title: Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text("W", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFF42C8F), Color(0xFFFFD500)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    "WearWow",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white, // Required for ShaderMask to work properly
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(icon: const Icon(LucideIcons.search), onPressed: () {}),
              IconButton(icon: const Icon(LucideIcons.bell), onPressed: () {}),
              const CartIconButton(),
              const SizedBox(width: 8),
            ],
          ),

          // 2. Search Bar Area
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search fashion...",
                  prefixIcon: const Icon(LucideIcons.search, size: 20, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),

          // 3. Hero Section (Banner)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF42C8F), Color(0xFFFFD500)], // Pink to Yellow
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -20, right: -20,
                    child: CircleAvatar(radius: 50, backgroundColor: Colors.white.withValues(alpha: 0.2)),
                  ),
                  Positioned(
                    bottom: -40, left: 40,
                    child: CircleAvatar(radius: 40, backgroundColor: Colors.white.withValues(alpha: 0.2)),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text("New Arrival", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        const SizedBox(height: 8),
                        const Text("Summer\nCollection", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.1)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            minimumSize: Size.zero, // Remove default min size
                          ),
                          child: const Text("Shop Now", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  // Image (Right Side)
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=300",
                        height: 160,
                        //width: double.infinity, // optional, helps the clip look consistent
                        fit: BoxFit.cover,      // usually nicer than contain for rounded corners
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  )
                ],
              ),
            ).animate().fadeIn().scale(delay: 200.ms),
          ),

          // 4. Category Chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 60,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                separatorBuilder: (_,__) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return Obx(() {
                    final isSelected = controller.selectedCategoryIndex.value == index;
                    return GestureDetector(
                      onTap: () => controller.selectCategory(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          controller.categories[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),

          // 5. Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Popular Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () {},
                      child: const Text("See All", style: TextStyle(color: Colors.grey))
                  ),
                ],
              ),
            ),
          ),

          // 6. Product Grid (Using the existing mock data)
          Obx(() {
            if (controller.isLoading.value) {
              return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => const ProductSkeleton(),
                  childCount: 4,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68, // Slightly taller for better layout
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = mockProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () => Get.toNamed('/product/${product.id}', arguments: product),
                    );
                  },
                  childCount: mockProducts.length,
                ),
              ),
            );
          }),

          // 7. Bottom Spacer for Navigation Bar
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}