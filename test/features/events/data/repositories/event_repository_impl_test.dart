
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:shop_passport/features/events/data/repositories/event_repository_impl.dart';
import 'package:shop_passport/features/events/data/datasources/event_remote_datasource.dart';
import 'package:shop_passport/features/events/data/models/event_model.dart';
import 'package:shop_passport/core/error/exceptions.dart';
import 'package:shop_passport/core/error/failures.dart';

import 'event_repository_impl_test.mocks.dart';

@GenerateMocks([EventRemoteDataSource])
void main() {
  late EventRepositoryImpl repository;
  late MockEventRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockEventRemoteDataSource();
    repository = EventRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('getMyEvents', () {
    final tEventList = [
      EventModel(
        id: 1,
        name: 'Event 1',
        aboutTheEvent: 'About Event 1',
        location: 'Dhaka',
        latitude: '23.8103',
        longitude: '90.4125',
        fromDate: '2026-01-10',
        toDate: '2026-01-12',
        images: [
          EventImage(id: 1, image: 'url1', uploadedAt: '2026-01-01'),
        ],
        adminName: 'Admin 1',
        adminEmail: 'admin1@test.com',
        adminPhone: '0123456789',
        totalShops: 10,
        status: 'approved',
        eventDateStatus: 'ongoing',
        createdAt: '2026-01-01',
      ),
      EventModel(
        id: 2,
        name: 'Event 2',
        aboutTheEvent: 'About Event 2',
        location: 'Chittagong',
        latitude: '22.3569',
        longitude: '91.7832',
        fromDate: '2026-02-01',
        toDate: '2026-02-03',
        images: [],
        adminName: 'Admin 2',
        adminEmail: 'admin2@test.com',
        adminPhone: '0987654321',
        totalShops: 5,
        status: 'pending',
        eventDateStatus: 'ended',
        createdAt: '2026-01-05',
      ),
    ];

    test('If datasource give data then List<EventModel> return properly', () async {
      // Arrange
      when(mockDataSource.getMyEvents()).thenAnswer((_) async => tEventList);

      // Act
      final result = await repository.getMyEvents();

      // Assert
      expect(result.isRight(), true);
      result.fold(
            (_) => fail('Expected Right, got Left'),
            (events) {
          expect(events, tEventList);
          expect(events.length, 2);
        },
      );

      verify(mockDataSource.getMyEvents());
      verifyNoMoreInteractions(mockDataSource);
    });

    test('The datasource will throw a ServerException and return ServerFailure.', () async {
      // Arrange
      when(mockDataSource.getMyEvents()).thenThrow(ServerException('Server Error'));

      // Act
      final result = await repository.getMyEvents();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
            (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server Error');
        },
            (_) => fail('Expected Left, got Right'),
      );

      verify(mockDataSource.getMyEvents());
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('deleteEvent', () {
    const tEventId = 1;

    test('If the delete is successful, it will return Right(null).', () async {
      // Arrange
      when(mockDataSource.deleteEvent(tEventId)).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.deleteEvent(tEventId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
            (_) => fail('Expected Right, got Left'),
            (_) {
          // Right is void, so nothing needs to be done.
          // I can only verify if it was called.


              // Either<Failure, void> has a Right value of void.
              //
              // In Dart, void value cannot be stored in a variable.
              //
              //So use _ in fold's Right callback and don't try to check the value.
        },
      );

      verify(mockDataSource.deleteEvent(tEventId));
      verifyNoMoreInteractions(mockDataSource);
    });


    test('If a ServerException is thrown while deleting, it will return Left(ServerFailure).', () async {
      // Arrange
      when(mockDataSource.deleteEvent(tEventId))
          .thenThrow(ServerException('Cannot delete event'));

      // Act
      final result = await repository.deleteEvent(tEventId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
            (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Cannot delete event');
        },
            (_) => fail('Expected Left, got Right'),
      );

      verify(mockDataSource.deleteEvent(tEventId));
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}
