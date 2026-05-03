import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/product_model.dart';
import '../../data/models/vendor_profile_model.dart';

class VendorStoreController extends GetxController {
  final _supabase = Supabase.instance.client;
  
  late String vendorId;
  final Rx<VendorProfileModel?> profile = Rx<VendorProfileModel?>(null);
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    vendorId = Get.arguments as String;
    fetchStoreData();
  }

  Future<void> fetchStoreData() async {
    try {
      isLoading.value = true;
      
      // Fetch Profile
      final profileRes = await _supabase
          .from('vendor_profiles')
          .select()
          .eq('id', vendorId)
          .single();
      
      profile.value = VendorProfileModel.fromJson(profileRes);

      // Fetch Products
      final productsRes = await _supabase
          .from('products')
          .select('*, product_images(*), product_variants(*)')
          .eq('vendor_id', vendorId)
          .eq('is_active', true);
      
      products.value = (productsRes as List).map((p) => ProductModel.fromJson(p)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load store data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
