import 'dart:ui';

import 'package:get/get.dart';

// =====================================================
// APP TRANSLATIONS
// =====================================================
// WHY: Centralized translation management
// - Easy to add new languages
// - Type-safe translation keys
// - Hot reload support
// - GetX built-in localization
// =====================================================

class AppTranslations extends Translations {
  // ====== SUPPORTED LOCALES ======
  // WHY: Define which languages your app supports
  static const Locale enUS = Locale('en', 'US');
  static const Locale bnBD = Locale('bn', 'BD');

  // WHY: Default fallback language
  static const Locale fallbackLocale = enUS;

  // WHY: List of all supported locales
  static const List<Locale> supportedLocales = [
    enUS,
    bnBD,
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    // ====== ENGLISH ======
    'en_US': {
      // General
      'app_name': 'Shop Passport',
      'welcome': 'Welcome',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'retry': 'Retry',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'delete': 'Delete',
      'edit': 'Edit',
      'save': 'Save',
      'update': 'Update',
      'search': 'Search',

      // Auth
      'login': 'Login',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'login_button': 'Login',
      'login_success': 'Login successful!',
      'login_failed': 'Login failed',
      'logging_in': 'Logging in...',
      'logout_confirm': 'Are you sure you want to logout?',
      'email_required': 'Please enter email',
      'email_invalid': 'Please enter valid email',
      'password_required': 'Please enter password',
      'password_min_length': 'Password must be at least 6 characters',

      // Home/Events
      'my_events': 'My Events',
      'no_events': 'No events found',
      'no_events_subtext': "You haven't created any events yet",
      'loading_events': 'Loading events...',
      'delete_event': 'Delete Event',
      'delete_event_confirm': 'Are you sure you want to delete this event?',
      'event_deleted': 'Event deleted successfully',
      'view_details': 'View Details',

      // Profile
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'update_profile': 'Update Profile',
      'updating': 'Updating...',
      'profile_updated': 'Profile updated successfully',
      'loading_profile': 'Loading profile...',
      'name': 'Name',
      'phone': 'Phone',
      'bio': 'Bio',
      'name_required': 'Name cannot be empty',
      'phone_required': 'Phone cannot be empty',

      // Settings
      'settings': 'Settings',
      'theme': 'Theme',
      'language': 'Language',
      'light_mode': 'Light Mode',
      'dark_mode': 'Dark Mode',
      'system_default': 'System Default',

      // Errors
      'something_went_wrong': 'Oops! Something went wrong',
      'no_internet': 'No internet connection',
      'server_error': 'Server error occurred',
      'timeout': 'Connection timeout',
    },

    // ====== BANGLA ======
    'bn_BD': {
      // General
      'app_name': 'শপ পাসপোর্ট',
      'welcome': 'স্বাগতম',
      'loading': 'লোড হচ্ছে...',
      'error': 'ত্রুটি',
      'success': 'সফল',
      'retry': 'পুনরায় চেষ্টা করুন',
      'cancel': 'বাতিল',
      'confirm': 'নিশ্চিত করুন',
      'delete': 'মুছুন',
      'edit': 'সম্পাদনা',
      'save': 'সংরক্ষণ',
      'update': 'আপডেট',
      'search': 'খুঁজুন',

      // Auth
      'login': 'লগইন',
      'logout': 'লগআউট',
      'email': 'ইমেইল',
      'password': 'পাসওয়ার্ড',
      'login_button': 'লগইন করুন',
      'login_success': 'লগইন সফল হয়েছে!',
      'login_failed': 'লগইন ব্যর্থ',
      'logging_in': 'লগইন হচ্ছে...',
      'logout_confirm': 'আপনি কি নিশ্চিত লগআউট করতে চান?',
      'email_required': 'ইমেইল লিখুন',
      'email_invalid': 'সঠিক ইমেইল লিখুন',
      'password_required': 'পাসওয়ার্ড লিখুন',
      'password_min_length': 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে',

      // Home/Events
      'my_events': 'আমার ইভেন্ট',
      'no_events': 'কোন ইভেন্ট নেই',
      'no_events_subtext': 'আপনি এখনও কোন ইভেন্ট তৈরি করেননি',
      'loading_events': 'ইভেন্ট লোড হচ্ছে...',
      'delete_event': 'ইভেন্ট মুছুন',
      'delete_event_confirm': 'আপনি কি নিশ্চিত এই ইভেন্টটি মুছতে চান?',
      'event_deleted': 'ইভেন্ট সফলভাবে মুছে ফেলা হয়েছে',
      'view_details': 'বিস্তারিত দেখুন',

      // Profile
      'profile': 'প্রোফাইল',
      'edit_profile': 'প্রোফাইল সম্পাদনা',
      'update_profile': 'প্রোফাইল আপডেট',
      'updating': 'আপডেট হচ্ছে...',
      'profile_updated': 'প্রোফাইল সফলভাবে আপডেট হয়েছে',
      'loading_profile': 'প্রোফাইল লোড হচ্ছে...',
      'name': 'নাম',
      'phone': 'ফোন',
      'bio': 'বায়ো',
      'name_required': 'নাম খালি রাখা যাবে না',
      'phone_required': 'ফোন খালি রাখা যাবে না',

      // Settings
      'settings': 'সেটিংস',
      'theme': 'থিম',
      'language': 'ভাষা',
      'light_mode': 'লাইট মোড',
      'dark_mode': 'ডার্ক মোড',
      'system_default': 'সিস্টেম ডিফল্ট',

      // Errors
      'something_went_wrong': 'ওহ! কিছু ভুল হয়েছে',
      'no_internet': 'ইন্টারনেট সংযোগ নেই',
      'server_error': 'সার্ভার ত্রুটি ঘটেছে',
      'timeout': 'সংযোগ টাইমআউট',
    },
  };
}

