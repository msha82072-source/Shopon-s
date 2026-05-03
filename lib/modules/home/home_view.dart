import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/app_constants.dart';
import '../../core/app_theme.dart';
import '../../core/theme_controller.dart';
import '../../widgets/product_card.dart';
import '../../widgets/banner_slider.dart';
import '../../widgets/shimmer_widgets.dart';
import 'home_controller.dart';
import '../../routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
              Get.find<ThemeController>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: AppTheme.goldAccent,
            )),
            onPressed: () => Get.find<ThemeController>().toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed(Routes.search),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Get.toNamed(Routes.cart),
          ),
        ],
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerLoading();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchData,
          color: AppTheme.goldAccent,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Slider
                const BannerSlider(),

                const SizedBox(height: 16),

                // Price Filter chips
                const _SectionHeader(title: 'PRICE RANGE'),
                const SizedBox(height: 12),
                _buildPriceFilter(controller, context),

                const SizedBox(height: 24),

                // Categories
                const _SectionHeader(title: 'EXPLORE CATEGORIES'),
                const SizedBox(height: 16),
                _buildCategoryList(context, controller),

                const SizedBox(height: 32),

                // Products grid
                const _SectionHeader(title: 'NEW ARRIVALS'),
                const SizedBox(height: 16),
                _buildProductGrid(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Shimmer skeleton for loading state ──────────────────────────────────
  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBanner(),
          const SizedBox(height: 16),
          // Category shimmer
          const ShimmerCategoryRow(count: 5),
          const SizedBox(height: 32),
          // Product grid shimmer
          const ShimmerProductGrid(),
        ],
      ),
    );
  }

  Widget _buildPriceFilter(HomeController controller, BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: ['All', 'Under 5k', '5k - 10k', 'Above 10k'].map((range) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Obx(() {
              final isSelected = controller.selectedPriceRange.value == range;
              return GestureDetector(
                onTap: () => controller.selectPriceRange(range),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.goldAccent
                        : AppTheme.navySurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.goldAccent
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.goldAccent.withValues(alpha: 0.3),
                              blurRadius: 8,
                            )
                          ]
                        : [],
                  ),
                  child: Text(
                    range,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : AppTheme.creamWhite.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, HomeController controller) {
    if (controller.categories.isEmpty) {
      return const SizedBox(
        height: 110,
        child: Center(
          child: Text(
            'No categories',
            style: TextStyle(color: AppTheme.creamWhite, fontSize: 12),
          ),
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value?.id == cat.id;
            return GestureDetector(
              onTap: () => controller.selectCategory(cat),
              child: Column(
                children: [
                  // Category avatar bounces in, scales on select
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    padding: EdgeInsets.all(isSelected ? 3 : 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [AppTheme.goldAccent, Color(0xFFE8D5A3)],
                            )
                          : null,
                      border: isSelected
                          ? null
                          : Border.all(color: Colors.white.withValues(alpha: 0.1), width: 2),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.goldAccent.withValues(alpha: 0.4),
                                blurRadius: 12,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: AppTheme.navySurface,
                      backgroundImage: cat.imageUrl != null
                          ? CachedNetworkImageProvider(cat.imageUrl!)
                          : null,
                      child: cat.imageUrl == null
                          ? const Icon(Icons.category, color: Colors.white24, size: 22)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    cat.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
                      color: isSelected
                          ? AppTheme.goldAccent
                          : AppTheme.creamWhite.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildProductGrid(HomeController controller) {
    if (controller.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No products found.',
            style: TextStyle(color: AppTheme.creamWhite.withValues(alpha: 0.4)),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final product = controller.products[index];
        return ProductCard(
          product: product,
          onTap: () => Get.toNamed(Routes.productDetails, arguments: product),
        );
      },
    );
  }
}

// ── Section Header with gold growing underline ────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
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
          RepaintBoundary(
            child: Container(
              height: 2,
              width: 36,
              decoration: BoxDecoration(
                color: AppTheme.goldAccent,
                borderRadius: BorderRadius.circular(1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.goldAccent.withValues(alpha: 0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
