import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/enums/auth_error_code.dart';
import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/services/auth_service/auth_service.dart';
import 'package:bookify/src/shared/cubits/user_logged_cubit/user_logged_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AuthServiceMock extends Mock implements AuthService {}

void main() {
  final authService = AuthServiceMock();
  late UserLoggedCubit userLoggedCubit;

  setUp(() {
    userLoggedCubit = UserLoggedCubit(
      authService,
    );
  });

  group('Test UserLogged Cubit', () {
    blocTest(
      'Initial state is empty',
      build: () => userLoggedCubit,
      verify: (cubit) async => await cubit.close(),
      expect: () => [],
    );

    blocTest(
      'Test checkAuthStatus function work when user is logged in',
      build: () => userLoggedCubit,
      setUp: () =>
          when(
            () => authService.userIsLoggedIn(),
          ).thenAnswer(
            (_) async => true,
          ),
      act: (cubit) => cubit.checkAuthStatus(),
      verify: (_) => verify(
        () => authService.userIsLoggedIn(),
      ).called(1),
      expect: () => [
        isA<UserLoggedLoadingState>(),
        isA<UserLoggedLoadedState>(),
      ],
    );

    blocTest(
      'Test checkAuthStatus function work when user is NOT logged in',
      build: () => userLoggedCubit,
      setUp: () =>
          when(
            () => authService.userIsLoggedIn(),
          ).thenAnswer(
            (_) async => false,
          ),
      act: (cubit) => cubit.checkAuthStatus(),
      verify: (_) => verify(
        () => authService.userIsLoggedIn(),
      ).called(1),
      expect: () => [
        isA<UserLoggedLoadingState>(),
        isA<UserLoggedLoadedState>(),
      ],
    );

    blocTest(
      'Test checkAuthStatus function work when throw AuthException',
      build: () => userLoggedCubit,
      setUp: () =>
          when(
            () => authService.userIsLoggedIn(),
          ).thenThrow(
            const AuthException(
              AuthErrorCode.internalError,
              descriptionMessage: 'Error on Auth Service',
            ),
          ),
      act: (cubit) => cubit.checkAuthStatus(),
      verify: (_) => verify(
        () => authService.userIsLoggedIn(),
      ).called(1),
      expect: () => [
        isA<UserLoggedLoadingState>(),
        isA<UserLoggedErrorState>(),
      ],
    );

    blocTest(
      'Test checkAuthStatus function work when throw Generic Exception',
      build: () => userLoggedCubit,
      setUp: () => when(
        () => authService.userIsLoggedIn(),
      ).thenThrow(Exception('Generic Error')),
      act: (cubit) => cubit.checkAuthStatus(),
      verify: (_) => verify(
        () => authService.userIsLoggedIn(),
      ).called(1),
      expect: () => [
        isA<UserLoggedLoadingState>(),
        isA<UserLoggedErrorState>(),
      ],
    );
  });
}
