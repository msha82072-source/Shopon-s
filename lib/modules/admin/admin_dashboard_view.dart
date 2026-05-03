import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'admin_controller.dart';
import '../../routes/app_routes.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN CONSOLE', style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            onPressed: () => Get.toNamed(Routes.adminCategories),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.orangeAccent)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(duration: const Duration(seconds: 2)),
            onPressed: () => Get.offAllNamed(Routes.login),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats
              _buildAdminStats().animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
              
              const SizedBox(height: 48),

              // Pending Vendors Header
              const _AdminSectionHeader(title: 'PENDING VENDOR APPROVALS'),
              const SizedBox(height: 24),

              // List
              if (controller.pendingVendors.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        const Icon(Icons.verified_user_outlined, size: 60, color: Colors.white10),
                        const SizedBox(height: 16),
                        const Text('ALL VENDORS VERIFIED', style: TextStyle(color: Colors.white24, letterSpacing: 2)),
                      ],
                    ),
                  ),
                ).animate().fadeIn()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.pendingVendors.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                    final vendor = controller.pendingVendors[index];
                    return _buildVendorApprovalCard(context, vendor, controller)
                        .animate().fadeIn(delay: Duration(milliseconds: (index * 100))).slideX(begin: 0.1, end: 0);
                  },
                ),
            ],
          ),
        );
      })),
    );
  }

  Widget _buildAdminStats() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(Icons.analytics_outlined, size: 80, color: Colors.white.withValues(alpha: 0.03)),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'USERS', value: '1.2k', delayMs: 0),
              _StatItem(label: 'VENDORS', value: '48', delayMs: 200),
              _StatItem(label: 'REVENUE', value: 'Rs.15k', delayMs: 400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVendorApprovalCard(BuildContext context, dynamic vendor, AdminController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Text(
              vendor.storeName[0].toUpperCase(), 
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: const Duration(seconds: 3)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor.storeName.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                ),
                const SizedBox(height: 4),
                Text(
                  vendor.description ?? 'PREMIUM FASHION VENDOR',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.white38, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.greenAccent, size: 28),
            onPressed: () => controller.approveVendor(vendor.id),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1,1), end: const Offset(1.1, 1.1), duration: const Duration(seconds: 1)),
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.white24, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _AdminSectionHeader extends StatelessWidget {
  final String title;
  const _AdminSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 60,
          height: 2,
          color: Theme.of(context).colorScheme.primary,
        ).animate(onPlay: (c) => c.repeat(reverse: true))
         .scaleX(begin: 1, end: 1.5, duration: const Duration(seconds: 2)),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final int delayMs;
  const _StatItem({required this.label, required this.value, required this.delayMs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value, 
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary)
        ).animate().fadeIn(delay: Duration(milliseconds: delayMs)).scale(begin: const Offset(0.5, 0.5)),
        const SizedBox(height: 6),
        Text(
          label, 
          style: const TextStyle(fontSize: 10, color: Colors.white38, letterSpacing: 2, fontWeight: FontWeight.bold)
        ).animate().fadeIn(delay: Duration(milliseconds: (delayMs + 200))),
      ],
    );
  }
}
