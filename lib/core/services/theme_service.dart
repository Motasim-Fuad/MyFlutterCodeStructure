import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'local_storage_service.dart';

class ThemeService extends GetxService {
  //  DEPENDENCIES
  final LocalStorageService _storage = LocalStorageService();

  // THEME MODE
  // WHY: Observable theme mode for reactive UI updates
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  //  THEME MODE VALUES
  static const String light = 'light';
  static const String dark = 'dark';
  static const String system = 'system';

  //  INITIALIZATION
  // WHY: Load saved theme preference on app start
  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  //  LOAD THEME MODE
  // WHY: Restore user's theme preference from storage
  void _loadThemeMode() {
    final savedMode = _storage.getThemeMode();

    if (savedMode != null) {
      // Convert string to ThemeMode enum
      switch (savedMode) {
        case light:
          _themeMode.value = ThemeMode.light;
          break;
        case dark:
          _themeMode.value = ThemeMode.dark;
          break;
        case system:
          _themeMode.value = ThemeMode.system;
          break;
        default:
          _themeMode.value = ThemeMode.system;
      }
    }
  }

  //CHANGE THEME MODE
  // WHY: Update theme and save preference
  Future<void> changeThemeMode(ThemeMode mode) async {
    // Update observable
    _themeMode.value = mode;

    // Update GetX theme
    Get.changeThemeMode(mode);

    // Save to storage
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = light;
        break;
      case ThemeMode.dark:
        modeString = dark;
        break;
      case ThemeMode.system:
        modeString = system;
        break;
    }

    await _storage.setThemeMode(modeString);
  }

  // TOGGLE THEME
  // WHY: Quick switch between light and dark
  // System mode users will get light as default
  Future<void> toggleTheme() async {
    if (_themeMode.value == ThemeMode.light) {
      await changeThemeMode(ThemeMode.dark);
    } else {
      await changeThemeMode(ThemeMode.light);
    }
  }

  //IS DARK MODE
  // WHY: Check current effective theme
  // Considers system preference for system mode
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.dark) return true;
    if (_themeMode.value == ThemeMode.light) return false;

    // System mode - check device theme
    return Get.isDarkMode;
  }

  // IS LIGHT MODE
  bool get isLightMode => !isDarkMode;

  // IS SYSTEM MODE
  bool get isSystemMode => _themeMode.value == ThemeMode.system;
}