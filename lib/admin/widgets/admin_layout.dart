import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget? floatingActionButton;

  const AdminLayout({
    super.key,
    required this.child,
    required this.title,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // BREAKPOINT: 900px
        if (constraints.maxWidth >= 900) {
          return _buildDesktopLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  // --- DESKTOP LAYOUT (Permanent Sidebar) ---
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background
      body: Row(
        children: [
          // 1. Permanent Sidebar
          SizedBox(
            width: 250,
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Column(
                children: [
                  _buildDrawerHeader(),
                  Expanded(child: _buildNavList()),
                ],
              ),
            ),
          ),
          // 2. Main Content Area
          Expanded(
            child: Column(
              children: [
                _buildAppBar(context, isDesktop: true),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      // Prevent content from getting too wide on massive screens
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  // --- MOBILE LAYOUT (Hidden Drawer) ---
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(context, isDesktop: false),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(child: _buildNavList()),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  // --- SHARED WIDGETS ---

  // Custom AppBar that adapts based on layout
  PreferredSizeWidget _buildAppBar(BuildContext context, {required bool isDesktop}) {
    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: isDesktop ? Colors.transparent : Colors.white,
      elevation: isDesktop ? 0 : 1,
      scrolledUnderElevation: isDesktop ? 0 : 2,
      automaticallyImplyLeading: !isDesktop, // Hide hamburger on desktop
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
      actions: [
        IconButton(icon: const Icon(LucideIcons.bell), onPressed: () {}),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF42C8F).withValues(alpha: 0.1),
            child: const Text("A", style: TextStyle(color: Color(0xFFF42C8F), fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: Color(0xFFF42C8F), // Brand Pink
        image: DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1557683316-973673baf926?auto=format&fit=crop&w=500&q=60"),
          fit: BoxFit.cover,
          opacity: 0.2,
        ),
      ),
      accountName: const Text("Admin User", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      accountEmail: const Text("admin@wearwow.com"),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Text("A", style: TextStyle(fontSize: 28, color: Color(0xFFF42C8F), fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildNavList() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildNavItem(LucideIcons.layoutDashboard, "Dashboard", '/admin/dashboard'),
        _buildNavItem(LucideIcons.package, "Products", '/admin/products'),
        _buildNavItem(LucideIcons.shoppingBag, "Orders", '/admin/orders'),
        _buildNavItem(LucideIcons.layoutGrid, "Categories", '/admin/categories'),
        const Divider(height: 32, thickness: 1),
        _buildNavItem(LucideIcons.settings, "Settings", '/admin/settings'),
        _buildNavItem(LucideIcons.logOut, "Logout", '/login'),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String title, String route) {
    final bool isSelected = Get.currentRoute == route;
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFFF42C8F) : Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFFF42C8F) : Colors.grey[800],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFFF42C8F).withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: () {
        if (Get.currentRoute != route) {
          Get.offNamed(route);
        } else {
          // If on mobile (has drawer), close it
          if (Get.isOverlaysOpen) Get.back();
        }
      },
    );
  }
}