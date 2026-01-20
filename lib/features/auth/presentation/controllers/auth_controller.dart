import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/config/localization/app_translations.dart';
import '../../../../core/utils/logger.dart';
import '../../../../config/routes/app_routes.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class AuthController extends GetxController {
  // DEPENDENCIES
  final AuthRepository repository;

  // WHY: Directly initialize services (singleton pattern)
  // No need to pass as constructor parameters
  final SecureStorageService _secureStorage = SecureStorageService();
  final LocalStorageService _localStorage = LocalStorageService();

  AuthController({
    required this.repository,
  });

  //OBSERVABLES
  final isLoading = false.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  //FORM CONTROLLERS
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;

  //ON INIT
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // CHECK LOGIN STATUS
  void checkLoginStatus() async {
    AppLogger.info('🔍 Checking login status...');

    // WHY: Check local storage first (faster)
    if (_localStorage.isLoggedIn()) {
      // Load user data from local storage
      final userData = _localStorage.getUserData();
      if (userData != null) {
        currentUser.value = UserModel.fromJson(userData);

        // WHY: Verify token exists in secure storage
        final token = await _secureStorage.getAccessToken();
        if (token != null) {
          AppLogger.info('✅ User already logged in');
          Get.offAllNamed(AppRoutes.main);
          return;
        }
      }

      // WHY: If token missing, logout user
      AppLogger.warning('⚠️ Token missing, logging out');
      await logout(silent: true);
    }
  }

  // TOGGLE PASSWORD VISIBILITY
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  //LOGIN METHOD
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!_validateInputs(email, password)) return;

    isLoading.value = true;
    AppLogger.info('🔐 Attempting login for: $email');

    final result = await repository.login(email, password);

    result.fold(
      // ERROR CASE
          (failure) {
        isLoading.value = false;
        AppLogger.error('❌ Login failed', failure.message);

        Get.snackbar(
          TranslationKeys.error.tr,
          failure.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },

      // SUCCESS CASE
          (user) async {
        isLoading.value = false;
        currentUser.value = user;

        AppLogger.info('✅ Login successful for: ${user.email}');

        Get.offAllNamed(AppRoutes.main);

        Get.snackbar(
          TranslationKeys.success.tr,
          TranslationKeys.loginSuccess.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  // LOGOUT METHOD
  Future<void> logout({bool silent = false}) async {
    if (!silent) {
      Get.dialog(
        AlertDialog(
          title: Text(TranslationKeys.logout.tr),
          content: Text(TranslationKeys.logoutConfirm.tr),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(TranslationKeys.cancel.tr),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                await _performLogout();
              },
              child: Text(
                TranslationKeys.logout.tr,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    } else {
      await _performLogout();
    }
  }

  //  PERFORM LOGOUT
  Future<void> _performLogout() async {
    isLoading.value = true;
    AppLogger.info('🚪 Logging out...');

    final result = await repository.logout();

    result.fold(
          (failure) {
        isLoading.value = false;
        AppLogger.error('❌ Logout failed', failure.message);
        Get.snackbar(TranslationKeys.error.tr, failure.message);
      },
          (_) {
        isLoading.value = false;
        currentUser.value = null;

        AppLogger.info('✅ Logout successful');
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }

  //  VALIDATE INPUTS
  bool _validateInputs(String email, String password) {
    if (email.isEmpty) {
      Get.snackbar(
        TranslationKeys.error.tr,
        TranslationKeys.emailRequired.tr,
      );
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        TranslationKeys.error.tr,
        TranslationKeys.emailInvalid.tr,
      );
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar(
        TranslationKeys.error.tr,
        TranslationKeys.passwordRequired.tr,
      );
      return false;
    }

    if (password.length < 6) {
      Get.snackbar(
        TranslationKeys.error.tr,
        TranslationKeys.passwordMinLength.tr,
      );
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}