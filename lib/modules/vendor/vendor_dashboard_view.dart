import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../widgets/shimmer_widgets.dart';
import 'vendor_controller.dart';
import '../../data/models/product_model.dart';
import '../../routes/app_routes.dart';

class VendorDashboardView extends StatelessWidget {
  const VendorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorController());

    return Scaffold(
      backgroundColor: AppTheme.navyDark,
      appBar: AppBar(
        title: Obx(() => Text(
          controller.profile.value?.storeName.toUpperCase() ?? 'VENDOR DASHBOARD',
          style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900, color: AppTheme.goldAccent),
        )),
        actions: [
          // New order pulse badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppTheme.creamWhite),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: RepaintBoundary(
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.goldAccent,
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.4, 1.4), duration: const Duration(milliseconds: 800))
                  .shimmer(duration: const Duration(seconds: 1), color: Colors.white30),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => Get.offAllNamed(Routes.login),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerLoading();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Earnings headline ───────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.navyBlue, Color(0xFF243660)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.25)),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.goldAccent.withValues(alpha: 0.12),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL EARNINGS',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.creamWhite.withValues(alpha: 0.5),
                          letterSpacing: 3,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Gold count-up earnings number
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 125000),
                        duration: const Duration(milliseconds: 1800),
                        curve: Curves.easeOutCubic,
                        builder: (_, value, _) => Text(
                          'Rs. ${value.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.goldAccent,
                            letterSpacing: 1,
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .shimmer(duration: const Duration(seconds: 3), color: Colors.white30),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: const Duration(milliseconds: 600)).slideY(begin: -0.1, end: 0),

                // ── Stats Grid ─────────────────────────────────────
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _StatCard(label: 'TOTAL SALES',  targetValue: 1250,  prefix: 'Rs.'),
                    _StatCard(label: 'ORDERS',       targetValue: 42,    prefix: ''),
                    _StatCard(label: 'ACTIVE ITEMS', targetValue: 18,    prefix: ''),
                    _StatCard(label: 'RATING',       targetValue: 4.8,   prefix: '', suffix: ' ★'),
                  ],
                ),

                const SizedBox(height: 40),

                // ── Products header ─────────────────────────────────
                const _VendorSectionHeader(title: 'MY PRODUCTS'),
                const SizedBox(height: 20),

                // Product list
                if (controller.myProducts.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 60, color: AppTheme.creamWhite.withValues(alpha: 0.1)),
                          const SizedBox(height: 16),
                          Text(
                            'NO PRODUCTS ADDED YET',
                            style: TextStyle(
                              color: AppTheme.creamWhite.withValues(alpha: 0.2),
                              letterSpacing: 2,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn()
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.myProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = controller.myProducts[index];
                      return _buildProductTile(context, product, controller)
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: index * 80))
                          .slideX(begin: 0.1, end: 0, delay: Duration(milliseconds: index * 80), duration: const Duration(milliseconds: 400));
                    },
                  ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.addProduct),
        backgroundColor: AppTheme.goldAccent,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('ADD PRODUCT', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
      )
      .animate(onPlay: (c) => c.repeat(reverse: true))
      .scale(begin: const Offset(1, 1), end: const Offset(1.04, 1.04), duration: const Duration(seconds: 2))
      .shimmer(delay: const Duration(seconds: 3), duration: const Duration(seconds: 2)),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          // Earnings card shimmer
          const ShimmerStatCard(),
          const SizedBox(height: 20),
          // Stats grid shimmer
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              ShimmerStatCard(), ShimmerStatCard(),
              ShimmerStatCard(), ShimmerStatCard(),
            ],
          ),
          const SizedBox(height: 32),
          // Product list shimmer
          for (int i = 0; i < 4; i++) ...[
            const ShimmerOrderTile(),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, ProductModel product, VendorController controller) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.navyBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppTheme.navySurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.15)),
            ),
            child: product.images.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(product.images.first, fit: BoxFit.cover),
                  )
                : const Icon(Icons.image, color: Colors.white24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.creamWhite,
                    letterSpacing: 1,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs. ${product.price}',
                  style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white38, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.redAccent.withValues(alpha: 0.6), size: 20),
            onPressed: () => controller.deleteProduct(product.id),
          ),
        ],
      ),
    );
  }
}

// ── Count-up stat card ────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final double targetValue;
  final String prefix;
  final String suffix;

  const _StatCard({
    required this.label,
    required this.targetValue,
    required this.prefix,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.navyBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: AppTheme.creamWhite.withValues(alpha: 0.45),
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: targetValue),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (_, value, _) => Text(
              '$prefix${targetValue % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1)}$suffix',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppTheme.creamWhite,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.88, 0.88), duration: const Duration(milliseconds: 400), curve: Curves.easeOutBack);
  }
}

// ── Section header ─────────────────────────────────────────────────────────────
class _VendorSectionHeader extends StatelessWidget {
  final String title;
  const _VendorSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: AppTheme.goldAccent,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 40,
          height: 2,
          color: AppTheme.goldAccent,
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleX(begin: 1, end: 2, duration: const Duration(seconds: 2), curve: Curves.easeInOut),
      ],
    );
  }
}
