// test/features/events/data/repositories/event_repository_impl_test.dart

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

  // =========================
  // getMyEvents Tests
  // =========================
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

    test('ডাটাসোর্স থেকে ডাটা সঠিকভাবে আসলে List<EventModel> return করবে', () async {
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

    test('ডাটাসোর্স ServerException throw করলে ServerFailure return করবে', () async {
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

  // =========================
  // deleteEvent Tests
  // =========================
  group('deleteEvent', () {
    const tEventId = 1;

    test('ডিলিট সফল হলে Right(null) return করবে', () async {
      // Arrange
      when(mockDataSource.deleteEvent(tEventId)).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.deleteEvent(tEventId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
            (_) => fail('Expected Right, got Left'),
            (_) {
          // Right হল void, তাই কিছু করা লাগবে না
          // শুধু এটি call হল কিনা verify করতে পারি


              // Either<Failure, void> এর Right মান void।
              //
              // Dart এ void value variable এ store করা যাবে না।
              //
              // তাই fold এর Right callback এ _ ব্যবহার করো এবং value check করার চেষ্টা করবেন না।
        },
      );

      verify(mockDataSource.deleteEvent(tEventId));
      verifyNoMoreInteractions(mockDataSource);
    });


    test('ডিলিট করতে গিয়ে ServerException throw হলে Left(ServerFailure) return করবে', () async {
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
