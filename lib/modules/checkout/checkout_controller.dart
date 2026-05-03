import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/cart_item_model.dart';
import '../cart/cart_controller.dart';
import '../../routes/app_routes.dart';

class CheckoutController extends GetxController {
  final _supabase = Supabase.instance.client;
  final _cartController = Get.find<CartController>();
  
  final RxBool isLoading = false.obs;

  Future<void> placeOrder() async {
    try {
      isLoading.value = true;
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'Please login to place an order';

      // 1. Group items by vendor
      final Map<String, List<CartItemModel>> vendorItems = {};
      for (var item in _cartController.items) {
        if (!vendorItems.containsKey(item.product.vendorId)) {
          vendorItems[item.product.vendorId] = [];
        }
        vendorItems[item.product.vendorId]!.add(item);
      }

      // 2. Create separate orders per vendor
      for (var entry in vendorItems.entries) {
        final vendorId = entry.key;
        final items = entry.value;
        final totalAmount = items.fold(0.0, (sum, item) => sum + item.totalPrice);

        // Insert Order
        final orderRes = await _supabase.from('orders').insert({
          'user_id': userId,
          'vendor_id': vendorId,
          'total_amount': totalAmount,
          'status': 'pending',
          'payment_method': 'cod', // Default for now
          'address_id': await _getOrCreateDummyAddress(userId),
        }).select().single();

        // Insert Order Items
        final orderItems = items.map((item) => {
          'order_id': orderRes['id'],
          'product_id': item.product.id,
          'variant_id': item.variant?.id,
          'quantity': item.quantity,
          'price_at_purchase': item.product.price,
        }).toList();

        await _supabase.from('order_items').insert(orderItems);
      }

      // 3. Clear cart and go to success screen
      _cartController.clearCart();
      Get.offAllNamed(Routes.orderSuccess);
    } catch (e) {
      Get.snackbar('Order Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _getOrCreateDummyAddress(String userId) async {
    // Check for existing address
    final existing = await _supabase.from('addresses').select().eq('user_id', userId).limit(1);
    if (existing.isNotEmpty) return existing[0]['id'];

    // Create a dummy one for now
    final res = await _supabase.from('addresses').insert({
      'user_id': userId,
      'full_name': 'Test User',
      'phone': '03001234567',
      'city': 'Karachi',
      'street': 'Street 1, Area X',
      'is_default': true,
    }).select().single();
    
    return res['id'];
  }
}
