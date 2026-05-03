import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_controller.dart';
import '../../widgets/app_text_field.dart';

class AdminCategoriesView extends StatelessWidget {
  const AdminCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    final nameController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'MANAGE CATEGORIES',
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final cat = controller.categories[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.white10,
                backgroundImage: cat.imageUrl != null ? NetworkImage(cat.imageUrl!) : null,
                child: cat.imageUrl == null ? const Icon(Icons.category, color: Colors.white24) : null,
              ),
              title: Text(cat.name.toUpperCase(), style: const TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                onPressed: () {}, // Admin category deletion logic
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('NEW CATEGORY', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: nameController,
                    label: 'Category Name',
                    hint: 'e.g. Footwear',
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        controller.addCategory(nameController.text, null);
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                    child: const Text('SAVE CATEGORY'),
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFFFFD700),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
