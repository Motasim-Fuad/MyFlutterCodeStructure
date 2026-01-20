import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../shared/widgets/custom_button.dart';

// =========================================
// LOGIN PAGE - UI
// =========================================
class LoginPage extends GetView<AuthController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // ====== APP LOGO ======
              const Icon(
                Icons.shopping_bag,
                size: 80,
                color: Color(0xFF2196F3),
              ),
              const SizedBox(height: 16),

              // ====== APP TITLE ======
              Text(
                'Shop Passport',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2196F3),
                ),
              ),
              const SizedBox(height: 8),

              // ====== SUBTITLE ======
              Text(
                'Login to continue',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),

              // ====== EMAIL FIELD ======
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ====== PASSWORD FIELD ======
              // Obx = Observable - isPasswordVisible change hole rebuild hobe
              Obx(() => TextField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value, // Show/hide
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  // Toggle visibility button
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )),
              const SizedBox(height: 24),

              // ====== LOGIN BUTTON ======
              // Obx - isLoading change hole button update hobe
              Obx(() => CustomButton(
                title: 'Login',
                onPress: controller.login, // Login method call
                loading: controller.isLoading.value, // Loading state
                loadingText: 'Logging in...',
                showLoader: true, // Spinner show
                showLoadingText: true, // Loading text show
                height: 56,
                width: double.infinity, // Full width
                buttonColor: const Color(0xFF2196F3),
              )),

              const SizedBox(height: 24),

              // ====== DEMO CREDENTIALS INFO ======
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Credentials',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: eventadmin@test.com',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                    Text(
                      'Password: Your demo password',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}