import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shop_passport/core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/data/models/user_model.dart';

class ProfileRemoteDataSource {
  final ApiClient apiClient;

  // Both storage services
  final SecureStorageService _secureStorage = SecureStorageService();
  final LocalStorageService _localStorage = LocalStorageService();

  // Removed storageService parameter
  ProfileRemoteDataSource({
    required this.apiClient,
  });

  // GET PROFILE
  Future<UserModel> getProfile() async {
    final response = await apiClient.get(ApiEndpoints.profile);

    if (response.statusCode == 200) {
      final user = UserModel.fromJson(response.data['data']);

      // Save to local storage
      await _localStorage.saveUserData(user.toJson());

      return user;
    } else {
      throw ServerException(response.data['message'] ?? 'Failed to load profile');
    }
  }

  // UPDATE PROFILE
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    File? profilePicture,
  }) async {
    FormData formData = FormData.fromMap({
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (profilePicture != null)
        'profile_picture': await MultipartFile.fromFile(
          profilePicture.path,
          filename: profilePicture.path.split('/').last,
        ),
    });

    final response = await apiClient.putMultipart(
      ApiEndpoints.profile,
      formData: formData,
    );

    if (response.statusCode == 200) {
      final user = UserModel.fromJson(response.data['data']);

      // Save to local storage
      await _localStorage.saveUserData(user.toJson());

      return user;
    } else {
      throw ServerException(response.data['message'] ?? 'Failed to update profile');
    }
  }
}