import 'package:bookify/src/core/models/app_version_model.dart';

abstract interface class AppVersionService {
  Future<AppVersionModel> getAppVersion();
}
