import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/product_card.dart';
import 'search_controller.dart';
import '../../routes/app_routes.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: SearchController renamed to AppSearchController to avoid material.dart clash
    final controller = Get.put(AppSearchController());

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white, letterSpacing: 1),
          cursorColor: Theme.of(context).colorScheme.primary,
          decoration: InputDecoration(
            hintText: 'DISCOVER LUXURY...',
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.2),
              letterSpacing: 4,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            border: InputBorder.none,
          ),
          onChanged: controller.onSearch,
        ).animate(onPlay: (c) => c.repeat())
         .shimmer(delay: const Duration(seconds: 2), duration: const Duration(seconds: 3), color: Colors.white.withValues(alpha: 0.1)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 24),
                const Text(
                  'CURATING RESULTS...',
                  style: TextStyle(color: Colors.white38, letterSpacing: 4, fontSize: 10),
                ).animate(onPlay: (c) => c.repeat()).shimmer(),
              ],
            ),
          );
        }

        if (controller.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_rounded, size: 80, color: Colors.white10)
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(1,1), end: const Offset(1.1, 1.1), duration: const Duration(seconds: 2))
                    .moveY(begin: 0, end: -10),
                const SizedBox(height: 24),
                Text(
                  controller.query.isEmpty ? 'TYPE TO DISCOVER' : 'NO RESULTS FOUND',
                  style: const TextStyle(
                    color: Colors.white38,
                    letterSpacing: 6,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                '${controller.searchResults.length} ITEMS FOUND',
                style: const TextStyle(
                  color: Colors.white24,
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn().slideX(begin: -0.2, end: 0),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final product = controller.searchResults[index];
                  return ProductCard(
                    product: product,
                    onTap: () => Get.toNamed(Routes.productDetails, arguments: product),
                  ).animate().fadeIn(delay: Duration(milliseconds: (index * 80))).slideY(begin: 0.1, end: 0);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
