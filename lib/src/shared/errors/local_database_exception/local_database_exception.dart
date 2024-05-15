class LocalDatabaseException implements Exception {
  final String message;

  const LocalDatabaseException(this.message);

  @override
  String toString() => message;
}
