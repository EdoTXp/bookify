import 'package:bookify/src/shared/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/shared/models/user_model.dart';
import 'package:bookify/src/shared/repositories/auth_repository/auth_repository_impl.dart';
import 'package:bookify/src/shared/storage/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class StorageMock extends Mock implements Storage {}

void main() {
  const userModel = UserModel(
    name: 'userName',
    photo: 'userPhoto',
    signInType: SignInType.google,
  );

  final storage = StorageMock();
  final authRepository = AuthRepositoryImpl(storage: storage);

  group('Test normal crud without error', () {
    test('Test get UserModel', () async {
      when(
        () => storage.getStorage(
          key: 'user',
        ),
      ).thenAnswer(
        (_) async => userModel.toJson(),
      );
      final user = await authRepository.getUserModel();

      expect(user, equals(userModel));
    });

    test('Test set UserModel', () async {
      when(
        () => storage.insertStorage(
          key: 'user',
          value: any(named: 'value'),
        ),
      ).thenAnswer(
        (_) async => 1,
      );
      final userModelInserted = await authRepository.setUserModel(
        userModel: userModel,
      );

      expect(userModelInserted, equals(1));
    });
  });

  group('Test normal crud with error', () {
    test('Test get UserModel with TypeError', () async {
      when(
        () => storage.getStorage(
          key: 'user',
        ),
      ).thenAnswer(
        (_) async => 1,
      );

      expect(
        () async => await authRepository.getUserModel(),
        throwsA((Exception e) =>
            e is StorageException &&
            e.message == 'impossível converter o usuário.'),
      );
    });

    test('Test get UserModel with Storage Exception', () async {
      when(
        () => storage.getStorage(
          key: 'user',
        ),
      ).thenThrow(const StorageException('Storage error'));

      expect(
        () async => await authRepository.getUserModel(),
        throwsA((Exception e) =>
            e is StorageException && e.message == 'Storage error'),
      );
    });

    test('Test set UserModel with Storage Exception', () async {
      when(
        () => storage.insertStorage(
          key: 'user',
          value: any(named: 'value'),
        ),
      ).thenThrow(const StorageException('Storage error'));

      expect(
        () async => await authRepository.setUserModel(
          userModel: userModel,
        ),
        throwsA((Exception e) =>
            e is StorageException && e.message == 'Storage error'),
      );
    });
  });
}
