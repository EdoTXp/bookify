class AppVersionModel {
  final String appName;
  final String version;
  final String buildNumber;
  final String? appPackageName;

  const AppVersionModel({
    required this.appName,
    required this.version,
    required this.buildNumber,
    this.appPackageName,
  });

  AppVersionModel copyWith({
    String? appName,
    String? version,
    String? buildNumber,
    String? appPackageName,
  }) {
    return AppVersionModel(
      appName: appName ?? this.appName,
      version: version ?? this.version,
      buildNumber: buildNumber ?? this.buildNumber,
      appPackageName: appPackageName ?? this.appPackageName,
    );
  }

  @override
  String toString() {
    return 'AppVersionModel(appName: $appName, version: $version, buildNumber: $buildNumber, appPackageName: $appPackageName)';
  }

  @override
  bool operator ==(covariant AppVersionModel other) {
    if (identical(this, other)) return true;

    return other.appName == appName &&
        other.version == version &&
        other.buildNumber == buildNumber &&
        other.appPackageName == appPackageName;
  }

  @override
  int get hashCode {
    return appName.hashCode ^
        version.hashCode ^
        buildNumber.hashCode ^
        appPackageName.hashCode;
  }
}
