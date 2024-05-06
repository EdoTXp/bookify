class StorageException implements Exception {
  final String message;

  StorageException(this.message);

  @override
  String toString() => message;
}
