// 📦 Part 4 - Usage Examples & Setup Guide
//
// 🎯 CUSTOM BUTTON USAGE EXAMPLES
// Example 1: Simple Login Button
// dartCustomButton(
// title: 'Login',
// onPress: () {
// // Login logic
// },
// height: 50,
// width: double.infinity,
// )
// Example 2: Button with Loading
// dart// Controller e
// final isLoading = false.obs;
//
// // UI te
// Obx(() => CustomButton(
// title: 'Submit',
// onPress: submitForm,
// loading: isLoading.value, // Loading state
// showLoader: true, // Spinner dekhabe
// showLoadingText: true, // Loading text dekhabe
// loadingText: 'Processing...',
// height: 50,
// ))
// Example 3: Button with Icon (Left)
// dartCustomButton(
// title: 'Logout',
// onPress: logout,
// icon: Icons.logout,
// iconPosition: IconPosition.left,
// buttonColor: Colors.red,
// )
// Example 4: Button with Icon (Right)
// dartCustomButton(
// title: 'Next',
// onPress: goNext,
// icon: Icons.arrow_forward,
// iconPosition: IconPosition.right,
// )
// Example 5: Gradient Button
// dartCustomButton(
// title: 'Premium',
// onPress: upgrade,
// gradientColors: [Colors.purple, Colors.blue],
// )
// Example 6: Custom Colors
// dartCustomButton(
// title: 'Custom',
// onPress: () {},
// buttonColor: Colors.green,
// textColor: Colors.white,
// )
//
// 🎮 CONTROLLER RESPONSE HANDLING EXAMPLES
// Example 1: Basic Response Check (Your Requirement)
// dartFuture<void> fetchData() async {
// isLoading.value = true;
//
// try {
// final response = await apiClient.get('/api/data/');
//
// // 🔴 APNAR WAY - 3 options check
// // Option 1: success == true
// // Option 2: message == "Success" or empty
// // Option 3: statusCode == 200
//
// if (response.data['success'] == true ||
// response.data['message'] == 'Success' ||
// response.statusCode == 200) {
// // SUCCESS
// isLoading.value = false;
// data.value = response.data['data'];
// Get.snackbar('Success', 'Data loaded!');
// } else {
// // FAILURE
// isLoading.value = false;
// Get.snackbar('Error', 'Failed to load data');
// }
// } catch (e) {
// isLoading.value = false;
// Get.snackbar('Error', e.toString());
// }
// }
// Example 2: With Clean Architecture (Either Pattern)
// dartFuture<void> login() async {
// isLoading.value = true;
//
// final result = await repository.login(email, password);
//
// result.fold(
// // Left = Error
// (failure) {
// isLoading.value = false;
// Get.snackbar('Error', failure.message);
// },
// // Right = Success
// (user) {
// isLoading.value = false;
// currentUser.value = user;
// Get.offAllNamed(AppRoutes.home);
// },
// );
// }
// Example 3: Multiple Checks (Apnar Requirement)
// dartFuture<void> submitForm() async {
// isLoading.value = true;
//
// final result = await repository.submit(data);
//
// result.fold(
// // Error case
// (failure) {
// isLoading.value = false;
// _showError(failure.message);
// },
//
// // Success case - Multiple checks
// (response) {
// // 🔴 Apnar 3 ta option check
// bool isSuccess = false;
//
// // Check 1: success field
// if (response.success == true) {
// isSuccess = true;
// }
//
// // Check 2: message field
// if (response.message == 'Success' || response.message.isEmpty) {
// isSuccess = true;
// }
//
// // Check 3: status code
// if (response.statusCode == 200 || response.statusCode == 201) {
// isSuccess = true;
// }
//
// isLoading.value = false;
//
// if (isSuccess) {
// Get.snackbar('Success', 'Form submitted!');
// } else {
// Get.snackbar('Error', 'Submission failed');
// }
// },
// );
// }
//
// ➕ HOW TO ADD NEW FEATURE
// Example: Adding "Products" Feature
// Step 1: Create Folder Structure
// lib/features/products/
// ├── data/
// │   ├── models/
// │   │   └── product_model.dart
// │   ├── datasources/
// │   │   └── product_remote_datasource.dart
// │   └── repositories/
// │       └── product_repository_impl.dart
// ├── domain/
// │   └── repositories/
// │       └── product_repository.dart
// └── presentation/
// ├── controllers/
// │   └── product_controller.dart
// └── pages/
// └── products_page.dart
// Step 2: Add API Endpoint
// dart// core/constants/api_endpoints.dart
// static const String products = '/api/products/';
// static String productDetail(int id) => '/api/products/$id/';
// Step 3: Create Model
// dart// products/data/models/product_model.dart
// class ProductModel {
// final int id;
// final String name;
// final double price;
//
// ProductModel({
// required this.id,
// required this.name,
// required this.price,
// });
//
// factory ProductModel.fromJson(Map<String, dynamic> json) {
// return ProductModel(
// id: json['id'] ?? 0,
// name: json['name'] ?? '',
// price: (json['price'] ?? 0).toDouble(),
// );
// }
// }
// Step 4: Create Repository Interface
// dart// products/domain/repositories/product_repository.dart
// import 'package:dartz/dartz.dart';
//
// abstract class ProductRepository {
// Future<Either<Failure, List<ProductModel>>> getProducts();
// }
// Step 5: Create DataSource
// dart// products/data/datasources/product_remote_datasource.dart
// class ProductRemoteDataSource {
// final ApiClient apiClient;
//
// ProductRemoteDataSource({required this.apiClient});
//
// Future<List<ProductModel>> getProducts() async {
// final response = await apiClient.get(ApiEndpoints.products);
//
// if (response.statusCode == 200) {
// final List<dynamic> data = response.data;
// return data.map((json) => ProductModel.fromJson(json)).toList();
// } else {
// throw ServerException('Failed to load products');
// }
// }
// }
// Step 6: Create Repository Implementation
// dart// products/data/repositories/product_repository_impl.dart
// class ProductRepositoryImpl implements ProductRepository {
// final ProductRemoteDataSource remoteDataSource;
//
// ProductRepositoryImpl({required this.remoteDataSource});
//
// @override
// Future<Either<Failure, List<ProductModel>>> getProducts() async {
// try {
// final products = await remoteDataSource.getProducts();
// return Right(products);
// } on ServerException catch (e) {
// return Left(ServerFailure(e.message));
// }
// }
// }
// Step 7: Create Controller
// dart// products/presentation/controllers/product_controller.dart
// class ProductController extends GetxController {
// final ProductRepository repository;
//
// ProductController({required this.repository});
//
// final isLoading = false.obs;
// final RxList<ProductModel> products = <ProductModel>[].obs;
//
// @override
// void onInit() {
// super.onInit();
// loadProducts();
// }
//
// Future<void> loadProducts() async {
// isLoading.value = true;
//
// final result = await repository.getProducts();
//
// result.fold(
// (failure) {
// isLoading.value = false;
// Get.snackbar('Error', failure.message);
// },
// (productList) {
// isLoading.value = false;
// products.value = productList;
// },
// );
// }
// }
// Step 8: Register in DI
// dart// core/di/injection.dart
// // Add imports at top
// import '../../features/products/data/datasources/product_remote_datasource.dart';
// import '../../features/products/data/repositories/product_repository_impl.dart';
// import '../../features/products/domain/repositories/product_repository.dart';
// import '../../features/products/presentation/controllers/product_controller.dart';
//
// // Add in init() method
// // Products Feature
// Get.lazyPut(() => ProductRemoteDataSource(apiClient: Get.find()));
// Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(remoteDataSource: Get.find()));
// Get.lazyPut(() => ProductController(repository: Get.find()));
// Step 9: Create UI Page
// dart// products/presentation/pages/products_page.dart
// class ProductsPage extends GetView<ProductController> {
// const ProductsPage({Key? key}) : super(key: key);
//
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(title: const Text('Products')),
// body: Obx(() {
// if (controller.isLoading.value) {
// return const LoadingWidget();
// }
//
// return ListView.builder(
// itemCount: controller.products.length,
// itemBuilder: (context, index) {
// final product = controller.products[index];
// return ListTile(
// title: Text(product.name),
// subtitle: Text('\$${product.price}'),
// );
// },
// );
// }),
// );
// }
// }
//
// 🚀 QUICK SETUP CHECKLIST
// Initial Setup (First Time)
//
// Create new Flutter project: flutter create shop_passport
// Copy pubspec.yaml content
// Run flutter pub get
// Create folder structure as shown
// Copy all files to respective locations
// Change base URL in api_endpoints.dart
// Run app: flutter run
//
// For New Project (Reuse)
//
// Change baseUrl in api_endpoints.dart
// Change app name in pubspec.yaml
// Update colors in api_endpoints.dart (AppColors)
// Update API endpoints for your API
// Test login with your credentials
//
//
// 🔧 COMMON CUSTOMIZATIONS
// 1. Change Base URL
// dart// core/constants/api_endpoints.dart
// static const String baseUrl = 'YOUR_NEW_BASE_URL';
// 2. Change App Colors
// dart// core/constants/api_endpoints.dart
// class AppColors {
// static const primaryColor = Color(0xFFYOUR_COLOR);
// static const secondaryColor = Color(0xFFYOUR_COLOR);
// }
// 3. Add Custom Header
// dart// core/network/api_client.dart
// BaseOptions(
// headers: {
// 'Content-Type': 'application/json',
// 'X-API-Key': 'YOUR_API_KEY',
// 'X-Custom-Header': 'YOUR_VALUE',
// },
// )
// 4. Change Token Key Name
// dart// core/network/api_client.dart - AuthInterceptor
// options.headers['Authorization'] = 'YOUR_TOKEN_PREFIX $token';
// // Example: 'Token $token' or just token
// 5. Handle Different Response Format
// dart// In your controller
// if (response.data['status'] == 'ok') { // Your API format
// // Success
// }
//
// 🐛 COMMON ISSUES & SOLUTIONS
// Issue 1: "Get.find() returns null"
// Solution: Make sure DependencyInjection.init() is called in main()
// dartvoid main() async {
// WidgetsFlutterBinding.ensureInitialized();
// await GetStorage.init();
// await DependencyInjection.init(); // ✅ This is required
// runApp(const MyApp());
// }
// Issue 2: "Controller not found"
// Solution: Controller ta DI te register ache kina check korun
// dart// injection.dart te check korun
// Get.lazyPut(() => YourController(repository: Get.find()));
// Issue 3: "Image not loading"
// Solution: Internet permission add korun
// xml<!-- android/app/src/main/AndroidManifest.xml -->
// <uses-permission android:name="android.permission.INTERNET"/>
// Issue 4: "Can't pick image"
// Solution: Permission add korun
// xml<!-- android/app/src/main/AndroidManifest.xml -->
// <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
// <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
// Issue 5: "API returns 401 Unauthorized"
// Solution: Token saved ache kina check korun
// dart// Check if token exists
// print(storageService.getAccessToken());
//
// 📝 IMPORTANT NOTES
// Response Handling (YOUR REQUIREMENT)
// dart// 🔴 Apni 3 way te success check korte parben:
//
// // Way 1: success field check
// if (response.data['success'] == true) { ... }
//
// // Way 2: message field check
// if (response.data['message'] == 'Success') { ... }
//
// // Way 3: status code check
// if (response.statusCode == 200) { ... }
//
// // Or combine them:
// bool isSuccess = response.data['success'] == true ||
// response.data['message'] == 'Success' ||
// response.statusCode == 200;
// File Structure Purpose
// lib/
// ├── core/           → Shared utilities (API, Storage, Constants)
// ├── features/       → App features (Auth, Events, Profile)
// │   └── feature_name/
// │       ├── data/           → API calls, Models
// │       ├── domain/         → Business logic, Interfaces
// │       └── presentation/   → UI, Controllers
// ├── shared/         → Reusable widgets
// ├── config/         → App configuration (Routes)
// └── main.dart       → App entry point
// Key Concepts
//
// Clean Architecture: 3 layers (Data, Domain, Presentation)
// Dependency Injection: GetX DI (Get.lazyPut)
// State Management: GetX (.obs, Obx)
// Either Pattern: Left (Error) / Right (Success)
// Repository Pattern: Interface + Implementation
//
//
// 🎯 TESTING THE APP
// Step 1: Run the app
// bashflutter run
// Step 2: Test Login
//
// Enter email: eventadmin@test.com
// Enter password: your_password
// Click Login
//
// Step 3: Check Home
//
// Event list dekha jabe
// Pull to refresh test korun
// Delete button test korun
//
// Step 4: Check Profile
//
// Profile page e jan
// Edit button click korun
// Name/Phone change korun
// Image select korun
// Update button click korun
//
// Step 5: Test Logout
//
// Profile page e Logout button
// Confirmation dialog asbe
// Logout korle Login page e jabe
//
//
// 📚 RESOURCES
// Documentation
//
// GetX: https://pub.dev/packages/get
// Dio: https://pub.dev/packages/dio
// Dartz: https://pub.dev/packages/dartz
// GetStorage: https://pub.dev/packages/get_storage
//
// Video Tutorials
//
// Clean Architecture: Search "Flutter Clean Architecture"
// GetX State Management: Search "Flutter GetX Tutorial"
// Repository Pattern: Search "Flutter Repository Pattern"
//
//
// ✅ FINAL CHECKLIST
// Ei sob kora hoise kina check korun:
//
// All files copied to correct locations
// pubspec.yaml updated
// flutter pub get run korechen
// Base URL changed (if needed)
// API endpoints correct
// Internet permission added (Android)
// Dependency injection working
// Login working
// Events loading
// Profile loading
// Image picker working
// Logout working
//
//
// 🎉 CONGRATULATIONS!
// Apnar production-ready Flutter app complete!
// What You Got:
// ✅ Clean Architecture
// ✅ State Management
// ✅ Error Handling
// ✅ Loading States
// ✅ Token Management
// ✅ Image Upload
// ✅ Reusable Structure
// ✅ Copy-Paste Ready
// Next Steps:
//
// Customize colors/theme
// Add more features using same pattern
// Add splash screen
// Add animations
// Deploy to Play Store/App Store
//
//
// 🤝 NEED HELP?
// Kono problem hole:
//
// Error message carefully porun
// File structure check korun
// DI registration check korun
// API response log check korun
//
// Kono confusion thakle bolen! 🚀
//
// 🎯 QUICK REFERENCE
// Add New API Endpoint
// dart// api_endpoints.dart
// static const String yourEndpoint = '/api/your/endpoint/';
// Add New Controller
// dart// your_controller.dart
// class YourController extends GetxController {
// final YourRepository repository;
// YourController({required this.repository});
//
// final isLoading = false.obs;
//
// @override
// void onInit() {
// super.onInit();
// loadData();
// }
// }
// Register in DI
// dart// injection.dart
// Get.lazyPut(() => YourController(repository: Get.find()));
// Use in UI
// dartclass YourPage extends GetView<YourController> {
// @override
// Widget build(BuildContext context) {
// return Obx(() => Text(controller.data.value));
// }
// }
//
// 🚀 APNAR APP READY!
// Ei complete code diye apni kono project e kaj korte parben!
// Copy-paste korun ar chalan! 🎉





