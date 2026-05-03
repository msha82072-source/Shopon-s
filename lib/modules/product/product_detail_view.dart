import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/app_theme.dart';
import '../../widgets/shimmer_widgets.dart';
import 'product_detail_controller.dart';
import '../../routes/app_routes.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProductDetailController());

    return Scaffold(
      backgroundColor: AppTheme.navyDark,
      body: Obx(() {
        final product = controller.product.value;
        if (product == null) {
          // Shimmer skeleton while loading
          return const ShimmerProductDetail();
        }

        return CustomScrollView(
          slivers: [
            // ── Hero Image App Bar ────────────────────────────────────
            SliverAppBar(
              expandedHeight: 480,
              pinned: true,
              backgroundColor: AppTheme.navyBlue,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    product.images.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.images.first,
                            fit: BoxFit.cover,
                          )
                        : Container(color: AppTheme.navySurface),
                    // Bottom gradient overlay
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppTheme.navyDark, Colors.transparent],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Detail Content ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Count-up Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                              color: AppTheme.creamWhite,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Price counts up from 0
                        _CountUpPrice(targetPrice: product.price),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Vendor info
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.vendorStore, arguments: product.vendorId),
                      child: Row(
                        children: [
                          Text(
                            'BY ',
                            style: TextStyle(
                              color: AppTheme.creamWhite.withValues(alpha: 0.35),
                              fontSize: 10,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'STORE #${product.vendorId.split('-').first.toUpperCase()}',
                            style: const TextStyle(
                              color: AppTheme.goldAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Description
                    Text(
                      product.description ?? 'A curated fashion piece for the modern wardrobe.',
                      style: TextStyle(
                        color: AppTheme.creamWhite.withValues(alpha: 0.6),
                        height: 1.8,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Size chips
                    if (product.variants.isNotEmpty) ...[
                      const _DetailSectionHeader(title: 'SELECT SIZE'),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 50,
                        child: Obx(() => ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: product.variants.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final variant = product.variants[index];
                            final isSelected = controller.selectedVariant.value == variant;
                            return GestureDetector(
                              onTap: () => controller.selectVariant(variant),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(horizontal: 22),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.goldAccent : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.goldAccent
                                        : AppTheme.creamWhite.withValues(alpha: 0.15),
                                  ),
                                  boxShadow: isSelected
                                      ? [BoxShadow(color: AppTheme.goldAccent.withValues(alpha: 0.4), blurRadius: 12)]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    variant.size ?? variant.color ?? '—',
                                    style: TextStyle(
                                      color: isSelected ? Colors.black : AppTheme.creamWhite,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                      ),
                      const SizedBox(height: 36),
                    ],

                    // Quantity selector
                    const _DetailSectionHeader(title: 'QUANTITY'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _QuantityBtn(icon: Icons.remove, onTap: () => controller.updateQuantity(-1)),
                        const SizedBox(width: 24),
                        Obx(() => Text(
                          '${controller.quantity.value}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.creamWhite,
                          ),
                        )),
                        const SizedBox(width: 24),
                        _QuantityBtn(icon: Icons.add, onTap: () => controller.updateQuantity(1)),
                      ],
                    ),

                    const Divider(color: Colors.white10, height: 72),

                    // Reviews
                    const _DetailSectionHeader(title: 'CUSTOMER REVIEWS'),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (controller.isLoadingReviews.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.goldAccent,
                            ),
                          ),
                        );
                      }
                      if (controller.reviews.isEmpty) {
                        return Text(
                          'NO REVIEWS YET',
                          style: TextStyle(
                            color: AppTheme.creamWhite.withValues(alpha: 0.2),
                            fontSize: 10,
                            letterSpacing: 4,
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.reviews.length,
                        separatorBuilder: (_, _) =>
                            Divider(color: Colors.white.withValues(alpha: 0.06), height: 40),
                        itemBuilder: (context, index) {
                          final review = controller.reviews[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    review.userName?.toUpperCase() ?? 'ANONYMOUS',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 11,
                                      letterSpacing: 1,
                                      color: AppTheme.creamWhite.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star,
                                        size: 12,
                                        color: i < review.rating
                                            ? AppTheme.goldAccent
                                            : Colors.white10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                review.comment ?? '',
                                style: TextStyle(
                                  color: AppTheme.creamWhite.withValues(alpha: 0.45),
                                  fontSize: 13,
                                  height: 1.6,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        );
      }),

      // ── Add to Cart bottom bar ────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.navyBlue,
          border: Border(
            top: BorderSide(color: AppTheme.goldAccent.withValues(alpha: 0.15)),
          ),
        ),
        child: SafeArea(
          child: RepaintBoundary(
            child: ElevatedButton(
              onPressed: () => controller.addToCart(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppTheme.goldAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                'ADD TO BAG',
                style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Price count-up animation ─────────────────────────────────────────────────
class _CountUpPrice extends StatelessWidget {
  final double targetPrice;
  const _CountUpPrice({required this.targetPrice});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: targetPrice),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (_, value, _) => Text(
        'Rs. ${value.toStringAsFixed(0)}',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: AppTheme.goldAccent,
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class _DetailSectionHeader extends StatelessWidget {
  final String title;
  const _DetailSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: AppTheme.goldAccent,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 28,
          height: 1.5,
          color: AppTheme.goldAccent,
        ),
      ],
    );
  }
}

// ── Quantity button ───────────────────────────────────────────────────────────
class _QuantityBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QuantityBtn({required this.icon, required this.onTap});

  @override
  State<_QuantityBtn> createState() => _QuantityBtnState();
}

class _QuantityBtnState extends State<_QuantityBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: _pressed
                ? AppTheme.goldAccent
                : AppTheme.creamWhite.withValues(alpha: 0.15),
          ),
          borderRadius: BorderRadius.circular(12),
          color: _pressed
              ? AppTheme.goldAccent.withValues(alpha: 0.15)
              : Colors.transparent,
        ),
        child: Icon(
          widget.icon,
          color: _pressed ? AppTheme.goldAccent : AppTheme.creamWhite,
          size: 18,
        ),
      ),
    );
  }
}
