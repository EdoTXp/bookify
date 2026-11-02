enum AppThemeMode {
  light(1),
  dark(2),
  system(0);

  final int themeCode;
  const AppThemeMode(this.themeCode);

  static AppThemeMode fromCode(int? code) => values.firstWhere(
    (mode) => mode.themeCode == code,
    orElse: () => AppThemeMode.system,
  );
}
