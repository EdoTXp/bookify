import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/profile/bloc/profile_bloc.dart';
import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/models/user_model.dart';
import 'package:bookify/src/core/services/auth_service/auth_service.dart';
import 'package:bookify/src/core/services/storage_services/storage_services.dart';
import 'package:bookify/src/shared/enums/sign_in_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AuthServiceMock extends Mock implements AuthService {}

class StorageServiceMock extends Mock implements StorageServices {}

void main() {
  final authService = AuthServiceMock();
  final storageService = StorageServiceMock();
  late ProfileBloc profileBloc;

  setUp(() {
    profileBloc = ProfileBloc(
      authService,
      storageService,
    );
  });

  group('Test Settings bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => profileBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotUserSettingEvent work',
      build: () => profileBloc,
      setUp: () => when(
        () => authService.getUserModel(),
      ).thenAnswer(
        (_) async => const UserModel(
          name: 'name',
          photo: 'photo',
          signInType: SignInType.google,
        ),
      ),
      act: (bloc) => bloc.add(
        GotUserProfileEvent(),
      ),
      verify: (_) => verify(
        () => authService.getUserModel(),
      ).called(1),
      expect: () => [
        isA<ProfileLoadingState>(),
        isA<ProfileLoadedState>(),
      ],
    );

    blocTest(
      'Test GotUserSettingEvent work user is null',
      build: () => profileBloc,
      setUp: () => when(
        () => authService.getUserModel(),
      ).thenAnswer(
        (_) async => null,
      ),
      act: (bloc) => bloc.add(
        GotUserProfileEvent(),
      ),
      verify: (_) => verify(
        () => authService.getUserModel(),
      ).called(1),
      expect: () => [
        isA<ProfileLoadingState>(),
        isA<ProfileErrorState>(),
      ],
    );

    blocTest(
      'Test GotUserSettingEvent work when throw AuthException',
      build: () => profileBloc,
      setUp: () => when(
        () => authService.getUserModel(),
      ).thenThrow(
        const AuthException('Error on authentication'),
      ),
      act: (bloc) => bloc.add(
        GotUserProfileEvent(),
      ),
      verify: (_) => verify(
        () => authService.getUserModel(),
      ).called(1),
      expect: () => [
        isA<ProfileLoadingState>(),
        isA<ProfileErrorState>(),
      ],
    );

    blocTest(
      'Test GotUserSettingEvent work when Generic Exception',
      build: () => profileBloc,
      setUp: () => when(
        () => authService.getUserModel(),
      ).thenThrow(
        Exception('Generic Error'),
      ),
      act: (bloc) => bloc.add(
        GotUserProfileEvent(),
      ),
      verify: (_) => verify(
        () => authService.getUserModel(),
      ).called(1),
      expect: () => [
        isA<ProfileLoadingState>(),
        isA<ProfileErrorState>(),
      ],
    );

    blocTest(
      'Test UserLoggedOutEvent work',
      build: () => profileBloc,
      setUp: () {
        when(
          () => authService.signOut(
            signInType: SignInType.google,
          ),
        ).thenAnswer(
          (_) async => true,
        );

        when(
          () => storageService.clearStorage(),
        ).thenAnswer(
          (_) async => 1,
        );
      },
      act: (bloc) => bloc.add(
        UserLoggedOutEvent(
          userModel: const UserModel(
            name: 'name',
            photo: 'photo',
            signInType: SignInType.google,
          ),
        ),
      ),
      verify: (_) {
        verify(
          () => authService.signOut(
            signInType: SignInType.google,
          ),
        ).called(1);

        verify(
          () => storageService.clearStorage(),
        ).called(1);
      },
      expect: () => [
        isA<ProfileLoadingState>(),
        isA<ProfileLogOutState>(),
      ],
    );

    blocTest(
      'Test UserLoggedOutEvent work when userLoggedOut is false',
      build: () => profileBloc,
      setUp: () => when(
        () => authService.signOut(
          signInType: SignInType.google,
        ),
      ).thenAnswer(
        (_) async => false,
      ),
      act: (bloc) => bloc.add(
        UserLoggedOutEvent(
          userModel: const UserModel(
            name: 'name',
            photo: 'photo',
            signInType: SignInType.google,
          ),
        ),
      ),
      verify: (_) {
        verify(
          () => authService.signOut(
            signInType: SignInType.google,
          ),
        ).called(1);

        verifyNever(
          () => storageService.clearStorage(),
        );
      },
      expect: () => [
        isA<ProfileLoadingState>(),
        isA<ProfileErrorState>(),
      ],
    );

    blocTest(
      'Test UserLoggedOutEvent work when storageRemoved is 0',
      build: () => profileBloc,
      setUp: () {
        when(
          () => authService.signOut(
            signInType: SignInType.google,
          ),
        ).thenAnswer(
          (_) async => true,
        );

        when(
          () => storageService.clearStorage(),
        ).thenAnswer(
          (_) async => 0,
        );
      },
      act: (bloc) => bloc.add(
        UserLoggedOutEvent(
          userModel: const UserModel(
            name: 'name',
            photo: 'photo',
            signInType: SignInType.google,
          ),
        ),
      ),
      verify: (_) {
        verify(
          () => authService.signOut(
            signInType: SignInType.google,
          ),
        ).called(1);

        verify(
          () => storageService.clearStorage(),
        ).called(1);
      },
      expect: () => [
        isA<ProfileLoadingState>(),
        isA<ProfileErrorState>(),
      ],
    );

    blocTest(
      'Test UserLoggedOutEvent work when throw AuthException',
      build: () => profileBloc,
      setUp: () => when(
        () => authService.signOut(
          signInType: SignInType.google,
        ),
      ).thenThrow(
        const AuthException('Error on authentication'),
      ),
      act: (bloc) => bloc.add(
        UserLoggedOutEvent(
          userModel: const UserModel(
            name: 'name',
            photo: 'photo',
            signInType: SignInType.google,
          ),
        ),
      ),
      verify: (_) {
        verify(
          () => authService.signOut(
            signInType: SignInType.google,
          ),
        ).called(1);

        verifyNever(
          () => storageService.clearStorage(),
        );
      },
      expect: () => [
        isA<ProfileLoadingState>(),
        isA<ProfileErrorState>(),
      ],
    );

    blocTest(
      'Test UserLoggedOutEvent work when throw Generic Exception',
      build: () => profileBloc,
      setUp: () => when(
        () => authService.signOut(
          signInType: SignInType.google,
        ),
      ).thenThrow(
        Exception('Generic Error'),
      ),
      act: (bloc) => bloc.add(
        UserLoggedOutEvent(
          userModel: const UserModel(
            name: 'name',
            photo: 'photo',
            signInType: SignInType.google,
          ),
        ),
      ),
      verify: (_) {
        verify(
          () => authService.signOut(
            signInType: SignInType.google,
          ),
        ).called(1);

        verifyNever(
          () => storageService.clearStorage(),
        );
      },
      expect: () => [
        isA<ProfileLoadingState>(),
        isA<ProfileErrorState>(),
      ],
    );
  });
}
