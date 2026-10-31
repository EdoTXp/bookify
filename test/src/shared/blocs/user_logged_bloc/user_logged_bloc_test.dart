import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/enums/auth_error_code.dart';
import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/domain/services/auth_service/auth_service.dart';
import 'package:bookify/src/shared/blocs/user_logged_bloc/user_logged_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AuthServiceMock extends Mock implements AuthService {}

void main() {
  late AuthService authService;

  setUp(() {
    authService = AuthServiceMock();
  });

  group('UserLoggedBloc Tests', () {
    test('Initial state is UserLoggedLoadingState', () {
      final bloc = UserLoggedBloc(authService);
      expect(bloc.state, isA<UserLoggedLoadingState>());
      bloc.close();
    });

    blocTest<UserLoggedBloc, UserLoggedState>(
      'Emits [UserLoggedLoadingState, UserLoggedLoadedState] when user is logged in',
      build: () => UserLoggedBloc(authService),
      setUp: () =>
          when(
            () => authService.userIsLoggedIn(),
          ).thenAnswer(
            (_) async* {
              yield true;
            },
          ),
      act: (bloc) => bloc.add(CheckedAuthStatusEvent()),
      verify: (_) => verify(
        () => authService.userIsLoggedIn(),
      ).called(1),
      expect: () => [
        isA<UserLoggedLoadingState>(),
        isA<UserLoggedLoadedState>(),
      ],
    );

    blocTest<UserLoggedBloc, UserLoggedState>(
      'Emits [UserLoggedLoadingState, UserLoggedLoadedState] when user is NOT logged in',
      build: () => UserLoggedBloc(authService),
      setUp: () =>
          when(
            () => authService.userIsLoggedIn(),
          ).thenAnswer(
            (_) async* {
              yield false;
            },
          ),
      act: (bloc) => bloc.add(CheckedAuthStatusEvent()),
      verify: (_) => verify(
        () => authService.userIsLoggedIn(),
      ).called(1),
      expect: () => [
        isA<UserLoggedLoadingState>(),
        isA<UserLoggedLoadedState>(),
      ],
    );

    blocTest<UserLoggedBloc, UserLoggedState>(
      'Emits [UserLoggedLoadingState, UserLoggedErrorState] when AuthException is thrown',
      build: () => UserLoggedBloc(authService),
      setUp: () =>
          when(
            () => authService.userIsLoggedIn(),
          ).thenThrow(
            const AuthException(
              AuthErrorCode.internalError,
              descriptionMessage: 'Error on Auth Service',
            ),
          ),
      act: (bloc) => bloc.add(CheckedAuthStatusEvent()),
      verify: (_) => verify(
        () => authService.userIsLoggedIn(),
      ).called(1),
      expect: () => [
        isA<UserLoggedLoadingState>(),
        isA<UserLoggedErrorState>(),
      ],
    );

    blocTest<UserLoggedBloc, UserLoggedState>(
      'Emits [UserLoggedLoadingState, UserLoggedErrorState] when Generic Exception is thrown',
      build: () => UserLoggedBloc(authService),
      setUp: () => when(
        () => authService.userIsLoggedIn(),
      ).thenThrow(Exception('Generic Error')),
      act: (bloc) => bloc.add(CheckedAuthStatusEvent()),
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
