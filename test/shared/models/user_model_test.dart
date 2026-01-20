import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shop_passport/features/auth/data/models/user_model.dart';

import 'user_model_test.mocks.dart';

@GenerateMocks([UserModel])
void main() {
    late UserModel userModel;
    late MockUserModel mockUserModel;
    setUp(() {
        mockUserModel = MockUserModel();
        userModel = mockUserModel;
    });

    test('user model json convert data', () async {
      // arrange
        when(mockUserModel.toJson()).thenReturn({});
        //act
      final result = mockUserModel.toJson();
      //assert
      expect(result, {});

    });
}
