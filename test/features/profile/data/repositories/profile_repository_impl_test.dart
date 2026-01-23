import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shop_passport/features/auth/data/models/user_model.dart';
import 'package:shop_passport/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:shop_passport/features/profile/data/repositories/profile_repository_impl.dart';

import 'profile_repository_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSource])
void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('getProfile', () {
    final testUser = UserModel(
      id: 1,
      email: "test@test.com",
      name: 'Test User',
      phone: '1234567890',
      role: 'event_admin',
    );

    test('should return UserModel when getProfile is successful', () async {
      //arrange
      when(mockDataSource.getProfile()).thenAnswer((_) async => testUser);
      //act
      final result = await repository.getProfile();
      //assert
      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right, got Left'),
          (result) => expect(result, testUser));

      verify(mockDataSource.getProfile());
      verifyNoMoreInteractions(mockDataSource);
    });

    test("should return UserModel when updateProfile is successful", () async {
      //arrange
      when(mockDataSource.updateProfile(name: "Test User", phone: "1234567890"))
          .thenAnswer((_) async => testUser);
      //act
      final result = await repository.updateProfile(
          name: "Test User", phone: "1234567890");
      //assert
      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right, got Left'),
          (result) => expect(result, testUser));
      verify(
          mockDataSource.updateProfile(name: "Test User", phone: "1234567890"));
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}
