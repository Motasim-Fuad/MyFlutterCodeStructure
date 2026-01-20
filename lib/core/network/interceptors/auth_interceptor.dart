
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
      ) async {  // Make async
    try {
      //Await the token
      final token = await storage.read(StorageKeys.accessToken);

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } catch (e) {
      handler.next(options); // Continue without token if error
    }
  }
}