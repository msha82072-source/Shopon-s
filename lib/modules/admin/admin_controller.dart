import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/vendor_profile_model.dart';
import '../../data/models/category_model.dart';

class AdminController extends GetxController {
  final _supabase = Supabase.instance.client;

  final RxList<VendorProfileModel> pendingVendors = <VendorProfileModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdminData();
  }

  Future<void> fetchAdminData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        _fetchPendingVendors(),
        _fetchCategories(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load admin data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchPendingVendors() async {
    final res = await _supabase
        .from('vendor_profiles')
        .select()
        .eq('is_approved', false);
    
    pendingVendors.value = (res as List).map((v) => VendorProfileModel.fromJson(v)).toList();
  }

  Future<void> _fetchCategories() async {
    final res = await _supabase.from('categories').select();
    categories.value = (res as List).map((c) => CategoryModel.fromJson(c)).toList();
  }

  Future<void> approveVendor(String vendorId) async {
    try {
      await _supabase.from('vendor_profiles').update({'is_approved': true}).eq('id', vendorId);
      pendingVendors.removeWhere((v) => v.id == vendorId);
      Get.snackbar('Success', 'Vendor approved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve vendor: $e');
    }
  }

  Future<void> addCategory(String name, String? imageUrl) async {
    try {
      await _supabase.from('categories').insert({
        'name': name,
        'image_url': imageUrl,
      });
      await _fetchCategories();
      Get.snackbar('Success', 'Category added');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category: $e');
    }
  }
}
