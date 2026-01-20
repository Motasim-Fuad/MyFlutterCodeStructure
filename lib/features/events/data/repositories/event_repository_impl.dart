import 'package:dartz/dartz.dart';
import 'package:shop_passport/core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_datasource.dart';
import '../models/event_model.dart';


class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  // GET MY EVENTS IMPLEMENTATION
  @override
  Future<Either<Failure, List<EventModel>>> getMyEvents() async {
    try {
      // DataSource call
      final events = await remoteDataSource.getMyEvents();

      // Success - Right return
      return Right(events);
    } on ServerException catch (e) {
      // Server error - Left return
      return Left(ServerFailure(e.message));
    } catch (e) {
      // Unexpected error
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  // DELETE EVENT IMPLEMENTATION
  @override
  Future<Either<Failure, void>> deleteEvent(int eventId) async {
    try {
      // DataSource call
      await remoteDataSource.deleteEvent(eventId);

      // Success
      return const Right(null);
    } on ServerException catch (e) {
      // Error
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}