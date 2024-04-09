class LocalDatabaseException implements Exception {
  final String message;

  LocalDatabaseException(this.message);

  @override
  String toString() => message;
}
