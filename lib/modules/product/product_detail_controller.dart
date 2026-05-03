import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/product_model.dart';
import '../../data/models/review_model.dart';
import '../cart/cart_controller.dart';
import '../../routes/app_routes.dart';

class ProductDetailController extends GetxController {
  final Rx<ProductModel?> product = Rx<ProductModel?>(null);
  
  final Rx<ProductVariant?> selectedVariant = Rx<ProductVariant?>(null);
  final RxInt quantity = 1.obs;

  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxBool isLoadingReviews = false.obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is ProductModel) {
      product.value = arg;
      if (product.value!.variants.isNotEmpty) {
        selectedVariant.value = product.value!.variants.first;
      }
      fetchReviews();
    }
  }

  Future<void> fetchReviews() async {
    if (product.value == null) return;
    try {
      isLoadingReviews.value = true;
      final res = await Supabase.instance.client
          .from('reviews')
          .select('*, users(full_name)')
          .eq('product_id', product.value!.id);
      
      reviews.value = (res as List).map((r) => ReviewModel.fromJson(r)).toList();
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
    } finally {
      isLoadingReviews.value = false;
    }
  }

  void selectVariant(ProductVariant variant) {
    selectedVariant.value = variant;
  }

  void updateQuantity(int val) {
    if (quantity.value + val > 0) {
      quantity.value += val;
    }
  }


  void addToCart() {
    if (product.value == null) return;
    // Use Get.put to ensure the controller exists even if CartView hasn't been opened yet
    final cartController = Get.put(CartController());
    cartController.addToCart(
      product.value!,
      selectedVariant.value,
      quantity.value,
    );
    // Automatically navigate to the Cart page as requested
    Get.toNamed(Routes.cart);
  }
}
