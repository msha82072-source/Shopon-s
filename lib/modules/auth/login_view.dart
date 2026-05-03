import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_constants.dart';
import '../../widgets/app_text_field.dart';
import 'auth_controller.dart';
import '../../routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _controller         = Get.put(AuthController());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 64),

                // Brand name
                Text(
                  AppConstants.appName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 8),

                // Welcome text
                Text(
                  'WELCOME BACK',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 64),

                // Email field
                AppTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 24),

                // Password field
                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Login button
                Obx(() {
                  final isLoading = _controller.isLoading.value;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => _controller.login(
                              _emailController.text,
                              _passwordController.text,
                            ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('LOGIN'),
                  );
                }),

                const SizedBox(height: 32),

                // Navigation to Signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.signup),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
