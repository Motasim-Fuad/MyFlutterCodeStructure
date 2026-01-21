import 'package:get/get.dart';
import '../services/local_storage_service.dart';
import '../services/secure_storage_service.dart';
import '../network/api_client.dart';

// Auth imports
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

// Events imports
import '../../features/events/data/datasources/event_remote_datasource.dart';
import '../../features/events/data/repositories/event_repository_impl.dart';
import '../../features/events/domain/repositories/event_repository.dart';
import '../../features/events/presentation/controllers/event_controller.dart';

// Profile imports
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';

class DependencyInjection {
  static Future<void> init() async {
    //  CORE SERVICES
    // WHY: Register core services first
    // These are singletons with fenix flag (always available)

    // CORE
    Get.put(ApiClient(), permanent: true);
    Get.put(LocalStorageService(), permanent: true);
    Get.put(SecureStorageService(), permanent: true);

    // AUTH
    Get.lazyPut(
          () => AuthRemoteDataSource(apiClient: Get.find()),
      fenix: true,
    );

    Get.put<AuthRepository>(
      AuthRepositoryImpl(remoteDataSource: Get.find()),
      permanent: true,
    );

    Get.lazyPut(
          () => AuthController(repository: Get.find()),
      fenix: true,
    );

    // EVENTS
    Get.lazyPut(
          () => EventRemoteDataSource(apiClient: Get.find()),
      fenix: true,
    );

    Get.put<EventRepository>(
      EventRepositoryImpl(remoteDataSource: Get.find()),
      permanent: true,
    );

    Get.put(EventController(repository: Get.find()));

    // PROFILE
    Get.lazyPut(
          () => ProfileRemoteDataSource(apiClient: Get.find()),
      fenix: true,
    );

    Get.put<ProfileRepository>(
      ProfileRepositoryImpl(remoteDataSource: Get.find()),
      permanent: true,
    );

    Get.put(ProfileController(repository: Get.find()));

  }
}
