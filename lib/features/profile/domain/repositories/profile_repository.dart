import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/models/user_model.dart';

// =========================================
// PROFILE REPOSITORY INTERFACE
// =========================================
abstract class ProfileRepository {
  // Profile get koro
  Future<Either<Failure, UserModel>> getProfile();

  // Profile update koro (name, phone, image)
  Future<Either<Failure, UserModel>> updateProfile({
    String? name,
    String? phone,
    File? profilePicture, // Image file (nullable)
  });
}