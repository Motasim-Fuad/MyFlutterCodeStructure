// test/features/auth/presentation/controllers/auth_controller_test.dart
// KI: AuthController test
// TEST: login, logout, validation

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shop_passport/core/error/failures.dart';
import 'package:shop_passport/features/auth/data/models/user_model.dart';
import 'package:shop_passport/features/auth/domain/repositories/auth_repository.dart';
import 'package:shop_passport/features/auth/presentation/controllers/auth_controller.dart';

@GenerateMocks([AuthRepository])
import 'auth_controller_test.mocks.dart';

void main() {
  late AuthController controller;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    controller = AuthController(repository: mockRepository);
  });

  tearDown(() {
    controller.dispose();
  });

  group('login', () {
    final testUser = UserModel(
      id: 1,
      email: 'test@test.com',
      name: 'Test User',
      phone: '1234567890',
      role: 'event_admin',
    );

    test('should set loading true when login starts', () {
      // arrange
      controller.emailController.text = 'test@test.com';
      controller.passwordController.text = 'password123';

      when(mockRepository.login(any, any))
          .thenAnswer((_) async => Right(testUser));

      // act
      controller.login();

      // assert
      expect(controller.isLoading.value, true);
    });

    test('should update currentUser when login is successful', () async {
      // arrange
      controller.emailController.text = 'test@test.com';
      controller.passwordController.text = 'password123';

      when(mockRepository.login('test@test.com', 'password123'))
          .thenAnswer((_) async => Right(testUser));

      // act
      await controller.login();

      // assert
      expect(controller.currentUser.value, testUser);
      expect(controller.isLoading.value, false);
    });

    test('should set loading false when login fails', () async {
      // arrange
      controller.emailController.text = 'test@test.com';
      controller.passwordController.text = 'password123';

      when(mockRepository.login(any, any))
          .thenAnswer((_) async => Left(ServerFailure('Login failed')));

      // act
      await controller.login();

      // assert
      expect(controller.isLoading.value, false);
      expect(controller.currentUser.value, null);
    });

    test('should not call repository when email is empty', () async {
      // arrange
      controller.emailController.text = '';
      controller.passwordController.text = 'password123';

      // act
      await controller.login();

      // assert
      verifyNever(mockRepository.login(any, any));
    });

    test('should not call repository when email is invalid', () async {
      // arrange
      controller.emailController.text = 'invalid-email';
      controller.passwordController.text = 'password123';

      // act
      await controller.login();

      // assert
      verifyNever(mockRepository.login(any, any));
    });

    test('should not call repository when password is too short', () async {
      // arrange
      controller.emailController.text = 'test@test.com';
      controller.passwordController.text = '123';

      // act
      await controller.login();

      // assert
      verifyNever(mockRepository.login(any, any));
    });
  });

  group('togglePasswordVisibility', () {
    test('should toggle password visibility', () {
      // initial state
      expect(controller.isPasswordVisible.value, false);

      // act
      controller.togglePasswordVisibility();

      // assert
      expect(controller.isPasswordVisible.value, true);

      // act again
      controller.togglePasswordVisibility();

      // assert
      expect(controller.isPasswordVisible.value, false);
    });
  });
}