

class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://shoppassport.onrender.com';

  // Auth Endpoints


  // Login API
  static const String login = '/api/auth/login/';

  // Profile API - GET/PUT duitai
  static const String profile = '/api/auth/profile/';

  //  Event Endpoints

  // My Events list
  static const String myEvents = '/api/shopadmin/events/my-events/';
  // Delete Event - Dynamic ID
  static String deleteEvent(int eventId) => '/api/shopadmin/events/$eventId/delete/';

  // Helper Method
  // Full URL banano - baseUrl + endpoint
  static String getFullUrl(String endpoint) => baseUrl + endpoint;
}