// Future<void> fetchData() async {
//   isLoading.value = true;
//
//   try {
//     final response = await apiClient.get('/api/data/');
//
//     // 🔴 APNAR WAY - 3 options check
//     // Option 1: success == true
//     // Option 2: message == "Success" or empty
//     // Option 3: statusCode == 200
//
//     if (response.data['success'] == true ||
//         response.data['message'] == 'Success' ||
//         response.statusCode == 200) {
//       // SUCCESS
//       isLoading.value = false;
//       data.value = response.data['data'];
//       Get.snackbar('Success', 'Data loaded!');
//     } else {
//       // FAILURE
//       isLoading.value = false;
//       Get.snackbar('Error', 'Failed to load data');
//     }
//   } catch (e) {
//     isLoading.value = false;
//     Get.snackbar('Error', e.toString());
//   }
// }




// Future<void> login() async {
//   isLoading.value = true;
//
//   final result = await repository.login(email, password);
//
//   result.fold(
//     // Left = Error
//         (failure) {
//       isLoading.value = false;
//       Get.snackbar('Error', failure.message);
//     },
//     // Right = Success
//         (user) {
//       isLoading.value = false;
//       currentUser.value = user;
//       Get.offAllNamed(AppRoutes.home);
//     },
//   );
// }



// Future<void> submitForm() async {
//   isLoading.value = true;
//
//   final result = await repository.submit(data);
//
//   result.fold(
//     // Error case
//         (failure) {
//       isLoading.value = false;
//       _showError(failure.message);
//     },
//
//     // Success case - Multiple checks
//         (response) {
//       // 🔴 Apnar 3 ta option check
//       bool isSuccess = false;
//
//       // Check 1: success field
//       if (response.success == true) {
//         isSuccess = true;
//       }
//
//       // Check 2: message field
//       if (response.message == 'Success' || response.message.isEmpty) {
//         isSuccess = true;
//       }
//
//       // Check 3: status code
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         isSuccess = true;
//       }
//
//       isLoading.value = false;
//
//       if (isSuccess) {
//         Get.snackbar('Success', 'Form submitted!');
//       } else {
//         Get.snackbar('Error', 'Submission failed');
//       }
//     },
//   );
// }



