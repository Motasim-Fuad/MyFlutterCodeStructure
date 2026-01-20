import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/models/user_model.dart';

//PROFILE REPOSITORY INTERFACE

abstract class ProfileRepository {
  // Get Profile
  Future<Either<Failure, UserModel>> getProfile();

  //Update Profile
  Future<Either<Failure, UserModel>> updateProfile({
    String? name,
    String? phone,
    File? profilePicture,
  });
}