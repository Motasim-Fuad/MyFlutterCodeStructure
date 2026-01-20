import 'package:dartz/dartz.dart';
import 'package:shop_passport/core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

// Interface implement kore actual code likhe
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  // LOGIN IMPLEMENTATION
  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    try {
      // DataSource call koro
      final user = await remoteDataSource.login(email, password);

      // Success - Right diye return
      return Right(user);
    } on ServerException catch (e) {
      // Server error - Left diye return
      return Left(ServerFailure(e.message));
    } catch (e) {
      // Unexpected error
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  //LOGOUT IMPLEMENTATION
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // DataSource call
      await remoteDataSource.logout();

      // Success
      return const Right(null);
    } catch (e) {
      // Error
      return Left(CacheFailure('Failed to logout'));
    }
  }
}