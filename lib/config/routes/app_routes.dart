// =========================================
// APP_ROUTES.DART
// =========================================
import 'package:get/get.dart';
import 'package:shop_passport/config/buindings/theme/theme_buinding.dart';
import 'package:shop_passport/features/settings/presentation/pages/settings_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import 'main_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String main = '/main';
  static const String settings = '/settings';

  // All routes
  static List<GetPage> pages = [
    // Login route
    GetPage(
      name: login,
      page: () => const LoginPage(),
    ),
    // Main route (Home + Profile with Bottom Nav)
    GetPage(
      name: main,
      page: () => const MainPage(),
    ),

    GetPage(
      name: settings,
      page: () =>  SettingsPage(),
      binding: ThemeBuinding(),
    ),
  ];
}

