import '../../../../core/error/exceptions.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  // Need separate storages for different data types
  final SecureStorageService _secureStorage = SecureStorageService();
  final LocalStorageService _localStorage = LocalStorageService();

  AuthRemoteDataSource({
    required this.apiClient,
  });

  // LOGIN
  Future<UserModel> login(String email, String password) async {
    AppLogger.api(
      ApiEndpoints.login,
      method: 'POST',
      request: {'email': email, 'password': '***'},
    );

    final response = await apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;

      AppLogger.api(
        ApiEndpoints.login,
        statusCode: response.statusCode,
        response: 'Login successful',
      );

      //Save tokens to SECURE storage

      if (data['data']?['access'] != null) {
        await _secureStorage.saveAccessToken(data['data']['access']);
        AppLogger.info('Access token saved securely');
      }

      if (data['data']?['refresh'] != null) {
        await _secureStorage.saveRefreshToken(data['data']['refresh']);
        AppLogger.info(' Refresh token saved securely');
      }

      //Save user data to LOCAL storage

      final user = UserModel.fromJson(data['data']['user']);
      await _localStorage.saveUserData(user.toJson());
      await _localStorage.setLoggedIn(true);
      AppLogger.info(' User data saved locally');

      return user;
    } else {
      throw ServerException(response.data['message'] ?? 'Login failed');
    }
  }

  // LOGOUT
  Future<void> logout() async {
    AppLogger.info('Clearing storage...');

    //Clear both storages
    await _secureStorage.deleteTokens();
    await _localStorage.clear();

    AppLogger.info('✅ Storage cleared');
  }
}
