import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/order_model.dart';

class OrdersController extends GetxController {
  final _supabase = Supabase.instance.client;
  
  final RxList<OrderModel> myOrders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final res = await _supabase
          .from('orders')
          .select('*, order_items(*, products(*))')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      myOrders.value = (res as List).map((o) => OrderModel.fromJson(o)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _supabase.from('orders').update({'status': newStatus}).eq('id', orderId);
      await fetchOrders();
      Get.snackbar('Success', 'Order status updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order: $e');
    }
  }
}
