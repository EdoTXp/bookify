import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/repositories/user_theme_repository/user_theme_repository.dart';
import 'package:bookify/src/shared/cubits/user_theme_cubit/user_theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class UserThemeRepositoryMock extends Mock implements UserThemeRepository {}

void main() {
  final userRepository = UserThemeRepositoryMock();
  late UserThemeCubit userThemeCubit;

  setUp(() {
    userThemeCubit = UserThemeCubit(
      userRepository,
    );
  });

  group('Test UserTheme Cubit', () {
    blocTest(
      'Initial state is empty',
      build: () => userThemeCubit,
      verify: (cubit) async => await cubit.close(),
      expect: () => [],
    );

    blocTest(
      'Test getTheme function work',
      build: () => userThemeCubit,
      setUp: () => when(
        () => userRepository.getThemeMode(),
      ).thenAnswer(
        (_) async => ThemeMode.light,
      ),
      act: (cubit) => cubit.getTheme(),
      verify: (_) => verify(
        () => userRepository.getThemeMode(),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeLoadedState>(),
      ],
    );

    blocTest(
      'Test getTheme function work when ThemeMode is null',
      build: () => userThemeCubit,
      setUp: () {
        when(
          () => userRepository.getThemeMode(),
        ).thenAnswer((_) async => null);

        when(
          () => userRepository.setThemeMode(themeMode: ThemeMode.system),
        ).thenAnswer((_) async => 1);
      },
      act: (cubit) => cubit.getTheme(),
      verify: (_) {
        verify(
          () => userRepository.getThemeMode(),
        ).called(1);
        verify(
          () => userRepository.setThemeMode(themeMode: ThemeMode.system),
        ).called(1);
      },
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeLoadedState>(),
      ],
    );

    blocTest(
      'Test getTheme function work when throw StorageException',
      build: () => userThemeCubit,
      setUp: () => when(
        () => userRepository.getThemeMode(),
      ).thenThrow(const StorageException('Error on storage Data')),
      act: (cubit) => cubit.getTheme(),
      verify: (_) => verify(
        () => userRepository.getThemeMode(),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeErrorState>(),
      ],
    );

    blocTest(
      'Test getTheme function work when throw Generic Exception',
      build: () => userThemeCubit,
      setUp: () => when(
        () => userRepository.getThemeMode(),
      ).thenThrow(Exception('Generic Error')),
      act: (bloc) => bloc.getTheme(),
      verify: (_) => verify(
        () => userRepository.getThemeMode(),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeErrorState>(),
      ],
    );

    blocTest(
      'Test setTheme function work',
      build: () => userThemeCubit,
      setUp: () => when(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).thenAnswer((_) async => 1),
      act: (cubit) => cubit.setTheme(
        themeMode: ThemeMode.system,
      ),
      verify: (_) => verify(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeLoadedState>(),
      ],
    );

    blocTest(
      'Test setTheme function work when insertion theme error',
      build: () => userThemeCubit,
      setUp: () => when(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).thenAnswer((_) async => 0),
      act: (cubit) => cubit.setTheme(
        themeMode: ThemeMode.system,
      ),
      verify: (_) => verify(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeErrorState>(),
      ],
    );

    blocTest(
      'Test setTheme function work when throw StorageException',
      build: () => userThemeCubit,
      setUp: () => when(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).thenThrow(const StorageException('Error on storage Data')),
      act: (cubit) => cubit.setTheme(
        themeMode: ThemeMode.system,
      ),
      verify: (_) => verify(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeErrorState>(),
      ],
    );

    blocTest(
      'Test setTheme function work when throwGeneric Exception',
      build: () => userThemeCubit,
      setUp: () => when(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).thenThrow(Exception('Generic Error')),
      act: (cubit) => cubit.setTheme(
        themeMode: ThemeMode.system,
      ),
      verify: (_) => verify(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeErrorState>(),
      ],
    );
  });
}
