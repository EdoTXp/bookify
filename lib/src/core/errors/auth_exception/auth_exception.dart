import 'package:bookify/src/core/enums/auth_error_code.dart';

class AuthException implements Exception {
  final AuthErrorCode code;
  final String? descriptionMessage;

  const AuthException(
    this.code, {
    this.descriptionMessage,
  });

  @override
  String toString() => 'AuthException: [$code] $descriptionMessage';
}
