import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';



class LocalStorageService {
  // SINGLETON PATTERN
  // WHY: Single instance for consistent data access
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  //SHARED PREFERENCES INSTANCE
  SharedPreferences? _prefs;

  //INITIALIZATION
  // WHY: Load shared preferences at app startup
  // Must be called before using service .
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //ENSURE INITIALIZED
  // WHY: Safety check before operations
  void _ensureInitialized() {
    if (_prefs == null) {
      throw Exception(
        'LocalStorageService not initialized. Call init() first.',
      );
    }
  }

  //STRING OPERATIONS

  // Save string
  Future<bool> setString(String key, String value) async {
    _ensureInitialized();
    return await _prefs!.setString(key, value);
  }

  // Get string
  String? getString(String key) {
    _ensureInitialized();
    return _prefs!.getString(key);
  }

  //INT OPERATIONS

  Future<bool> setInt(String key, int value) async {
    _ensureInitialized();
    return await _prefs!.setInt(key, value);
  }

  int? getInt(String key) {
    _ensureInitialized();
    return _prefs!.getInt(key);
  }

  //BOOL OPERATIONS

  Future<bool> setBool(String key, bool value) async {
    _ensureInitialized();
    return await _prefs!.setBool(key, value);
  }

  bool? getBool(String key) {
    _ensureInitialized();
    return _prefs!.getBool(key);
  }

  //DOUBLE OPERATIONS

  Future<bool> setDouble(String key, double value) async {
    _ensureInitialized();
    return await _prefs!.setDouble(key, value);
  }

  double? getDouble(String key) {
    _ensureInitialized();
    return _prefs!.getDouble(key);
  }

  //LIST OPERATIONS

  Future<bool> setStringList(String key, List<String> value) async {
    _ensureInitialized();
    return await _prefs!.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    _ensureInitialized();
    return _prefs!.getStringList(key);
  }

  //JSON OPERATIONS
  // WHY: Store complex objects as JSON strings

  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    _ensureInitialized();
    return await _prefs!.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getJson(String key) {
    _ensureInitialized();
    final jsonString = _prefs!.getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('LocalStorage JSON Parse Error: $e');
      return null;
    }
  }

  // DELETE OPERATIONS
  Future<bool> remove(String key) async {
    _ensureInitialized();
    return await _prefs!.remove(key);
  }

  Future<bool> clear() async {
    _ensureInitialized();
    return await _prefs!.clear();
  }

  // CHECK OPERATIONS

  bool containsKey(String key) {
    _ensureInitialized();
    return _prefs!.containsKey(key);
  }

  Set<String> getKeys() {
    _ensureInitialized();
    return _prefs!.getKeys();
  }

  //CONVENIENCE METHODS
  // WHY: Common operations with predefined keys

  // User Data
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    return await setJson(StorageKeys.userData, userData);
  }

  Map<String, dynamic>? getUserData() {
    return getJson(StorageKeys.userData);
  }

  // Login Status
  Future<bool> setLoggedIn(bool value) async {
    return await setBool(StorageKeys.isLoggedIn, value);
  }

  bool isLoggedIn() {
    return getBool(StorageKeys.isLoggedIn) ?? false;
  }

  // Theme Mode
  Future<bool> setThemeMode(String mode) async {
    return await setString(StorageKeys.themeMode, mode);
  }

  String? getThemeMode() {
    return getString(StorageKeys.themeMode);
  }

  // Language Code
  Future<bool> setLanguageCode(String code) async {
    return await setString(StorageKeys.languageCode, code);
  }

  String? getLanguageCode() {
    return getString(StorageKeys.languageCode);
  }

  // First Launch
  Future<bool> setFirstLaunch(bool value) async {
    return await setBool(StorageKeys.isFirstLaunch, value);
  }

  bool isFirstLaunch() {
    return getBool(StorageKeys.isFirstLaunch) ?? true;
  }
}