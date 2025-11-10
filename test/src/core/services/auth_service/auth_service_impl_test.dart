import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_model.dart';
import 'package:bookify/src/core/repositories/auth_repository/auth_repository.dart';
import 'package:bookify/src/core/services/auth_service/auth_service_impl.dart';
import 'package:bookify/src/core/services/auth_service/auth_strategy/auth_strategy.dart';
import 'package:bookify/src/core/services/auth_service/auth_strategy/auth_strategy_factory.dart';
import 'package:bookify/src/shared/enums/sign_in_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

class AuthStrategyFactoryMock extends Mock implements AuthStrategyFactory {}

class AuthStrategyMock extends Mock implements AuthStrategy {}

void main() {
  late AuthServiceImpl authService;
  late AuthRepositoryMock authRepository;
  late AuthStrategyFactoryMock authStrategyFactory;
  late AuthStrategyMock authStrategy;
  late UserModel userModel;

  setUp(() {
    authRepository = AuthRepositoryMock();
    authStrategyFactory = AuthStrategyFactoryMock();
    authStrategy = AuthStrategyMock();

    authService = AuthServiceImpl(
      authRepository: authRepository,
      authStrategyFactory: authStrategyFactory,
    );

    userModel = UserModel(
      name: 'Test User',
      signInType: SignInType.google,
      photo: 'photo_url',
    );

    registerFallbackValue(userModel);
  });

  group('signIn tests', () {
    test(
      'Test signIn success',
      () async {
        when(() => authStrategyFactory.create(SignInType.google))
            .thenReturn(authStrategy);
        when(() => authStrategy.signIn()).thenAnswer((_) async => userModel);
        when(
          () => authRepository.setUserModel(userModel: userModel),
        ).thenAnswer((_) async => 1);

        final result = await authService.signIn(signInType: SignInType.google);

        expect(result, 1);
      },
    );

    test(
      'Test signIn throws AuthException when strategy fails',
      () async {
        when(() => authStrategyFactory.create(SignInType.google))
            .thenReturn(authStrategy);
        when(() => authStrategy.signIn())
            .thenThrow(AuthException('Strategy failed'));

        expect(
          () async => await authService.signIn(signInType: SignInType.google),
          throwsA((Exception e) =>
              e is AuthException && e.message == 'Strategy failed'),
        );
      },
    );

    test(
      'Test signIn throws AuthException when repository fails',
      () async {
        when(() => authStrategyFactory.create(SignInType.google))
            .thenReturn(authStrategy);
        when(() => authStrategy.signIn()).thenAnswer((_) async => userModel);
        when(() => authRepository.setUserModel(userModel: userModel))
            .thenThrow(StorageException('DB failed'));

        expect(
          () async => await authService.signIn(signInType: SignInType.google),
          throwsA(
              (Exception e) => e is AuthException && e.message == 'DB failed'),
        );
      },
    );
  });

  group('signOut tests', () {
    test(
      'Test signOut success',
      () async {
        when(() => authStrategyFactory.create(SignInType.google))
            .thenReturn(authStrategy);
        when(() => authStrategy.signOut()).thenAnswer((_) async => true);

        final result = await authService.signOut(signInType: SignInType.google);

        expect(result, isTrue);
        verify(() => authStrategyFactory.create(SignInType.google)).called(1);
        verify(() => authStrategy.signOut()).called(1);
      },
    );

    test(
      'Test signOut throws AuthException when strategy fails',
      () async {
        when(() => authStrategyFactory.create(SignInType.google))
            .thenReturn(authStrategy);
        when(() => authStrategy.signOut()).thenThrow(
          AuthException('Strategy failed'),
        );

        expect(
          () async => await authService.signOut(signInType: SignInType.google),
          throwsA((Exception e) =>
              e is AuthException && e.message == 'Strategy failed'),
        );
        verify(() => authStrategyFactory.create(SignInType.google)).called(1);
        verify(() => authStrategy.signOut()).called(1);
      },
    );
  });
}
