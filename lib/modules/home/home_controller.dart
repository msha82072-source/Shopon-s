import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';

class HomeController extends GetxController {
  final _supabase = Supabase.instance.client;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final RxString selectedPriceRange = 'All'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        _fetchCategories(),
        fetchProducts(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchCategories() async {
    final res = await _supabase.from('categories').select().limit(10);
    categories.value = (res as List).map((c) => CategoryModel.fromJson(c)).toList();
  }

  Future<void> fetchProducts() async {
    var query = _supabase
        .from('products')
        .select('*, product_images(*), product_variants(*)')
        .eq('is_active', true);
    
    if (selectedCategory.value != null) {
      query = query.eq('category_id', selectedCategory.value!.id);
    }

    // Apply Price Filter
    if (selectedPriceRange.value == 'Under 5k') {
      query = query.lte('price', 5000);
    } else if (selectedPriceRange.value == '5k - 10k') {
      query = query.gte('price', 5000).lte('price', 10000);
    } else if (selectedPriceRange.value == 'Above 10k') {
      query = query.gte('price', 10000);
    }

    final res = await query.order('created_at', ascending: false).limit(50);
    products.value = (res as List).map((p) => ProductModel.fromJson(p)).toList();
  }

  void selectPriceRange(String range) {
    selectedPriceRange.value = range;
    fetchProducts();
  }

  void selectCategory(CategoryModel? category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = null;
    } else {
      selectedCategory.value = category;
    }
    fetchProducts();
  }
}
