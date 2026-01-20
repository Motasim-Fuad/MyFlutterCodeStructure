import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_passport/core/config/theme/app_colors.dart';
import 'package:shop_passport/core/services/local_storage_service.dart';
import 'package:shop_passport/core/services/secure_storage_service.dart';
import 'package:shop_passport/core/services/theme_service.dart';
import 'package:shop_passport/core/utils/logger.dart';
import '../core/config/localization/app_translations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // WHY: .tr extension translates the key
        Text(TranslationKeys.welcome.tr),

        // WHY: Fallback if translation missing
        Text('custom_key'.tr),

        // WHY: Use in buttons
        ElevatedButton(
          onPressed: () {},
          child: Text(TranslationKeys.loginButton.tr),
        ),
      ],
    );
  }
}



class ThemedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // WHY: Use theme-aware colors
      color: Theme.of(context).colorScheme.primary,

      // WHY: Or use defined colors
      decoration: BoxDecoration(
        color: AppColors.primary,
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
        ),
      ),

      child: Text(
        'Hello',
        // WHY: Use theme text style
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}




class ThemeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return IconButton(
      icon: Obx(() => Icon(
        themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
      )),
      onPressed: () {
        // WHY: Toggle between light and dark
        themeService.toggleTheme();
      },
    );
  }
}




class SecureDataExample {
  final _secureStorage = SecureStorageService();

  Future<void> saveToken(String token) async {
    // WHY: Store sensitive data with encryption
    await _secureStorage.saveAccessToken(token);
    AppLogger.info('🔐 Token saved securely');
  }

  Future<String?> getToken() async {
    // WHY: Retrieve encrypted data
    return await _secureStorage.getAccessToken();
  }
}




class PreferencesExample {
  final _localStorage = LocalStorageService();

  Future<void> savePreference() async {
    // WHY: Store non-sensitive data (fast access)
    await _localStorage.setBool('notifications_enabled', true);
    await _localStorage.setString('username', 'John Doe');
  }

  bool getNotificationStatus() {
    return _localStorage.getBool('notifications_enabled') ?? true;
  }
}