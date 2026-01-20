import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:shop_passport/core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../../../auth/data/models/user_model.dart';


class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  // GET PROFILE IMPLEMENTATION
  @override
  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      final user = await remoteDataSource.getProfile();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  // UPDATE PROFILE IMPLEMENTATION
  @override
  Future<Either<Failure, UserModel>> updateProfile({
    String? name,
    String? phone,
    File? profilePicture,
  }) async {
    try {
      final user = await remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        profilePicture: profilePicture,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}