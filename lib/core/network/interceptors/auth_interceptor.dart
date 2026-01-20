import 'package:dio/dio.dart';
import 'package:shop_passport/core/constants/storage_keys.dart';
import 'package:shop_passport/core/services/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService storage;

  AuthInterceptor(this.storage);

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      final isAuthEndpoint = options.path.contains('/auth/login') ||
          options.path.contains('/auth/register') ||
          options.path.contains('/auth/refresh');

      if (isAuthEndpoint) {
        return handler.next(options);
      }

      // Baki shob endpoint e token add koro
      final token = await storage.read(StorageKeys.accessToken);

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } catch (e) {
      handler.next(options);
    }
  }
}