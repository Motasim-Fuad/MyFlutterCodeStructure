// =====================================================
// STORAGE KEYS
// =====================================================
// WHY: Centralized storage key management
// - Prevents typos in keys
// - Easy to maintain
// - Clear separation of secure vs non-secure data
// =====================================================

class StorageKeys {
  StorageKeys._();

  // ====== SECURE STORAGE KEYS ======
  // WHY: These store sensitive data and use flutter_secure_storage
  // - Encrypted at rest
  // - Platform-specific secure storage (Keychain/Keystore)
  // - Cannot be accessed by other apps

  // JWT Access Token
  // WHY: Used for API authentication, needs encryption
  static const String accessToken = 'secure_access_token';

  // JWT Refresh Token
  // WHY: Used to get new access token, highly sensitive
  static const String refreshToken = 'secure_refresh_token';

  // User Password (if saved)
  // WHY: Never store plain passwords, but if needed, must be encrypted
  static const String savedPassword = 'secure_saved_password';

  // API Keys
  // WHY: Third-party API keys need secure storage
  static const String apiKey = 'secure_api_key';


  // ====== SHARED PREFERENCES KEYS ======
  // WHY: These store non-sensitive data and use shared_preferences
  // - Faster than secure storage
  // - No encryption overhead
  // - OK for non-critical data

  // User Data (non-sensitive info)
  // WHY: User name, email, etc. - not secret but needs persistence
  static const String userData = 'user_data';

  // Login Status
  // WHY: Quick check if user logged in, no sensitive data
  static const String isLoggedIn = 'is_logged_in';

  // Theme Mode (light/dark/system)
  // WHY: UI preference, no security concern
  static const String themeMode = 'theme_mode';

  // Language Code (en/bn)
  // WHY: Language preference, public data
  static const String languageCode = 'language_code';

  // Last Login Date
  // WHY: For analytics, not sensitive
  static const String lastLoginDate = 'last_login_date';

  // App Version
  // WHY: For migration logic, public data
  static const String appVersion = 'app_version';

  // First Time Launch
  // WHY: Show onboarding, public data
  static const String isFirstLaunch = 'is_first_launch';

  // Tutorial Completed
  // WHY: UI state, no security issue
  static const String tutorialCompleted = 'tutorial_completed';
}