// lib/features/products/
// ├── data/
// │   ├── models/
// │   │   └── product_model.dart
// │   ├── datasources/
// │   │   └── product_remote_datasource.dart
// │   └── repositories/
// │       └── product_repository_impl.dart
// ├── domain/
// │   └── repositories/
// │       └── product_repository.dart
// └── presentation/
// ├── controllers/
// │   └── product_controller.dart
// └── pages/
// └── products_page.dart


// core/constants/api_endpoints.dart
// static const String products = '/api/products/';
// static String productDetail(int id) => '/api/products/$id/';



// products/data/models/product_model.dart
// class ProductModel {
//   final int id;
//   final String name;
//   final double price;
//
//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.price,
//   });
//
//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       price: (json['price'] ?? 0).toDouble(),
//     );
//   }
// }


// products/domain/repositories/product_repository.dart
// import 'package:dartz/dartz.dart';
//
// abstract class ProductRepository {
//   Future<Either<Failure, List<ProductModel>>> getProducts();
// }


// products/data/datasources/product_remote_datasource.dart
// class ProductRemoteDataSource {
//   final ApiClient apiClient;
//
//   ProductRemoteDataSource({required this.apiClient});
//
//   Future<List<ProductModel>> getProducts() async {
//     final response = await apiClient.get(ApiEndpoints.products);
//
//     if (response.statusCode == 200) {
//       final List<dynamic> data = response.data;
//       return data.map((json) => ProductModel.fromJson(json)).toList();
//     } else {
//       throw ServerException('Failed to load products');
//     }
//   }
// }




