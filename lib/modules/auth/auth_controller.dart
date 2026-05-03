import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_routes.dart';
import '../admin/admin_controller.dart';

class AuthController extends GetxController {
  final _supabase = Supabase.instance.client;
  
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool showSignupSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await _fetchUserProfile(user.id);
    }
  }

  Future<void> _fetchUserProfile(String uuid) async {
    try {
      final res = await _supabase
          .from('users')
          .select()
          .eq('id', uuid)
          .single();
      
      currentUser.value = UserModel.fromJson(res);
    } catch (e) {
      debugPrint('Error loading profile: $e');
      // We don't necessarily want to block the app if profile loading fails,
      // but we should set a default role or handle it.
    }
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await _fetchUserProfile(response.user!.id);
        
        // As requested: Navigate to home after successful login
        _redirectBasedOnRole();
        
        Get.snackbar(
          'Success', 
          'Welcome back!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.7),
          colorText: Colors.white,
        );
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Login Failed', 
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error', 
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user != null) {
        // Create user profile in 'users' table
        try {
          await _supabase.from('users').insert({
            'id': response.user!.id,
            'email': email,
            'full_name': fullName,
            'role': role.name,
          });
        } catch (e) {
          debugPrint('Profile creation error (user may already exist): $e');
        }

        await _fetchUserProfile(response.user!.id);
        
        showSignupSuccess.value = true;
        await Future.delayed(const Duration(seconds: 2));
        
        _redirectBasedOnRole();

        Get.snackbar(
          'Success', 
          'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.7),
          colorText: Colors.white,
        );
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Signup Failed', 
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error', 
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _redirectBasedOnRole() {
    if (currentUser.value == null) return;

    switch (currentUser.value!.role) {
      case UserRole.admin:
        // Get.put(AdminController());
        Get.offAllNamed(Routes.home);
        break;
      case UserRole.vendor:
        Get.offAllNamed(Routes.vendorDashboard);
        break;
      case UserRole.customer:
        Get.offAllNamed(Routes.home);
        break;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    currentUser.value = null;
    Get.offAllNamed(Routes.login);
  }
}
