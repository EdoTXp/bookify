import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/shared/blocs/user_theme_bloc/user_theme_bloc.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/repositories/user_theme_repository/user_theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class UserThemeRepositoryMock extends Mock implements UserThemeRepository {}

void main() {
  final userRepository = UserThemeRepositoryMock();
  late UserThemeBloc userThemeBloc;

  setUp(() {
    userThemeBloc = UserThemeBloc(
      userRepository,
    );
  });

  group('Test UserTheme Bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => userThemeBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotUserThemeEvent work',
      build: () => userThemeBloc,
      setUp: () => when(
        () => userRepository.getThemeMode(),
      ).thenAnswer(
        (_) async => ThemeMode.light,
      ),
      act: (bloc) => bloc.add(GotUserThemeEvent()),
      verify: (_) => verify(
        () => userRepository.getThemeMode(),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeLoadedState>(),
      ],
    );

    blocTest(
      'Test GotUserThemeEvent work when ThemeMode is null',
      build: () => userThemeBloc,
      setUp: () {
        when(
          () => userRepository.getThemeMode(),
        ).thenAnswer((_) async => null);

        when(
          () => userRepository.setThemeMode(themeMode: ThemeMode.system),
        ).thenAnswer((_) async => 1);
      },
      act: (bloc) => bloc.add(GotUserThemeEvent()),
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
      'Test GotUserThemeEvent work when throw StorageException',
      build: () => userThemeBloc,
      setUp: () => when(
        () => userRepository.getThemeMode(),
      ).thenThrow(const StorageException('Error on storage Data')),
      act: (bloc) => bloc.add(GotUserThemeEvent()),
      verify: (_) => verify(
        () => userRepository.getThemeMode(),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeErrorState>(),
      ],
    );

    blocTest(
      'Test GotUserThemeEvent work when throw Generic Exception',
      build: () => userThemeBloc,
      setUp: () => when(
        () => userRepository.getThemeMode(),
      ).thenThrow(Exception('Generic Error')),
      act: (bloc) => bloc.add(GotUserThemeEvent()),
      verify: (_) => verify(
        () => userRepository.getThemeMode(),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedUserThemeEvent work',
      build: () => userThemeBloc,
      setUp: () => when(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).thenAnswer((_) async => 1),
      act: (bloc) => bloc.add(InsertedUserThemeEvent(
        themeMode: ThemeMode.system,
      )),
      verify: (_) => verify(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeLoadedState>(),
      ],
    );

    blocTest(
      'Test InsertedUserThemeEvent work when insertion theme error',
      build: () => userThemeBloc,
      setUp: () => when(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).thenAnswer((_) async => 0),
      act: (bloc) => bloc.add(InsertedUserThemeEvent(
        themeMode: ThemeMode.system,
      )),
      verify: (_) => verify(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedUserThemeEvent work when throw StorageException',
      build: () => userThemeBloc,
      setUp: () => when(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).thenThrow(const StorageException('Error on storage Data')),
      act: (bloc) => bloc.add(InsertedUserThemeEvent(
        themeMode: ThemeMode.system,
      )),
      verify: (_) => verify(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).called(1),
      expect: () => [
        isA<UserThemeLoadingState>(),
        isA<UserThemeErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedUserThemeEvent work when throwGeneric Exception',
      build: () => userThemeBloc,
      setUp: () => when(
        () => userRepository.setThemeMode(themeMode: ThemeMode.system),
      ).thenThrow(Exception('Generic Error')),
      act: (bloc) => bloc.add(InsertedUserThemeEvent(
        themeMode: ThemeMode.system,
      )),
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
