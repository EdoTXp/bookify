import 'package:bookify/src/core/services/app_services/app_version_service/app_version.dart';
import 'package:bookify/src/core/services/app_services/app_version_service/app_version_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionServiceImpl implements AppVersionService {
  late PackageInfo _packageInfo;

  @override
  Future<AppVersion> getAppVersion() async {
    _packageInfo = await PackageInfo.fromPlatform();

    final appVersion = AppVersion(
      appName: _packageInfo.appName,
      appPackageName: _packageInfo.packageName,
      version: _packageInfo.version,
      buildNumber: _packageInfo.buildNumber,
    );

    return appVersion;
  }
}
