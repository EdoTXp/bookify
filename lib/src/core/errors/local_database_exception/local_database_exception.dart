import 'package:bookify/src/core/enums/local_database_error_code.dart';

class LocalDatabaseException implements Exception {
  final LocalDatabaseErrorCode code;
  final String? descriptionMessage;

  const LocalDatabaseException(
    this.code, {
    this.descriptionMessage,
  });

  @override
  String toString() => 'LocalDatabaseException: [$code] $descriptionMessage';
}
