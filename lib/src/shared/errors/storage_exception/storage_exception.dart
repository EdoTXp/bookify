class StorageException implements Exception {
  final String message;

  const StorageException(this.message);

  @override
  String toString() => message;
}
