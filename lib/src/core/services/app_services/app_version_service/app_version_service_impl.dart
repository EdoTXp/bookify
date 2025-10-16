import 'package:bookify/src/core/models/app_version_model.dart';
import 'package:bookify/src/core/services/app_services/app_version_service/app_version_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionServiceImpl implements AppVersionService {
  const AppVersionServiceImpl();

  @override
  Future<AppVersionModel> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final appVersion = AppVersionModel(
      appName: packageInfo.appName,
      appPackageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );

    return appVersion;
  }
}
