import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shop_passport/core/error/failures.dart';
import 'package:shop_passport/features/events/data/models/event_model.dart';
import 'package:shop_passport/features/events/domain/repositories/event_repository.dart';
import 'package:shop_passport/features/events/presentation/controllers/event_controller.dart';

import 'event_controller_test.mocks.dart';

@GenerateMocks([EventRepository])
void main() {
  late MockEventRepository mockEventRepository;
  late EventController controller;

  setUp(() {
    mockEventRepository = MockEventRepository();
    controller = EventController(repository: mockEventRepository);
  });

  group('loadEvents', () {
    final tEvents = [
      EventModel(
        id: 1,
        name: 'Event 1',
        aboutTheEvent: 'About',
        location: 'Dhaka',
        latitude: '23',
        longitude: '90',
        fromDate: '2026-01-01',
        toDate: '2026-01-02',
        images: [],
        adminName: 'Admin',
        adminEmail: 'admin@test.com',
        adminPhone: '0123',
        totalShops: 5,
        status: 'approved',
        eventDateStatus: 'ongoing',
        createdAt: '2026-01-01',
      ),
    ];

    test('success → sets success state & events', () async {
      // arrange
      when(mockEventRepository.getMyEvents())
          .thenAnswer((_) async => Right(tEvents));

      // act
      await controller.loadEvents();

      // assert
      expect(controller.loadingState.value, EventLoadingState.success);
      expect(controller.events.length, 1);
      expect(controller.events.first.name, 'Event 1');

      verify(mockEventRepository.getMyEvents());
    });

    test('empty list → sets empty state', () async {
      when(mockEventRepository.getMyEvents())
          .thenAnswer((_) async => const Right([]));

      await controller.loadEvents();

      expect(controller.loadingState.value, EventLoadingState.empty);
      expect(controller.events.isEmpty, true);
    });

    test('failure → sets error state', () async {
      when(mockEventRepository.getMyEvents())
          .thenAnswer((_) async => Left(ServerFailure('Server error')));

      await controller.loadEvents();

      expect(controller.loadingState.value, EventLoadingState.error);
      expect(controller.errorMessage.value, 'Server error');
    });
  });
}
