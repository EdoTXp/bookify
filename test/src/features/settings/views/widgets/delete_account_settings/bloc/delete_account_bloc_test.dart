import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/enums/auth_error_code.dart';
import 'package:bookify/src/core/enums/local_database_error_code.dart';
import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/domain/services/auth_service/auth_service.dart';
import 'package:bookify/src/domain/services/local_database_service/local_database_service.dart';
import 'package:bookify/src/domain/services/storage_services/storage_service.dart';
import 'package:bookify/src/features/settings/views/widgets/delete_account_settings/bloc/delete_account_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageService extends Mock implements StorageService {}

class MockLocalDatabaseService extends Mock implements LocalDatabaseService {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockStorageService storageService;
  late MockLocalDatabaseService localDatabaseService;
  late MockAuthService authService;
  late DeleteAccountBloc deleteAccountBloc;

  setUp(() {
    storageService = MockStorageService();
    localDatabaseService = MockLocalDatabaseService();
    authService = MockAuthService();

    deleteAccountBloc = DeleteAccountBloc(
      storageService: storageService,
      localDatabaseService: localDatabaseService,
      authService: authService,
    );
  });

  group('Test DeleteAccountBloc', () {
    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'Initial state is empty',
      build: () => deleteAccountBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'Test DeletedAccountEvent completes successfully',
      build: () => deleteAccountBloc,
      setUp: () {
        when(
          () => localDatabaseService.deleteDatabase(),
        ).thenAnswer((_) async {});
        when(() => storageService.clearAllStorage()).thenAnswer((_) async => 1);
        when(() => authService.deleteUserModel()).thenAnswer((_) async {});
      },
      act: (bloc) => bloc.add(DeletedAccountEvent()),
      verify: (_) {
        verify(() => localDatabaseService.deleteDatabase()).called(1);
        verify(() => storageService.clearAllStorage()).called(1);
        verify(() => authService.deleteUserModel()).called(1);
      },
      expect: () => [
        isA<DeleteAccountLoadingState>(),
        isA<DeleteAccountLoadedState>(),
      ],
    );

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'Test DeletedAccountEvent emits error when LocalDatabaseException is thrown',
      build: () => deleteAccountBloc,
      setUp: () {
        when(
          () => localDatabaseService.deleteDatabase(),
        ).thenThrow(
          const LocalDatabaseException(
            LocalDatabaseErrorCode.operationFailed,
            descriptionMessage: 'Error on Database',
          ),
        );
      },
      act: (bloc) => bloc.add(DeletedAccountEvent()),
      verify: (_) {
        verify(() => localDatabaseService.deleteDatabase()).called(1);
        verifyNever(() => storageService.clearAllStorage());
        verifyNever(() => authService.deleteUserModel());
      },
      expect: () => [
        isA<DeleteAccountLoadingState>(),
        isA<DeleteAccountErrorState>(),
      ],
    );

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'Test DeletedAccountEvent emits error when StorageException is thrown',
      build: () => deleteAccountBloc,
      setUp: () {
        when(
          () => localDatabaseService.deleteDatabase(),
        ).thenAnswer((_) async {});
        when(() => storageService.clearAllStorage()).thenThrow(
          const StorageException(
            StorageErrorCode.unknown,
            descriptionMessage: 'Error on Storage',
          ),
        );
      },
      act: (bloc) => bloc.add(DeletedAccountEvent()),
      verify: (_) {
        verify(() => localDatabaseService.deleteDatabase()).called(1);
        verify(() => storageService.clearAllStorage()).called(1);
        verifyNever(() => authService.deleteUserModel());
      },
      expect: () => [
        isA<DeleteAccountLoadingState>(),
        isA<DeleteAccountErrorState>(),
      ],
    );

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'Test DeletedAccountEvent emits error when AuthException is thrown',
      build: () => deleteAccountBloc,
      setUp: () {
        when(
          () => localDatabaseService.deleteDatabase(),
        ).thenAnswer((_) async {});
        when(() => storageService.clearAllStorage()).thenAnswer((_) async => 1);
        when(
          () => authService.deleteUserModel(),
        ).thenThrow(
          const AuthException(
            AuthErrorCode.internalError,
            descriptionMessage: 'Error on delete Account',
          ),
        );
      },
      act: (bloc) => bloc.add(DeletedAccountEvent()),
      verify: (_) {
        verify(() => localDatabaseService.deleteDatabase()).called(1);
        verify(() => storageService.clearAllStorage()).called(1);
        verify(() => authService.deleteUserModel()).called(1);
      },
      expect: () => [
        isA<DeleteAccountLoadingState>(),
        isA<DeleteAccountErrorState>(),
      ],
    );
  });
}
