import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/app_theme.dart';
import '../../widgets/shimmer_widgets.dart';
import 'orders_controller.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());

    return Scaffold(
      backgroundColor: AppTheme.navyDark,
      appBar: AppBar(
        title: const Text(
          'ORDER HISTORY',
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, color: AppTheme.goldAccent),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // Shimmer skeleton
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: 5,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (_, _) => const ShimmerOrderTile(),
          );
        }

        if (controller.myOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 80, color: AppTheme.creamWhite.withValues(alpha: 0.15))
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: 0, end: -8, duration: const Duration(seconds: 2), curve: Curves.easeInOut),
                const SizedBox(height: 16),
                Text(
                  'NO ORDERS YET',
                  style: TextStyle(
                    color: AppTheme.creamWhite.withValues(alpha: 0.3),
                    letterSpacing: 3,
                    fontSize: 14,
                  ),
                ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
                const SizedBox(height: 8),
                Text(
                  'Your order history will appear here',
                  style: TextStyle(
                    color: AppTheme.creamWhite.withValues(alpha: 0.2),
                    fontSize: 12,
                  ),
                ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.myOrders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final order = controller.myOrders[index];
            return _OrderTile(order: order)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 80))
                .slideY(begin: 0.1, end: 0, delay: Duration(milliseconds: index * 80), duration: const Duration(milliseconds: 400));
          },
        );
      }),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final dynamic order;
  const _OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.navyBlue,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${order.id.split('-').first.toUpperCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.creamWhite,
                  letterSpacing: 1,
                ),
              ),
              _buildStatusChip(order.status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt),
            style: TextStyle(
              color: AppTheme.creamWhite.withValues(alpha: 0.4),
              fontSize: 12,
            ),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.06), height: 28),
          ...order.items.map<Widget>((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  '${item.quantity}× ',
                  style: const TextStyle(
                    color: AppTheme.goldAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.product?.name.toUpperCase() ?? 'PRODUCT',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1,
                      color: AppTheme.creamWhite.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                Text(
                  'Rs. ${item.priceAtPurchase.toStringAsFixed(0)}',
                  style: TextStyle(color: AppTheme.creamWhite.withValues(alpha: 0.5), fontSize: 12),
                ),
              ],
            ),
          )).toList(),
          Divider(color: Colors.white.withValues(alpha: 0.06), height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.creamWhite.withValues(alpha: 0.4),
                  letterSpacing: 3,
                ),
              ),
              Text(
                'Rs. ${order.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.goldAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'delivered':  color = Colors.greenAccent; break;
      case 'shipped':    color = Colors.blueAccent; break;
      case 'processing': color = Colors.orangeAccent; break;
      case 'cancelled':  color = Colors.redAccent; break;
      default:           color = Colors.white54;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
