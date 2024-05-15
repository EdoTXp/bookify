import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/auth/bloc/auth_bloc.dart';
import 'package:bookify/src/shared/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/shared/services/auth_service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AuthServiceMock extends Mock implements AuthService {}

void main() {
  final authService = AuthServiceMock();
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc(authService);
  });

  group('Test Auth bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => authBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test SignedInAuthEvent work when Google button',
      build: () => authBloc,
      setUp: () => when(
        () => authService.signIn(
          signInType: SignInType.google,
        ),
      ).thenAnswer(
        (_) async => 1,
      ),
      act: (bloc) => bloc.add(
        SignedInAuthEvent(buttonType: 1),
      ),
      verify: (_) => verify(
        () => authService.signIn(
          signInType: SignInType.google,
        ),
      ).called(1),
      expect: () => [
        isA<AuthLoadingState>(),
        isA<AuthSignedState>(),
      ],
    );

    blocTest(
      'Test SignedInAuthEvent work when Facebook button',
      build: () => authBloc,
      setUp: () => when(
        () => authService.signIn(
          signInType: SignInType.facebook,
        ),
      ).thenAnswer(
        (_) async => 1,
      ),
      act: (bloc) => bloc.add(
        SignedInAuthEvent(buttonType: 3),
      ),
      verify: (_) => verify(
        () => authService.signIn(
          signInType: SignInType.facebook,
        ),
      ).called(1),
      expect: () => [
        isA<AuthLoadingState>(),
        isA<AuthSignedState>(),
      ],
    );

    blocTest(
      'Test SignedInAuthEvent work emit error on Apple button',
      build: () => authBloc,
      act: (bloc) => bloc.add(
        SignedInAuthEvent(buttonType: 2),
      ),
      verify: (_) => verifyNever(
        () => authService.signIn(
          signInType: SignInType.apple,
        ),
      ),
      expect: () => [
        isA<AuthLoadingState>(),
        isA<AuthErrorState>(),
      ],
    );

    blocTest(
      'Test SignedInAuthEvent work when authSignedIn is 0',
      build: () => authBloc,
      setUp: () => when(
        () => authService.signIn(
          signInType: SignInType.google,
        ),
      ).thenAnswer(
        (_) async => 0,
      ),
      act: (bloc) => bloc.add(
        SignedInAuthEvent(buttonType: 1),
      ),
      verify: (_) => verify(
        () => authService.signIn(
          signInType: SignInType.google,
        ),
      ).called(1),
      expect: () => [
        isA<AuthLoadingState>(),
        isA<AuthErrorState>(),
      ],
    );

    blocTest(
      'Test SignedInAuthEvent work when throw AuthException',
      build: () => authBloc,
      setUp: () => when(
        () => authService.signIn(
          signInType: SignInType.google,
        ),
      ).thenThrow(
        const AuthException('Error on authentification'),
      ),
      act: (bloc) => bloc.add(
        SignedInAuthEvent(buttonType: 1),
      ),
      verify: (_) => verify(
        () => authService.signIn(
          signInType: SignInType.google,
        ),
      ).called(1),
      expect: () => [
        isA<AuthLoadingState>(),
        isA<AuthErrorState>(),
      ],
    );

    blocTest(
      'Test SignedInAuthEvent work when throw Generic Exception',
      build: () => authBloc,
      setUp: () => when(
        () => authService.signIn(
          signInType: SignInType.google,
        ),
      ).thenThrow(
        Exception('Generic Error'),
      ),
      act: (bloc) => bloc.add(
        SignedInAuthEvent(buttonType: 1),
      ),
      verify: (_) => verify(
        () => authService.signIn(
          signInType: SignInType.google,
        ),
      ).called(1),
      expect: () => [
        isA<AuthLoadingState>(),
        isA<AuthErrorState>(),
      ],
    );
  });
}
