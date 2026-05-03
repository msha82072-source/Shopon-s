import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_theme.dart';
import '../../routes/app_routes.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 120,
                  color: AppTheme.goldAccent,
                ),

                const SizedBox(height: 44),

                const Text(
                  'ORDER PLACED!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Thank you for shopping with SHOPON\'S!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.goldAccent,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Your order has been split by vendor and is being processed. You\'ll receive a confirmation soon.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.55),
                    height: 1.6,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.goldAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_shipping_outlined, color: AppTheme.goldAccent, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        'Est. Delivery: 3-5 business days',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 56),

                ElevatedButton(
                  onPressed: () => Get.offAllNamed(Routes.home),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: AppTheme.goldAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    'CONTINUE SHOPPING',
                    style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'VIEW ORDER HISTORY',
                    style: TextStyle(
                      color: AppTheme.goldAccent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
