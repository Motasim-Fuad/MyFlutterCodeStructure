import 'package:flutter/material.dart';

// =========================================
// API ENDPOINTS - Sob API URLs ekhane
// =========================================
class ApiEndpoints {
  // Base URL - Apnar API er base URL
  // 🔴 EITA CHANGE KORBEN notun project e
  static const String baseUrl = 'https://shoppassport.onrender.com';

  // ====== Auth Endpoints ======
  // Login API
  static const String login = '/api/auth/login/';

  // Profile API - GET/PUT duitai
  static const String profile = '/api/auth/profile/';

  // ====== Event Endpoints ======
  // My Events list
  static const String myEvents = '/api/shopadmin/events/my-events/';

  // Delete Event - Dynamic ID
  // Usage: ApiEndpoints.deleteEvent(14) => '/api/shopadmin/events/14/delete/'
  static String deleteEvent(int eventId) => '/api/shopadmin/events/$eventId/delete/';

  // ====== Helper Method ======
  // Full URL banano - baseUrl + endpoint
  static String getFullUrl(String endpoint) => baseUrl + endpoint;
}


