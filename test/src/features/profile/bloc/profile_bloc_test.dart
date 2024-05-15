import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/profile/bloc/profile_bloc.dart';
import 'package:bookify/src/shared/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/shared/models/user_model.dart';
import 'package:bookify/src/shared/services/auth_service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AuthServiceMock extends Mock implements AuthService {}

void main() {
  final authService = AuthServiceMock();
  late ProfileBloc settingsBloc;

  setUp(() {
    settingsBloc = ProfileBloc(authService);
  });

  group('Test Settings bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => settingsBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotUserSettingEvent work',
      build: () => settingsBloc,
      setUp: () => when(
        () => authService.getUserModel(),
      ).thenAnswer(
        (_) async => const UserModel(
          name: 'name',
          photo: 'photo',
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
      build: () => settingsBloc,
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
      build: () => settingsBloc,
      setUp: () => when(
        () => authService.getUserModel(),
      ).thenThrow(
        const AuthException('Error on authentification'),
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
      build: () => settingsBloc,
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
  });
}
