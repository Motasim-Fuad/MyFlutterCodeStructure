// test/features/auth/data/repositories/auth_repository_impl_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// CORRECT IMPORTS - adjust path based on your structure
import 'package:shop_passport/core/error/exceptions.dart';
import 'package:shop_passport/core/error/failures.dart';
import 'package:shop_passport/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shop_passport/features/auth/data/models/user_model.dart';
import 'package:shop_passport/features/auth/data/repositories/auth_repository_impl.dart';

// Generate mocks - this will create auth_repository_impl_test.mocks.dart
@GenerateMocks([AuthRemoteDataSource])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('login', () {
    const testEmail = 'test@test.com';
    const testPassword = 'password123';
    final testUser = UserModel(
      id: 1,
      email: testEmail,
      name: 'Test User',
      phone: '1234567890',
      role: 'event_admin',
    );

    test('should return UserModel when login is successful', () async {
      //arrange
      when(mockDataSource.login(testEmail, testPassword))
          .thenAnswer((_) async => testUser);
      //act
      final result = await repository.login(testEmail, testPassword);
      // assert
      expect(result, equals(Right(testUser)));
      verify(mockDataSource.login(testEmail, testPassword));
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return ServerFailure when login fails', () async {
      // arrange
      when(mockDataSource.login(testEmail, testPassword))
          .thenThrow(ServerException('Login failed'));

      //act
      final result = await repository.login(testEmail, testPassword);

      // assert

      // 1 Left checking
      expect(result.isLeft(), true);

      // 2 Failure ar type checking
      final failure = result.fold((l) => l, (_) => null);
      expect(failure, isA<ServerFailure>());

      // 3 Message checking (optional but good)
      expect((failure as ServerFailure).message, 'Login failed');
    });

  });

  group('logout', () {
    test('should return Right(null) when logout is successful', () async {

      // arrange
      when(mockDataSource.logout()).thenAnswer((_) async => Future.value());

      // act
      final result = await repository.logout();

      // assert
      expect(result, equals(const Right(null)));
    });
  });
}






// # Generate mocks first
// flutter pub run build_runner build
//flutter pub run build_runner build --delete-conflicting-outputs
//
// # Run all tests
// flutter test
//
// # Run specific test file
// flutter test test/features/auth/data/repositories/auth_repository_impl_test.dart
//
// # Run tests with coverage
// flutter test --coverage