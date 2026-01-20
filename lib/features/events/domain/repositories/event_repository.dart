import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/event_model.dart';

// =========================================
// EVENT REPOSITORY INTERFACE
// =========================================
abstract class EventRepository {
  // My events list get koro
  Future<Either<Failure, List<EventModel>>> getMyEvents();

  // Event delete koro by ID
  Future<Either<Failure, void>> deleteEvent(int eventId);
}