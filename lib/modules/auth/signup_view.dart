import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../widgets/app_text_field.dart';
import 'auth_controller.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController     = TextEditingController();
  final _controller         = Get.find<AuthController>();

  UserRole _selectedRole = UserRole.customer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).primaryColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                Text(
                  'CREATE ACCOUNT',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  'Join the movement',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 48),

                // Role selector
                _buildRoleSelector(),

                const SizedBox(height: 32),

                AppTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your name',
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 20),

                AppTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 20),

                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Create a password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 40),

                // Sign up button
                Obx(() {
                  final isLoading = _controller.isLoading.value;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => _controller.signUp(
                              email: _emailController.text,
                              password: _passwordController.text,
                              fullName: _nameController.text,
                              role: _selectedRole,
                            ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('JOIN SHOPONS'),
                  );
                }),

                const SizedBox(height: 24),

                Center(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'LOGIN',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Success banner
                Obx(() => _controller.showSignupSuccess.value
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Theme.of(context).primaryColor),
                        ),
                        child: Center(
                          child: Text(
                            "Welcome to SHOPONS! 🎉",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I WANT TO REGISTER AS A',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: _selectedRole == UserRole.customer
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 64) / 2,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedRole = UserRole.customer),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Text(
                          'CUSTOMER',
                          style: TextStyle(
                            color: _selectedRole == UserRole.customer
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedRole = UserRole.vendor),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Text(
                          'VENDOR',
                          style: TextStyle(
                            color: _selectedRole == UserRole.vendor
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
