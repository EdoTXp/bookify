import 'package:bookify/src/core/enums/rest_client_error_code.dart';

class RestClientException implements Exception {
  final RestClientErrorCode code;
  final String? descriptionMessage;

  const RestClientException(
    this.code, {
    this.descriptionMessage,
  });

  @override
  String toString() => 'RestClientException: [$code] $descriptionMessage';
}
