import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../widgets/admin_layout.dart';
import '../controllers/admin_controller.dart';
import '../controllers/order_list_controller.dart'; // Import the new controller
import '../../models/order.dart';

class AdminOrderListScreen extends StatelessWidget {
  const AdminOrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controllers via Get.find (bound in main_admin.dart)
    final OrderListController uiController = Get.find<OrderListController>();
    //final AdminController adminController = Get.find<AdminController>();
    final AdminController adminController = Get.find<AdminController>();

    return DefaultTabController(
      length: 5,
      child: AdminLayout(
        title: "Orders",
        child: Column(
          children: [
            // 1. Search Bar
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
                      controller: uiController.searchCtrl,
                      decoration: const InputDecoration(
                        hintText: "Search by Order ID...",
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: (val) => uiController.searchQuery.value = val,
                    ),
                  ),
                  Obx(() => uiController.searchQuery.value.isNotEmpty
                      ? IconButton(
                    icon: const Icon(LucideIcons.x, size: 16),
                    onPressed: uiController.clearSearch,
                  )
                      : const SizedBox.shrink()),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Status Tabs
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const TabBar(
                labelColor: Color(0xFFF42C8F),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFFF42C8F),
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: "All Orders"),
                  Tab(text: "Processing"),
                  Tab(text: "Shipped"),
                  Tab(text: "Delivered"),
                  Tab(text: "Cancelled"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Order List
            Expanded(
              child: TabBarView(
                children: [
                  _buildOrderList(null, adminController, uiController), // All
                  _buildOrderList(OrderStatus.processing, adminController, uiController),
                  _buildOrderList(OrderStatus.shipped, adminController, uiController),
                  _buildOrderList(OrderStatus.delivered, adminController, uiController),
                  _buildOrderList(OrderStatus.cancelled, adminController, uiController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(OrderStatus? filterStatus, AdminController adminController, OrderListController uiController) {
    return Obx(() {
      // 1. Filter by Status
      var filteredOrders = filterStatus == null
          ? adminController.orders
          : adminController.orders.where((o) => o.status == filterStatus).toList();

      // 2. Filter by Search Query
      if (uiController.searchQuery.value.isNotEmpty) {
        final query = uiController.searchQuery.value.toLowerCase();
        filteredOrders = filteredOrders.where((o) => o.id.toLowerCase().contains(query)).toList();
      }

      if (filteredOrders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.searchX, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              const Text("No orders found", style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }

      return ListView.separated(
        itemCount: filteredOrders.length,
        separatorBuilder: (_,__) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return _AdminOrderCard(order: order, controller: adminController);
        },
      );
    });
  }
}

class _AdminOrderCard extends StatelessWidget {
  final Order order;
  final AdminController controller;

  const _AdminOrderCard({required this.order, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: Border.all(color: Colors.transparent),
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(order.status).withOpacity(0.1),
          child: Icon(_getStatusIcon(order.status), color: _getStatusColor(order.status), size: 20),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                order.id,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                order.status.name.toUpperCase(),
                style: TextStyle(color: _getStatusColor(order.status), fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Text(
          "${DateFormat('MMM dd, yyyy').format(order.date)} • ${order.itemCount} Items • \$${order.total.toStringAsFixed(2)}",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Update Status:", style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<OrderStatus>(
                      value: order.status,
                      underline: const SizedBox(),
                      items: OrderStatus.values.map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.name.toUpperCase(), style: const TextStyle(fontSize: 12)),
                      )).toList(),
                      onChanged: (newStatus) {
                        if (newStatus != null) controller.updateOrderStatus(order.id, newStatus);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showOrderDetails(context, order),
                    icon: const Icon(LucideIcons.eye, size: 16),
                    label: const Text("View Full Details"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order ${order.id}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(LucideIcons.x), onPressed: () => Get.back()),
                ],
              ),
              const Divider(),
              _buildDetailSection("Customer", "Alex Doe", "alex.doe@example.com"),
              _buildDetailSection("Shipping Address", "123 Fashion St", "New York, NY 10001, USA"),
              _buildDetailSection("Payment Method", "Visa ending in 4242", "Paid"),

              const SizedBox(height: 24),
              const Text("Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _buildItemRow("Floral Summer Dress", "Size: M", 1, 49.99),
              _buildItemRow("Classic White Sneakers", "Size: 9", 1, 59.99),

              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("\$${order.total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF42C8F))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String line1, String line2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(line1, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(line2, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, String variant, int qty, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            color: Colors.grey.shade100,
            child: const Icon(LucideIcons.image, size: 16, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(variant, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text("${qty}x", style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 16),
          Text("\$${price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing: return Colors.blue;
      case OrderStatus.shipped: return Colors.orange;
      case OrderStatus.delivered: return Colors.green;
      case OrderStatus.cancelled: return Colors.red;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing: return LucideIcons.package;
      case OrderStatus.shipped: return LucideIcons.truck;
      case OrderStatus.delivered: return LucideIcons.checkCircle;
      case OrderStatus.cancelled: return LucideIcons.xCircle;
    }
  }
}