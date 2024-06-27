import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/services/app_services/app_version_service/app_version.dart';
import 'package:bookify/src/core/services/app_services/app_version_service/app_version_service.dart';
import 'package:bookify/src/features/about/bloc/about_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AppVersionServiceMock extends Mock implements AppVersionService {}

void main() {
  final appVersionService = AppVersionServiceMock();
  late AboutBloc aboutBloc;

  setUp(() {
    aboutBloc = AboutBloc(appVersionService);
  });

  group('Test About bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => aboutBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotAppVersionEvent work',
      build: () => aboutBloc,
      setUp: () => when(() => appVersionService.getAppVersion()).thenAnswer(
        (_) async => const AppVersion(
          appName: 'BookifyTest',
          version: '123',
          buildNumber: '123',
        ),
      ),
      act: (bloc) => bloc.add(GotAppVersionEvent()),
      verify: (_) => verify(() => appVersionService.getAppVersion()).called(1),
      expect: () => [
        isA<AboutLoadingState>(),
        isA<AboutLoadeadState>(),
      ],
    );

    blocTest(
      'Test GotAppVersionEvent work when throw Generic Exception',
      build: () => aboutBloc,
      setUp: () => when(() => appVersionService.getAppVersion())
          .thenThrow(Exception('Generic Error')),
      act: (bloc) => bloc.add(GotAppVersionEvent()),
      verify: (_) => verify(() => appVersionService.getAppVersion()).called(1),
      expect: () => [
        isA<AboutLoadingState>(),
        isA<AboutErrorState>(),
      ],
    );
  });
}
