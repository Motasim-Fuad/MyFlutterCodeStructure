import 'package:shop_passport/core/error/exceptions.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/event_model.dart';

// =========================================
// EVENT REMOTE DATA SOURCE - API calls
// =========================================
class EventRemoteDataSource {
  final ApiClient apiClient;

  EventRemoteDataSource({required this.apiClient});

  // ====== GET MY EVENTS ======
  Future<List<EventModel>> getMyEvents() async {
    // API call - GET request
    final response = await apiClient.get(ApiEndpoints.myEvents);

    // Response check
    if (response.statusCode == 200) {
      // Response data ekta List
      final List<dynamic> data = response.data;

      // List ke EventModel list e convert
      return data.map((json) => EventModel.fromJson(json)).toList();
    } else {
      throw ServerException(response.data['message'] ?? 'Failed to load events');
    }
  }

  // ====== DELETE EVENT ======
  Future<void> deleteEvent(int eventId) async {
    // API call - DELETE request
    final response = await apiClient.delete(
      ApiEndpoints.deleteEvent(eventId),
    );

    // Response check - 200 or 204 = success
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException(response.data['message'] ?? 'Failed to delete event');
    }
  }
}