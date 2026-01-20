import 'package:dartz/dartz.dart';


abstract class Failure {
  final String message;
  Failure(this.message);
}

//  SERVER FAILURE
// Server error hole ei failure use hobe
class ServerFailure extends Failure {
  ServerFailure([String message = 'Server error occurred']) : super(message);
}

//  NETWORK FAILURE
// Internet na thakle ei failure
class NetworkFailure extends Failure {
  NetworkFailure([String message = 'No internet connection']) : super(message);
}

//  CACHE FAILURE
// Local storage error
class CacheFailure extends Failure {
  CacheFailure([String message = 'Cache error occurred']) : super(message);
}

//
// TYPE ALIASES - Short names
// Either<Failure, T> likhte hobe na, ResultFuture<T> likhlei hobe
typedef ResultFuture<T> = Future<Either<Failure, T>>;

// Either<Failure, void> er short form
typedef ResultVoid = Future<Either<Failure, void>>;