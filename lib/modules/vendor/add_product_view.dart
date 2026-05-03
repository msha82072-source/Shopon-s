import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/app_text_field.dart';
import 'vendor_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  
  final _vendorController = Get.find<VendorController>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      Get.snackbar('Error', 'Product name and price are required');
      return;
    }

    try {
      setState(() => _isLoading = true);
      final supabase = Supabase.instance.client;
      final vendorId = _vendorController.profile.value?.id;
      
      if (vendorId == null) throw 'Vendor profile not found';

      final res = await supabase.from('products').insert({
        'vendor_id': vendorId,
        'name': _nameController.text,
        'description': _descController.text,
        'price': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text.isEmpty ? '0' : _stockController.text),
        'is_active': true,
      }).select().single();

      // Add a dummy image for now
      await supabase.from('product_images').insert({
        'product_id': res['id'],
        'image_url': 'https://plus.unsplash.com/premium_photo-1671147820986-77e80d60d3d5?q=80&w=2070&auto=format&fit=crop',
        'is_primary': true,
      });

      await _vendorController.fetchMyProducts();
      Get.back();
      Get.snackbar('Success', 'Product listed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save product: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'LIST NEW PRODUCT',
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, size: 48, color: Color(0xFFFFD700)),
                  SizedBox(height: 12),
                  Text('ADD PRODUCT PHOTOS', style: TextStyle(color: Colors.white54, letterSpacing: 1, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            AppTextField(
              controller: _nameController,
              label: 'Product Name',
              hint: 'e.g. Classic Silk Scarf',
            ),
            const SizedBox(height: 24),
            
            AppTextField(
              controller: _descController,
              label: 'Description',
              hint: 'Write about your product...',
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _priceController,
                    label: 'Price (\$)',
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _stockController,
                    label: 'Initial Stock',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),

            ElevatedButton(
              onPressed: _isLoading ? null : _saveProduct,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator()
                : const Text('PUBLISH PRODUCT'),
            ),
          ],
        ),
      ),
    );
  }
}
