import 'package:bookify/src/core/services/app_services/app_version_service/app_version.dart';

abstract interface class AppVersionService {
  Future<AppVersion> getAppVersion();
}
