import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_store_controller.dart';
import '../../widgets/product_card.dart';
import '../../routes/app_routes.dart';

class VendorStoreView extends StatelessWidget {
  const VendorStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorStoreController());

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFFD700)));
        }

        if (controller.profile.value == null) {
          return const Center(child: Text('Vendor not found', style: TextStyle(color: Colors.white54)));
        }

        final profile = controller.profile.value!;

        return CustomScrollView(
          slivers: [
            // Store Header
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: const Color(0xFF121212),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 48),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white10,
                          child: Text(
                            profile.storeName[0].toUpperCase(),
                            style: const TextStyle(fontSize: 32, color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.storeName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              profile.rating.toString(),
                              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Store Description
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ABOUT THE BRAND',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile.description ?? 'No description available for this store.',
                      style: const TextStyle(color: Colors.white70, height: 1.6),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'COLLECTION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = controller.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => Get.toNamed(Routes.productDetails, arguments: product),
                    );
                  },
                  childCount: controller.products.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        );
      }),
    );
  }
}
