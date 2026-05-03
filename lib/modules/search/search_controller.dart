import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/product_model.dart';

class AppSearchController extends GetxController {
  final _supabase = Supabase.instance.client;
  
  final RxList<ProductModel> searchResults = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString query = ''.obs;

  void onSearch(String val) {
    query.value = val;
    if (val.isEmpty) {
      searchResults.clear();
      return;
    }
    _performSearch();
  }

  Future<void> _performSearch() async {
    try {
      isLoading.value = true;
      final res = await _supabase
          .from('products')
          .select('*, product_images(*), product_variants(*)')
          .ilike('name', '%${query.value}%')
          .eq('is_active', true);
      
      searchResults.value = (res as List).map((p) => ProductModel.fromJson(p)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Search failed: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
