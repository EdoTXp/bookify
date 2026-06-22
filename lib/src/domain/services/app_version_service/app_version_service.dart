import 'package:bookify/src/domain/models/app_version_model.dart';

abstract interface class AppVersionService {
  Future<AppVersionModel> getAppVersion();
}
