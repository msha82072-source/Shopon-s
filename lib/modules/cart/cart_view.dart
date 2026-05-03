import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/app_theme.dart';
import 'cart_controller.dart';
import '../../routes/app_routes.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: AppTheme.navyDark,
      appBar: AppBar(
        title: const Text('YOUR BAG'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.items.isEmpty) {
            return _buildEmptyCart(context);
          }
          return Column(
            children: [
              // Items list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.items.length,
                  separatorBuilder: (_, _) => Divider(
                    color: Colors.white.withValues(alpha: 0.06),
                    height: 40,
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return _CartItemTile(
                      item: item,
                      index: index,
                      controller: controller,
                    );
                  },
                ),
              ),

              // ── Order Summary ────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: BoxDecoration(
                  color: AppTheme.navyBlue,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SUBTOTAL',
                            style: TextStyle(
                              color: AppTheme.creamWhite.withValues(alpha: 0.5),
                              letterSpacing: 3,
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          ),
                          // Count-up total on quantity change
                          Obx(() => TweenAnimationBuilder<double>(
                            key: ValueKey(controller.totalAmount),
                            tween: Tween(begin: 0, end: controller.totalAmount),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                            builder: (_, value, _) => Text(
                              'Rs. ${value.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.goldAccent,
                              ),
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Checkout button pulses gold
                      RepaintBoundary(
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed(Routes.checkout),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            backgroundColor: AppTheme.goldAccent,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('PROCEED TO CHECKOUT'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 90, color: Colors.white24),
          const SizedBox(height: 24),
          Text(
            'YOUR BAG IS EMPTY',
            style: TextStyle(
              color: AppTheme.creamWhite.withValues(alpha: 0.4),
              letterSpacing: 4,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some stunning pieces to get started',
            style: TextStyle(
              color: AppTheme.creamWhite.withValues(alpha: 0.2),
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 36),
          ElevatedButton(
            onPressed: () => Get.offAllNamed(Routes.home),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.goldAccent,
              foregroundColor: Colors.black,
            ),
            child: const Text('START SHOPPING'),
          ),
        ],
      ),
    );
  }
}

// ── Cart Item Tile ─────────────────────────────────────────────────────────────
class _CartItemTile extends StatefulWidget {
  final dynamic item;
  final int index;
  final CartController controller;

  const _CartItemTile({
    required this.item,
    required this.index,
    required this.controller,
  });

  @override
  State<_CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<_CartItemTile> {
  bool _visible = true;

  void _removeItem() async {
    setState(() => _visible = false);
    await Future.delayed(const Duration(milliseconds: 350));
    widget.controller.removeFromCart(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: _visible
          ? Row(
              key: ValueKey(widget.item.product.id),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image slides from right
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 96,
                    height: 124,
                    color: AppTheme.navySurface,
                    child: widget.item.product.images.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: widget.item.product.images.first,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, color: Colors.white24),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.product.name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1,
                          color: AppTheme.creamWhite,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (widget.item.variant != null)
                        Text(
                          'Size: ${widget.item.variant?.size ?? "—"} • Color: ${widget.item.variant?.color ?? "—"}',
                          style: TextStyle(
                            color: AppTheme.creamWhite.withValues(alpha: 0.4),
                            fontSize: 11,
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        'Rs. ${widget.item.product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppTheme.goldAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _QtyBtn(
                            icon: Icons.remove,
                            onTap: () => widget.controller.updateQuantity(widget.item, -1),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            '${widget.item.quantity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.creamWhite,
                            ),
                          ),
                          const SizedBox(width: 14),
                          _QtyBtn(
                            icon: Icons.add,
                            onTap: () => widget.controller.updateQuantity(widget.item, 1),
                          ),
                          const Spacer(),
                          // Remove slides out
                          GestureDetector(
                            onTap: _removeItem,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.redAccent.withValues(alpha: 0.3),
                                ),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(key: ValueKey('removed')),
    );
  }
}

// ── Quantity button ────────────────────────────────────────────────────────────
class _QtyBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  State<_QtyBtn> createState() => _QtyBtnState();
}

class _QtyBtnState extends State<_QtyBtn> {
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
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          border: Border.all(
            color: _pressed
                ? AppTheme.goldAccent
                : AppTheme.creamWhite.withValues(alpha: 0.15),
          ),
          borderRadius: BorderRadius.circular(9),
          color: _pressed
              ? AppTheme.goldAccent.withValues(alpha: 0.15)
              : Colors.transparent,
        ),
        child: Icon(
          widget.icon,
          color: _pressed ? AppTheme.goldAccent : AppTheme.creamWhite,
          size: 15,
        ),
      ),
    );
  }
}
