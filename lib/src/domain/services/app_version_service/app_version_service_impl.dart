import 'package:bookify/src/core/errors/platform_exception/platform_exception.dart';
import 'package:bookify/src/domain/models/app_version_model.dart';
import 'package:bookify/src/domain/services/app_version_service/app_version_service.dart';
import 'package:bookify/src/core/enums/platform_error_code.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionServiceImpl implements AppVersionService {
  const AppVersionServiceImpl();

  @override
  Future<AppVersionModel> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      final appVersion = AppVersionModel(
        appName: packageInfo.appName,
        appPackageName: packageInfo.packageName,
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
      );

      return appVersion;
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }
}
