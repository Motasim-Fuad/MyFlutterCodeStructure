import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/event_model.dart';

abstract class EventRepository {
  // My events list get
  Future<Either<Failure, List<EventModel>>> getMyEvents();

  // Event delete by ID
  Future<Either<Failure, void>> deleteEvent(int eventId);
}