// =====================================================
// FILE: lib/features/settings/presentation/pages/settings_page.dart
// =====================================================
// UPDATED: Now uses LocalizationConfig for cleaner code
// =====================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/config/localization/app_translations.dart';
import '../../../../core/config/localization/localization_config.dart';  // ← NEW
import '../../../../core/utils/logger.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();


    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationKeys.settings.tr),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ====== THEME SECTION ======
          _buildSectionTitle(TranslationKeys.theme.tr),
          const SizedBox(height: 8),
          _buildThemeCard(themeService),
          const SizedBox(height: 24),

          // ====== LANGUAGE SECTION ======
          _buildSectionTitle(TranslationKeys.language.tr),
          const SizedBox(height: 8),
          _buildLanguageCard(),
        ],
      ),
    );
  }

  // ====== SECTION TITLE ======
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  // ====== THEME CARD ======
  Widget _buildThemeCard(ThemeService themeService) {
    return Card(
      child: Column(
        children: [
          // Light Mode
          Obx(() => RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: themeService.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                themeService.changeThemeMode(mode);
                AppLogger.info('🎨 Theme changed to: Light');
              }
            },
            title: Text(TranslationKeys.lightMode.tr),
            secondary: const Icon(Icons.light_mode),
          )),

          const Divider(height: 1),

          // Dark Mode
          Obx(() => RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: themeService.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                themeService.changeThemeMode(mode);
                AppLogger.info('🎨 Theme changed to: Dark');
              }
            },
            title: Text(TranslationKeys.darkMode.tr),
            secondary: const Icon(Icons.dark_mode),
          )),

          const Divider(height: 1),

          // System Default
          Obx(() => RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: themeService.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                themeService.changeThemeMode(mode);
                AppLogger.info('🎨 Theme changed to: System');
              }
            },
            title: Text(TranslationKeys.systemDefault.tr),
            secondary: const Icon(Icons.settings_suggest),
          )),
        ],
      ),
    );
  }

  // ====== LANGUAGE CARD - REUSABLE VERSION ======
  Widget _buildLanguageCard() {
    // Get all available locales
    final localeOptions = LocalizationConfig.getLocaleOptions();

    return Card(
      child: Column(
        children: [
          for (int i = 0; i < localeOptions.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            _buildLanguageTile(localeOptions[i]),
          ],
        ],
      ),
    );
  }

  // ====== LANGUAGE TILE ======
  Widget _buildLanguageTile(LocaleOption option) {
    return ListTile(
      leading: Text(
        option.flag,
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(option.nativeName),
      subtitle: Text(option.name),
      trailing: option.isActive
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: () => _changeLanguage(option),
    );
  }

  // ====== CHANGE LANGUAGE - REUSABLE ======
  Future<void> _changeLanguage(LocaleOption option) async {
    try {
      // Use centralized locale change
      await LocalizationConfig.changeLocale(option.locale);

      AppLogger.info('🌐 Language changed to: ${option.name}');

      // Show success message
      Get.snackbar(
        TranslationKeys.success.tr,
        'Language changed to ${option.nativeName}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      AppLogger.error('Failed to change language', e);

      Get.snackbar(
        TranslationKeys.error.tr,
        'Failed to change language',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}