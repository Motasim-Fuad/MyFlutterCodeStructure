
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'config/routes/app_routes.dart';
import 'core/config/theme/app_theme.dart';
import 'core/config/localization/app_translations.dart';
import 'core/config/localization/localization_config.dart';
import 'core/di/injection.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/secure_storage_service.dart';
import 'core/services/theme_service.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    AppLogger.info(' Initializing Storage Services...');

    await LocalStorageService().init();
    AppLogger.info(' Local Storage initialized');

    await SecureStorageService().init();
    AppLogger.info(' Secure Storage initialized');

    AppLogger.info(' Setting up Dependency Injection...');
    await DependencyInjection.init();
    AppLogger.info(' Dependency Injection complete');

    Get.put(ThemeService());
    AppLogger.info(' Theme Service initialized');

    AppLogger.info(' Starting Application...');
    runApp(const MyApp());

  } catch (e, stackTrace) {
    AppLogger.error(' App Initialization Failed', e, stackTrace);
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                const Text('App Initialization Failed'),
                const SizedBox(height: 8),
                Text('Error: $e'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localStorage = LocalStorageService();
    final themeService = Get.find<ThemeService>();

    return GetMaterialApp(
      title: 'Shop Passport',
      debugShowCheckedModeBanner: false,


      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeService.themeMode,

      //LOCALIZATION
      localizationsDelegates: LocalizationConfig.delegates,
      supportedLocales: LocalizationConfig.supportedLocales,
      locale: LocalizationConfig.getInitialLocale(),
      fallbackLocale: LocalizationConfig.fallbackLocale,
      translations: AppTranslations(),

      // ROUTING
      initialRoute: _getInitialRoute(localStorage),
      getPages: AppRoutes.pages,

      //TRANSITIONS
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),

      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }

  String _getInitialRoute(LocalStorageService storage) {
    if (storage.isLoggedIn()) {
      AppLogger.info('User is logged in, navigating to main');
      return AppRoutes.main;
    } else {
      AppLogger.info(' User not logged in, navigating to login');
      return AppRoutes.login;
    }
  }
}