import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/repositories/event_repository.dart';
import '../../data/models/event_model.dart';

// =========================================
// EVENT LOADING STATE - UI er different states
// =========================================
enum EventLoadingState {
  initial,  // Shuru te
  loading,  // Data load hocche
  success,  // Data load success
  error,    // Error hoyeche
  empty     // Data nai
}

// =========================================
// EVENT CONTROLLER - Event list & delete manage kore
// =========================================
class EventController extends GetxController {
  final EventRepository repository;

  EventController({required this.repository});

  // ====== OBSERVABLES ======
  final loadingState = EventLoadingState.initial.obs; // Current state
  final RxList<EventModel> events = <EventModel>[].obs; // Event list
  final RxString errorMessage = ''.obs; // Error message
  final isDeleting = false.obs; // Delete loading

  // ====== ON INIT ======
  @override
  void onInit() {
    super.onInit();
    loadEvents(); // Events load koro
  }

  // ====== LOAD EVENTS ======
  Future<void> loadEvents() async {
    loadingState.value = EventLoadingState.loading;

    final result = await repository.getMyEvents();

    result.fold(
      // ====== ERROR CASE (Left) ======
          (failure) {
        loadingState.value = EventLoadingState.error;
        errorMessage.value = failure.message;
      },
      // ====== SUCCESS CASE (Right) ======
          (eventList) {
        if (eventList.isEmpty) {
          loadingState.value = EventLoadingState.empty;
        } else {
          loadingState.value = EventLoadingState.success;
          events.value = eventList;
        }
      },
    );
  }

  // ====== REFRESH EVENTS ======
  Future<void> refreshEvents() async {
    await loadEvents();
  }

  // ====== DELETE EVENT (with optional UI) ======
  Future<void> deleteEvent(int eventId) async {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await performDelete(eventId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ====== PERFORM DELETE ======
  // UI free version for unit test
  Future<void> performDelete(int eventId, {bool showSnackbar = true}) async {
    isDeleting.value = true;

    final result = await repository.deleteEvent(eventId);

    result.fold(
      // ====== ERROR ======
          (failure) {
        isDeleting.value = false;

        if (showSnackbar) {
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      // ====== SUCCESS ======
          (_) {
        isDeleting.value = false;
        events.removeWhere((event) => event.id == eventId);

        if (events.isEmpty) {
          loadingState.value = EventLoadingState.empty;
        }

        if (showSnackbar) {
          Get.snackbar(
            'Success',
            'Event deleted successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }

  // ====== RETRY ======
  void retry() {
    loadEvents();
  }
}
