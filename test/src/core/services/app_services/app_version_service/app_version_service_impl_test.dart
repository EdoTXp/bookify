import 'package:bookify/src/core/services/app_services/app_version_service/app_version.dart';
import 'package:bookify/src/core/services/app_services/app_version_service/app_version_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AppVersionServiceMock extends Mock implements AppVersionServiceImpl {}

void main() {
  final appVersionService = AppVersionServiceMock();

  test(
    'Test get App Version',
    () async {
      when(() => appVersionService.getAppVersion()).thenAnswer(
        (_) async => const AppVersion(
          appName: 'BookifyTest',
          version: '123',
          buildNumber: '123',
        ),
      );

      final appVersion = await appVersionService.getAppVersion();

      expect(appVersion.appName, equals('BookifyTest'));
      expect(appVersion.version, equals('123'));
      expect(appVersion.buildNumber, equals('123'));
    },
  );
}
