import 'package:dio/dio.dart';
import 'package:shop_passport/core/constants/storage_keys.dart';
import 'package:shop_passport/core/error/exceptions.dart';
import 'package:shop_passport/core/services/secure_storage_service.dart';
import '../constants/api_endpoints.dart';
import 'interceptors/auth_interceptor.dart';

// =========================================
// API CLIENT - Sob API calls ekhane theke hoy
// =========================================
class ApiClient {
  late Dio _dio; // Dio instance
  // final GetStorage _storage = GetStorage(); // Local storage
  final _secureStorage = SecureStorageService();

  // Constructor - Dio setup kore
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl, // Base URL set
      connectTimeout: const Duration(seconds: 30), // Connection timeout
      receiveTimeout: const Duration(seconds: 30), // Response timeout
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptors add - Token auto inject korar jonno
    _dio.interceptors.add(AuthInterceptor(_secureStorage));

    // Logging - Development e request/response dekhte paben
    _dio.interceptors.add(LogInterceptor(
      requestBody: true, // Request body show korbe
      responseBody: true, // Response body show korbe
      error: true, // Error show korbe
    ));


    // ✅ ADD THIS for better error handling
    // _dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onResponse: (response, handler) {
    //       // Handle global success responses
    //       return handler.next(response);
    //     },
    //     onError: (error, handler) async {
    //       // Handle 401 Unauthorized - Auto refresh token
    //       if (error.response?.statusCode == 401) {
    //         // Try to refresh token
    //         final newToken = await StorageKeys.refreshToken();
    //         if (newToken != null) {
    //           // Retry request with new token
    //           error.requestOptions.headers['Authorization'] =
    //           'Bearer $newToken';
    //           return handler.resolve(await _dio.fetch(error.requestOptions));
    //         }
    //       }
    //       return handler.next(error);
    //     },
    //   ),
    // );
  }

  // ====== GET REQUEST ======
  // Usage: apiClient.get('/api/events/')
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParams);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ====== POST REQUEST ======
  // Usage: apiClient.post('/api/login/', data: {'email': '...', 'password': '...'})
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ====== PUT REQUEST ======
  // Usage: apiClient.put('/api/profile/', data: {'name': 'New Name'})
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ====== DELETE REQUEST ======
  // Usage: apiClient.delete('/api/events/14/')
  Future<Response> delete(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ====== MULTIPART POST ======
  // File upload er jonno (Profile picture, etc)
  // Usage: apiClient.postMultipart('/api/profile/', formData: formData)
  Future<Response> postMultipart(String endpoint, {required FormData formData}) async {
    try {
      return await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ====== MULTIPART PUT ======
  // File update er jonno
  Future<Response> putMultipart(String endpoint, {required FormData formData}) async {
    try {
      return await _dio.put(
        endpoint,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ====== ERROR HANDLER ======
  // Error handle kore user-friendly message dey
  Exception _handleError(DioException error) {
    switch (error.type) {
    // Timeout errors
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException('Connection timeout - Please check your internet');

    // Server response error
      case DioExceptionType.badResponse:
        return ServerException(_parseErrorMessage(error.response));

    // Request cancelled
      case DioExceptionType.cancel:
        return ServerException('Request cancelled');

    // No internet or other errors
      default:
        return ServerException('No internet connection');
    }
  }


  // ====== PARSE ERROR MESSAGE ======
  // Response theke error message extract kore
  String _parseErrorMessage(Response? response) {
    if (response?.data is Map) {
      // 'message' key theke message nibe
      return response?.data['message'] ?? 'Something went wrong';
    }
    return 'Something went wrong';
  }
}