// =====================================================
// TRANSLATION KEYS CLASS
// =====================================================
// WHY: Type-safe translation keys
// - Autocomplete support
// - Prevents typos
// - Easy refactoring
// =====================================================

class TranslationKeys {
  TranslationKeys._();

  // General
  static const String appName = 'app_name';
  static const String welcome = 'welcome';
  static const String loading = 'loading';
  static const String error = 'error';
  static const String success = 'success';
  static const String retry = 'retry';
  static const String cancel = 'cancel';
  static const String confirm = 'confirm';
  static const String delete = 'delete';
  static const String edit = 'edit';
  static const String save = 'save';
  static const String update = 'update';
  static const String search = 'search';

  // Auth
  static const String login = 'login';
  static const String logout = 'logout';
  static const String email = 'email';
  static const String password = 'password';
  static const String loginButton = 'login_button';
  static const String loginSuccess = 'login_success';
  static const String loginFailed = 'login_failed';
  static const String loggingIn = 'logging_in';
  static const String logoutConfirm = 'logout_confirm';
  static const String emailRequired = 'email_required';
  static const String emailInvalid = 'email_invalid';
  static const String passwordRequired = 'password_required';
  static const String passwordMinLength = 'password_min_length';

  // Home/Events
  static const String myEvents = 'my_events';
  static const String noEvents = 'no_events';
  static const String noEventsSubtext = 'no_events_subtext';
  static const String loadingEvents = 'loading_events';
  static const String deleteEvent = 'delete_event';
  static const String deleteEventConfirm = 'delete_event_confirm';
  static const String eventDeleted = 'event_deleted';
  static const String viewDetails = 'view_details';

  // Profile
  static const String profile = 'profile';
  static const String editProfile = 'edit_profile';
  static const String updateProfile = 'update_profile';
  static const String updating = 'updating';
  static const String profileUpdated = 'profile_updated';
  static const String loadingProfile = 'loading_profile';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String bio = 'bio';
  static const String nameRequired = 'name_required';
  static const String phoneRequired = 'phone_required';

  // Settings
  static const String settings = 'settings';
  static const String theme = 'theme';
  static const String language = 'language';
  static const String lightMode = 'light_mode';
  static const String darkMode = 'dark_mode';
  static const String systemDefault = 'system_default';

  // Errors
  static const String somethingWentWrong = 'something_went_wrong';
  static const String noInternet = 'no_internet';
  static const String serverError = 'server_error';
  static const String timeout = 'timeout';
}