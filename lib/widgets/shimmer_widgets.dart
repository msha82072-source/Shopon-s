import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ── Brand shimmer colors ────────────────────────────────────────────────────
const _shimmerBase      = Color(0xFF1B2A4A); // Navy
const _shimmerHighlight = Color(0xFF2E4270); // Lighter navy highlight
const _shimmerBaseLight = Color(0xFFE8D5A3); // Cream base
const _shimmerHighlightLight = Color(0xFFF5EDD7); // Lighter cream highlight

/// Wraps any widget in the brand shimmer effect.
class BrandShimmer extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const BrandShimmer({super.key, required this.child, this.isDark = true});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:      isDark ? _shimmerBase      : _shimmerBaseLight,
      highlightColor: isDark ? _shimmerHighlight : _shimmerHighlightLight,
      direction: ShimmerDirection.ltr,
      child: child,
    );
  }
}

/// Rounded rectangle placeholder.
Widget _box({double w = double.infinity, double h = 16, double r = 8}) =>
    Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r),
      ),
    );

// ── Product Card Shimmer ─────────────────────────────────────────────────────
class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BrandShimmer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Expanded(child: _box(r: 20)),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(w: 60, h: 10),
                    const SizedBox(height: 6),
                    _box(h: 14),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _box(w: 70, h: 16),
                        _box(w: 32, h: 32, r: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Banner Shimmer ───────────────────────────────────────────────────────────
class ShimmerBanner extends StatelessWidget {
  const ShimmerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BrandShimmer(
        child: Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _box(w: 40, h: 20, r: 4),
              const SizedBox(height: 12),
              _box(w: 200, h: 24),
              const SizedBox(height: 8),
              _box(w: 140, h: 14),
              const SizedBox(height: 16),
              _box(w: 100, h: 36, r: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Category Chip Shimmer ────────────────────────────────────────────────────
class ShimmerCategoryChip extends StatelessWidget {
  const ShimmerCategoryChip({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BrandShimmer(
        child: Column(
          children: [
            _box(w: 62, h: 62, r: 31),
            const SizedBox(height: 8),
            _box(w: 48, h: 10),
          ],
        ),
      ),
    );
  }
}

/// Row of shimmer category chips
class ShimmerCategoryRow extends StatelessWidget {
  final int count;
  const ShimmerCategoryRow({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, _) => const ShimmerCategoryChip(),
      ),
    );
  }
}

// ── Order History Tile Shimmer ───────────────────────────────────────────────
class ShimmerOrderTile extends StatelessWidget {
  const ShimmerOrderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BrandShimmer(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _box(w: 100, h: 14),
                  _box(w: 70, h: 24, r: 12),
                ],
              ),
              const SizedBox(height: 12),
              _box(w: 160, h: 12),
              const SizedBox(height: 16),
              _box(h: 1),
              const SizedBox(height: 16),
              _box(w: double.infinity, h: 12),
              const SizedBox(height: 8),
              _box(w: 200, h: 12),
              const SizedBox(height: 16),
              _box(h: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _box(w: 100, h: 12),
                  _box(w: 80, h: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Vendor Stat Card Shimmer ─────────────────────────────────────────────────
class ShimmerStatCard extends StatelessWidget {
  const ShimmerStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BrandShimmer(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _box(w: 80, h: 10),
              const SizedBox(height: 12),
              _box(w: 100, h: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Product Detail Shimmer ───────────────────────────────────────────────────
class ShimmerProductDetail extends StatelessWidget {
  const ShimmerProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SingleChildScrollView(
        child: BrandShimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              Container(
                height: 400,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _box(w: 200, h: 24),
                        _box(w: 80, h: 24),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _box(w: 150, h: 12),
                    const SizedBox(height: 32),
                    _box(h: 12),
                    const SizedBox(height: 8),
                    _box(h: 12),
                    const SizedBox(height: 8),
                    _box(w: 200, h: 12),
                    const SizedBox(height: 40),
                    _box(w: 100, h: 10),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _box(w: 60, h: 48, r: 12),
                        const SizedBox(width: 12),
                        _box(w: 60, h: 48, r: 12),
                        const SizedBox(width: 12),
                        _box(w: 60, h: 48, r: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Product Grid Shimmer (6 cards) ───────────────────────────────────────────
class ShimmerProductGrid extends StatelessWidget {
  const ShimmerProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (_, _) => const ShimmerProductCard(),
    );
  }
}
