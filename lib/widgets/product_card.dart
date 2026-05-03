import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../data/models/product_model.dart';
import '../core/app_theme.dart';

/// Interactive product card with:
/// • Hover lift effect (web)
/// • Wishlist heart bounces + turns gold on tap
/// • "NEW" badge pulses gold forever
/// • Stagger entry animation applied from caller
class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered   = false;
  bool _isWishlisted = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit:  (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -8.0 : 0.0, 0),
          decoration: BoxDecoration(
            color: AppTheme.navySurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? AppTheme.goldAccent.withValues(alpha: 0.5)
                  : AppTheme.goldAccent.withValues(alpha: 0.12),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppTheme.goldAccent.withValues(alpha: 0.2),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──────────────────────────────────────────────
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.product.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => Shimmer.fromColors(
                            baseColor: AppTheme.navySurface,
                            highlightColor: AppTheme.navyBlue,
                            child: Container(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    // ── Wishlist Heart ──────────────────────────────
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => setState(() => _isWishlisted = !_isWishlisted),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isWishlisted
                                ? AppTheme.goldAccent.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.35),
                            border: _isWishlisted
                                ? Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.6))
                                : null,
                          ),
                          child: Icon(
                            _isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: _isWishlisted ? AppTheme.goldAccent : Colors.white,
                            size: 18,
                          ),
                        )
                        .animate(target: _isWishlisted ? 1 : 0)
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.4, 1.4),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                        ),
                      ),
                    ),

                    // ── NEW Badge (pulses gold forever) ────────────
                    Positioned(
                      top: 10,
                      left: 10,
                      child: RepaintBoundary(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.goldAccent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .shimmer(
                          duration: const Duration(seconds: 2),
                          color: Colors.white.withValues(alpha: 0.4),
                        )
                        .scale(
                          begin: const Offset(1.0, 1.0),
                          end: const Offset(1.08, 1.08),
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Product Info ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.vendorName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        color: AppTheme.creamWhite.withValues(alpha: 0.45),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.creamWhite,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs. ${widget.product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.goldAccent,
                          ),
                        ),
                        // Add icon
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.goldAccent.withValues(alpha: 0.12),
                            border: Border.all(
                              color: AppTheme.goldAccent.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppTheme.goldAccent,
                            size: 15,
                          ),
                        ),
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
