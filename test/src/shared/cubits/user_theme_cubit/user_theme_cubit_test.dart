import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/enums/app_theme_mode.dart';
import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/data/repositories/user_theme_repository/user_theme_repository.dart';
import 'package:bookify/src/shared/cubits/user_theme_cubit/user_theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class UserThemeRepositoryMock extends Mock implements UserThemeRepository {}

void main() {
  late UserThemeRepositoryMock repository;

  setUp(() {
    repository = UserThemeRepositoryMock();
  });

  group('UserThemeCubit', () {
    test('initial state is UserThemeLoadingState', () {
      final cubit = UserThemeCubit(repository);
      addTearDown(cubit.close);

      expect(cubit.state, isA<UserThemeLoadingState>());
    });

    group('getTheme', () {
      blocTest<UserThemeCubit, UserThemeState>(
        'emits Loading and then Loaded with the repository theme',
        setUp: () => when(
          () => repository.getThemeMode(),
        ).thenAnswer((_) async => AppThemeMode.light),
        build: () => UserThemeCubit(repository),
        act: (cubit) => cubit.getTheme(),
        expect: () => [
          isA<UserThemeLoadingState>(),
          isA<UserThemeLoadedState>().having(
            (s) => s.appThemeMode,
            'appThemeMode',
            AppThemeMode.light,
          ),
        ],
        verify: (_) => verify(() => repository.getThemeMode()).called(1),
      );

      blocTest<UserThemeCubit, UserThemeState>(
        'emits Error with system theme when StorageException is thrown',
        setUp: () => when(() => repository.getThemeMode()).thenThrow(
          const StorageException(
            StorageErrorCode.invalidValue,
            descriptionMessage: 'Error on storage Data',
          ),
        ),
        build: () => UserThemeCubit(repository),
        act: (cubit) => cubit.getTheme(),
        expect: () => [
          isA<UserThemeLoadingState>(),
          isA<UserThemeErrorState>()
              .having(
                (s) => s.appThemeMode,
                'appThemeMode',
                AppThemeMode.system,
              )
              .having(
                (s) => s.errorCode,
                'errorCode',
                StorageErrorCode.invalidValue,
              )
              .having(
                (s) => s.errorDescriptionMessage,
                'errorDescriptionMessage',
                'Error on storage Data',
              ),
        ],
      );

      blocTest<UserThemeCubit, UserThemeState>(
        'emits Error unknown with system theme when a generic Exception is thrown',
        setUp: () => when(
          () => repository.getThemeMode(),
        ).thenThrow(Exception('Generic Error')),
        build: () => UserThemeCubit(repository),
        act: (cubit) => cubit.getTheme(),
        expect: () => [
          isA<UserThemeLoadingState>(),
          isA<UserThemeErrorState>()
              .having(
                (s) => s.appThemeMode,
                'appThemeMode',
                AppThemeMode.system,
              )
              .having(
                (s) => s.errorCode,
                'errorCode',
                StorageErrorCode.unknown,
              )
              .having(
                (s) => s.errorDescriptionMessage,
                'errorDescriptionMessage',
                contains('Generic Error'),
              ),
        ],
      );
    });

    group('setTheme', () {
      blocTest<UserThemeCubit, UserThemeState>(
        'emits only Loaded with the new theme on success',
        setUp: () => when(
          () => repository.setThemeMode(appThemeMode: AppThemeMode.dark),
        ).thenAnswer((_) async => 1),
        build: () => UserThemeCubit(repository),
        seed: () => UserThemeLoadedState(appThemeMode: AppThemeMode.light),
        act: (cubit) => cubit.setTheme(appThemeMode: AppThemeMode.dark),
        expect: () => [
          isA<UserThemeLoadedState>().having(
            (s) => s.appThemeMode,
            'themeMode',
            AppThemeMode.dark,
          ),
        ],
        verify: (_) => verify(
          () => repository.setThemeMode(appThemeMode: AppThemeMode.dark),
        ).called(1),
      );

      blocTest<UserThemeCubit, UserThemeState>(
        'rolls back to the previous theme with writeFailed when insertion returns 0',
        setUp: () => when(
          () => repository.setThemeMode(appThemeMode: AppThemeMode.dark),
        ).thenAnswer((_) async => 0),
        build: () => UserThemeCubit(repository),
        seed: () => UserThemeLoadedState(appThemeMode: AppThemeMode.light),
        act: (cubit) => cubit.setTheme(appThemeMode: AppThemeMode.dark),
        expect: () => [
          isA<UserThemeLoadedState>().having(
            (s) => s.appThemeMode,
            'appThemeMode',
            AppThemeMode.dark,
          ),
          isA<UserThemeErrorState>()
              .having((s) => s.appThemeMode, 'appThemeMode', AppThemeMode.light)
              .having(
                (s) => s.errorCode,
                'errorCode',
                StorageErrorCode.writeFailed,
              ),
        ],
      );

      blocTest<UserThemeCubit, UserThemeState>(
        'rolls back to the previous theme with the repository code when StorageException is thrown',
        setUp: () =>
            when(
              () => repository.setThemeMode(appThemeMode: AppThemeMode.dark),
            ).thenThrow(
              const StorageException(
                StorageErrorCode.invalidValue,
                descriptionMessage: 'Error on storage Data',
              ),
            ),
        build: () => UserThemeCubit(repository),
        seed: () => UserThemeLoadedState(appThemeMode: AppThemeMode.light),
        act: (cubit) => cubit.setTheme(appThemeMode: AppThemeMode.dark),
        expect: () => [
          isA<UserThemeLoadedState>(),
          isA<UserThemeErrorState>()
              .having((s) => s.appThemeMode, 'appThemeMode', AppThemeMode.light)
              .having(
                (s) => s.errorCode,
                'errorCode',
                StorageErrorCode.invalidValue,
              ),
        ],
      );

      blocTest<UserThemeCubit, UserThemeState>(
        'rolls back to the previous theme with unknown code when a generic Exception is thrown',
        setUp: () => when(
          () => repository.setThemeMode(appThemeMode: AppThemeMode.dark),
        ).thenThrow(Exception('Generic Error')),
        build: () => UserThemeCubit(repository),
        seed: () => UserThemeLoadedState(appThemeMode: AppThemeMode.light),
        act: (cubit) => cubit.setTheme(appThemeMode: AppThemeMode.dark),
        expect: () => [
          isA<UserThemeLoadedState>(),
          isA<UserThemeErrorState>()
              .having((s) => s.appThemeMode, 'appThemeMode', AppThemeMode.light)
              .having(
                (s) => s.errorCode,
                'errorCode',
                StorageErrorCode.unknown,
              ),
        ],
      );
    });
  });
}
