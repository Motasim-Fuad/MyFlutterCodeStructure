import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_passport/core/constants/storage_keys.dart';

// =====================================================
// SECURE STORAGE SERVICE
// =====================================================
// WHY: Handle sensitive data (tokens, passwords) with encryption
//
// SECURITY FEATURES:
// - iOS: Stored in Keychain with kSecAttrAccessibleAfterFirstUnlock
// - Android: Encrypted with AES, stored in EncryptedSharedPreferences
// - Data encrypted at rest
// - Cannot be accessed without device unlock
// - Survives app reinstall (on iOS with iCloud backup)
//
// WHEN TO USE:
// ✅ JWT tokens
// ✅ API keys
// ✅ User credentials (if must be saved)
// ✅ Encryption keys
// ✅ Payment info
//
// WHEN NOT TO USE:
// ❌ Theme preference (use shared_preferences)
// ❌ Language setting (use shared_preferences)
// ❌ Non-sensitive user data (use shared_preferences)
// ❌ Cache data (use shared_preferences or hive)
//
// PERFORMANCE:
// - Slower than SharedPreferences
// - Use for critical data only
// - Consider caching frequently accessed data in memory
// =====================================================

class SecureStorageService {
  // ====== SINGLETON PATTERN ======
  // WHY: Only one instance needed throughout app
  // - Prevents multiple storage instances
  // - Consistent encryption keys
  // - Better memory management
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  // ====== STORAGE INSTANCE ======
  // WHY: Platform-specific secure storage wrapper
  late final FlutterSecureStorage _storage;

  // ====== INITIALIZATION ======
  // WHY: Configure security options per platform
  Future<void> init() async {
    // Android-specific options
    // WHY: Configure encryption for Android
    const androidOptions = AndroidOptions(
      encryptedSharedPreferences: true, // Use EncryptedSharedPreferences
      // WHY: Require device unlock to access
      // More secure but data lost if device reset
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    );

    // iOS-specific options
    // WHY: Configure keychain access on iOS
    const iosOptions = IOSOptions(
      // WHY: Data accessible after first unlock, but not while locked
      // Balance between security and usability
      accessibility: KeychainAccessibility.first_unlock_this_device,
      // WHY: Sync with iCloud for backup
      // Set to false if data shouldn't sync across devices
      synchronizable: false,
    );

    // Linux-specific options (for desktop support)
    const linuxOptions = LinuxOptions();

    // Windows-specific options (for desktop support)
    const windowsOptions = WindowsOptions();

    // Web options (Note: Not truly secure on web)
    // WHY: Web doesn't have true secure storage
    // Use only for non-critical data on web platform
    const webOptions = WebOptions();

    _storage = const FlutterSecureStorage(
      aOptions: androidOptions,
      iOptions: iosOptions,
      lOptions: linuxOptions,
      wOptions: windowsOptions,
      webOptions: webOptions,
    );
  }

  // ====== WRITE DATA ======
  // WHY: Store encrypted data
  // @param key: Storage key
  // @param value: Data to store (will be encrypted)
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      // WHY: Log error but don't throw - prevent app crash
      // Consider using proper error reporting service (Sentry, Firebase)
      print('SecureStorage Write Error: $e');
      rethrow; // Re-throw for controller to handle
    }
  }

  // ====== READ DATA ======
  // WHY: Retrieve and decrypt data
  // @returns: Decrypted value or null if not found
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print('SecureStorage Read Error: $e');
      return null; // Return null on error instead of throwing
    }
  }

  // ====== DELETE DATA ======
  // WHY: Remove specific key-value pair
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('SecureStorage Delete Error: $e');
      rethrow;
    }
  }

  // ====== DELETE ALL DATA ======
  // WHY: Clear all secure storage (useful for logout)
  // CAUTION: This deletes ALL encrypted data, not just app-specific
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('SecureStorage DeleteAll Error: $e');
      rethrow;
    }
  }

  // ====== CHECK IF KEY EXISTS ======
  // WHY: Verify if data exists before reading
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      print('SecureStorage ContainsKey Error: $e');
      return false;
    }
  }

  // ====== READ ALL DATA ======
  // WHY: Get all stored key-value pairs
  // Use carefully - can be slow with many items
  Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      print('SecureStorage ReadAll Error: $e');
      return {};
    }
  }

  // ====== SAVE ACCESS TOKEN ======
  // WHY: Convenience method for common operation
  // Encapsulates storage key logic
  Future<void> saveAccessToken(String token) async {
    await write(StorageKeys.accessToken, token);
  }

  // ====== GET ACCESS TOKEN ======
  Future<String?> getAccessToken() async {
    return await read(StorageKeys.accessToken);
  }

  // ====== SAVE REFRESH TOKEN ======
  Future<void> saveRefreshToken(String token) async {
    await write(StorageKeys.refreshToken, token);
  }

  // ====== GET REFRESH TOKEN ======
  Future<String?> getRefreshToken() async {
    return await read(StorageKeys.refreshToken);
  }

  // ====== DELETE TOKENS ======
  // WHY: Clear auth tokens on logout
  Future<void> deleteTokens() async {
    await delete(StorageKeys.accessToken);
    await delete(StorageKeys.refreshToken);
  }
}