import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/product_model.dart';
import '../../data/models/vendor_profile_model.dart';

class VendorController extends GetxController {
  final _supabase = Supabase.instance.client;
  
  final Rx<VendorProfileModel?> profile = Rx<VendorProfileModel?>(null);
  final RxList<ProductModel> myProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVendorData();
  }

  Future<void> fetchVendorData() async {
    try {
      isLoading.value = true;
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Fetch Profile
      final profileRes = await _supabase
          .from('vendor_profiles')
          .select()
          .eq('user_id', userId)
          .single();
      
      profile.value = VendorProfileModel.fromJson(profileRes);

      // Fetch Products
      await fetchMyProducts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load vendor data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyProducts() async {
    if (profile.value == null) return;

    final productsRes = await _supabase
        .from('products')
        .select('*, product_images(*), product_variants(*)')
        .eq('vendor_id', profile.value!.id);
    
    myProducts.value = (productsRes as List).map((p) => ProductModel.fromJson(p)).toList();
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _supabase.from('products').delete().eq('id', productId);
      myProducts.removeWhere((p) => p.id == productId);
      Get.snackbar('Deleted', 'Product removed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }
}
