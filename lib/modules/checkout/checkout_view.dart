import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'checkout_controller.dart';
import '../cart/cart_controller.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'CHECKOUT',
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Section via Decoration
            _buildSectionHeader(context, 'DELIVERY ADDRESS'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Street 1, Area X, Karachi', style: TextStyle(color: Colors.white54, fontSize: 13)),
                        Text('+92 300 1234567', style: TextStyle(color: Colors.white54, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Order Summary
            _buildSectionHeader(context, 'ORDER SUMMARY'),
            const SizedBox(height: 16),
            ...cartController.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.quantity}x ${item.product.name}'.toUpperCase(),
                    style: const TextStyle(fontSize: 13, letterSpacing: 1),
                  ),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
            
            const Divider(color: Colors.white10, height: 48),

            // Payment method
            _buildSectionHeader(context, 'PAYMENT METHOD'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.primary),
              ),
              child: Row(
                children: [
                  Icon(Icons.payments_outlined, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 16),
                  const Text('CASH ON DELIVERY (COD)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const Spacer(),
                  Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 20),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        color: const Color(0xFF1E1E1E),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL AMOUNT', style: TextStyle(letterSpacing: 2, fontSize: 12, color: Colors.white54)),
                Text(
                  '\$${cartController.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : () => controller.placeOrder(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('CONFIRM ORDER'),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
