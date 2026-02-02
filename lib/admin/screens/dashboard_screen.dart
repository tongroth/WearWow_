import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/admin_layout.dart';
import '../controllers/admin_controller.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

    return AdminLayout(
      title: "Dashboard",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Overview", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              // Prepare data list for cleaner grid building
              final stats = [
                _StatData(
                  title: "Total Sales",
                  value: "\$${controller.orders.fold<double>(0, (sum, item) => sum + item.total).toStringAsFixed(2)}",
                  icon: LucideIcons.dollarSign,
                  color: Colors.green,
                ),
                _StatData(
                  title: "Total Orders",
                  value: "${controller.orders.length}",
                  icon: LucideIcons.shoppingBag,
                  color: Colors.blue,
                ),
                _StatData(
                  title: "Products",
                  value: "${controller.products.length}",
                  icon: LucideIcons.package,
                  color: Colors.orange,
                ),
                _StatData(
                  title: "Categories",
                  value: "${controller.categories.length}",
                  icon: LucideIcons.layoutGrid,
                  color: Colors.purple,
                ),
              ];

              return GridView.builder(
                itemCount: stats.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300, // Cards won't get wider than 300px
                  childAspectRatio: 1.0,   // Adjusted from 1.4 to 1.0 to prevent overflow on smaller screens
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return _buildStatCard(stats[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(_StatData data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Reduced padding to save space
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: data.color.withOpacity(0.1),
              radius: 24,
              child: Icon(data.icon, color: data.color, size: 24),
            ),
            const SizedBox(height: 16),
            FittedBox( // Prevents text overflow on small screens
              fit: BoxFit.scaleDown,
              child: Text(
                data.value,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: data.color),
              ),
            ),
            const SizedBox(height: 8),
            Text(data.title, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// Simple helper class for cleaner code
class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  _StatData({required this.title, required this.value, required this.icon, required this.color});
}