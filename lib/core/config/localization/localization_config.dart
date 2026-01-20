
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'app_translations.dart';
import '../../services/local_storage_service.dart';

class LocalizationConfig {
  LocalizationConfig._(); // Private constructor for utility class

  // LOCALIZATION DELEGATES
  // WHY: Provides built-in Flutter widget translations
  // USAGE: Add to GetMaterialApp's localizationsDelegates
  static const List<LocalizationsDelegate<dynamic>> delegates = [
    GlobalMaterialLocalizations.delegate,  // Material Design widgets
    GlobalWidgetsLocalizations.delegate,   // Text direction & basic widgets
    GlobalCupertinoLocalizations.delegate, // iOS style widgets
  ];

  // SUPPORTED LOCALES
  // WHY: List of all languages your app supports
  // USAGE: Add to GetMaterialApp's supportedLocales
  static const List<Locale> supportedLocales = AppTranslations.supportedLocales;

  //  FALLBACK LOCALE
  // WHY: Default language if saved/device language not found
  static const Locale fallbackLocale = AppTranslations.fallbackLocale;

  // GET INITIAL LOCALE
  // WHY: Smart locale detection (Saved → Device → Fallback)
  // REUSABLE: Works with any locale configuration
  static Locale getInitialLocale() {
    final localStorage = LocalStorageService();
    final savedLanguage = localStorage.getLanguageCode();

    // 1. Check saved preference
    if (savedLanguage != null) {
      final locale = _getLocaleFromLanguageCode(savedLanguage);
      if (locale != null) return locale;
    }

    // 2. Check device locale
    final deviceLocale = Get.deviceLocale;
    if (deviceLocale != null && _isSupportedLocale(deviceLocale)) {
      return deviceLocale;
    }

    // 3. Return fallback
    return fallbackLocale;
  }

  //  CHANGE LOCALE
  // WHY: Centralized locale changing with persistence
  // REUSABLE: Handles locale change + storage in one place
  static Future<void> changeLocale(Locale locale) async {
    // Validate locale
    if (!_isSupportedLocale(locale)) {
      throw Exception('Locale ${locale.languageCode} is not supported');
    }

    // Update GetX locale
    Get.updateLocale(locale);

    // Save to storage
    final localStorage = LocalStorageService();
    await localStorage.setLanguageCode(locale.languageCode);
  }

  //HELPER: GET LOCALE FROM LANGUAGE CODE
  static Locale? _getLocaleFromLanguageCode(String languageCode) {
    for (final locale in supportedLocales) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }
    return null;
  }

  //  HELPER: CHECK IF LOCALE IS SUPPORTED
  static bool _isSupportedLocale(Locale locale) {
    return supportedLocales.any(
          (l) => l.languageCode == locale.languageCode,
    );
  }

  // GET CURRENT LOCALE NAME
  // WHY: Display language name in UI
  static String getCurrentLocaleName() {
    final locale = Get.locale ?? fallbackLocale;
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'bn':
        return 'বাংলা';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  //  GET ALL LOCALES WITH NAMES
  // WHY: For language selection dropdown/list
  static List<LocaleOption> getLocaleOptions() {
    return [
      LocaleOption(
        locale: AppTranslations.enUS,
        name: 'English',
        nativeName: 'English',
        flag: '🇺🇸',
      ),
      LocaleOption(
        locale: AppTranslations.bnBD,
        name: 'Bangla',
        nativeName: 'বাংলা',
        flag: '🇧🇩',
      ),
    ];
  }
}

// LOCALE OPTION MODEL
// WHY: Clean data structure for locale options
// REUSABLE: Can be used in dropdowns, lists, settings

class LocaleOption {
  final Locale locale;
  final String name;        // English name
  final String nativeName;  // Native language name
  final String flag;        // Emoji flag

  LocaleOption({
    required this.locale,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  bool get isActive => Get.locale?.languageCode == locale.languageCode;
}