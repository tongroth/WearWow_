import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../controllers/checkout_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../core/app_theme.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Shipping Address'),
            const SizedBox(height: 8),
            _buildAddressCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Payment Method'),
            const SizedBox(height: 8),
            _buildPaymentCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Order Summary'),
            const SizedBox(height: 8),
            _buildOrderSummary(cartController),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(controller, cartController),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.mapPin, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Home', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
                Text('123 Fashion Street, New York, NY 10001',
                    style: GoogleFonts.spaceGrotesk(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.creditCard, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Visa **** 4242', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
                Text('Expires 12/26', style: GoogleFonts.spaceGrotesk(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartController cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', '\$${cart.totalAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _summaryRow('Shipping', 'Free'),
          const SizedBox(height: 8),
          _summaryRow('Tax', '\$0.00'),
          const Divider(height: 24),
          _summaryRow('Total', '\$${cart.totalAmount.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w700,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(CheckoutController controller, CartController cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Obx(() => ElevatedButton(
        onPressed: controller.isProcessing.value ? null : () => controller.processCheckout(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: controller.isProcessing.value
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text('Place Order - \$${cart.totalAmount.toStringAsFixed(2)}',
              style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
      )),
    );
  }
}
