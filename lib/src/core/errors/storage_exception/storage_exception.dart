import 'package:bookify/src/core/enums/storage_error_code.dart';

class StorageException implements Exception {
  final StorageErrorCode code;
  final String? descriptionMessage;

  const StorageException(
    this.code, {
    this.descriptionMessage,
  });

  @override
  String toString() => 'StorageException: [$code] $descriptionMessage';
}
