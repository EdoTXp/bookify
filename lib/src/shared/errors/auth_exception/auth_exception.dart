class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}