// products/data/repositories/product_repository_impl.dart
// class ProductRepositoryImpl implements ProductRepository {
//   final ProductRemoteDataSource remoteDataSource;
//
//   ProductRepositoryImpl({required this.remoteDataSource});
//
//   @override
//   Future<Either<Failure, List<ProductModel>>> getProducts() async {
//     try {
//       final products = await remoteDataSource.getProducts();
//       return Right(products);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     }
//   }
// }



// products/presentation/controllers/product_controller.dart
// class ProductController extends GetxController {
//   final ProductRepository repository;
//
//   ProductController({required this.repository});
//
//   final isLoading = false.obs;
//   final RxList<ProductModel> products = <ProductModel>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadProducts();
//   }
//
//   Future<void> loadProducts() async {
//     isLoading.value = true;
//
//     final result = await repository.getProducts();
//
//     result.fold(
//           (failure) {
//         isLoading.value = false;
//         Get.snackbar('Error', failure.message);
//       },
//           (productList) {
//         isLoading.value = false;
//         products.value = productList;
//       },
//     );
//   }
// }



// core/di/injection.dart
// Add imports at top
// import '../../features/products/data/datasources/product_remote_datasource.dart';
// import '../../features/products/data/repositories/product_repository_impl.dart';
// import '../../features/products/domain/repositories/product_repository.dart';
// import '../../features/products/presentation/controllers/product_controller.dart';
//
// // Add in init() method
// // Products Feature
// Get.lazyPut(() => ProductRemoteDataSource(apiClient: Get.find()));
// Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(remoteDataSource: Get.find()));
// Get.lazyPut(() => ProductController(repository: Get.find()));


// products/presentation/pages/products_page.dart
// class ProductsPage extends GetView<ProductController> {
//   const ProductsPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Products')),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const LoadingWidget();
//         }
//
//         return ListView.builder(
//           itemCount: controller.products.length,
//           itemBuilder: (context, index) {
//             final product = controller.products[index];
//             return ListTile(
//               title: Text(product.name),
//               subtitle: Text('\$${product.price}'),
//             );
//           },
//         );
//       }),
//     );
//   }
// }



// 🔴 Apni 3 way te success check korte parben:

// Way 1: success field check
// if (response.data['success'] == true) { ... }
//
// // Way 2: message field check
// if (response.data['message'] == 'Success') { ... }
//
// // Way 3: status code check
// if (response.statusCode == 200) { ... }
//
// // Or combine them:
// bool isSuccess = response.data['success'] == true ||
// response.data['message'] == 'Success' ||
// response.statusCode == 200;