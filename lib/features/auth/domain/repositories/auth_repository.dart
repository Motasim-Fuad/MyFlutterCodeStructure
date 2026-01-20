import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/user_model.dart';

// Eita ekta contract - ki ki method thakbe ta define kore
// Implementation data layer e hobe
abstract class AuthRepository {
  //  LOGIN METHOD
  // Returns: Either<Failure, UserModel>
  // Left = Error, Right = Success with UserModel
  Future<Either<Failure, UserModel>> login(String email, String password);

  // LOGOUT METHOD
  // Returns: Either<Failure, void>
  // Left = Error, Right = Success
  Future<Either<Failure, void>> logout();
}