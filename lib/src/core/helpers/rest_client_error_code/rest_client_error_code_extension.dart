import 'package:bookify/src/core/enums/rest_client_error_code.dart';
import 'package:localization/localization.dart';

extension RestClientErrorCodeExtension on RestClientErrorCode {
  String toLocalizedMessage(String? description) {
    final messageArg = description ?? '---';

    return switch (this) {
      RestClientErrorCode.connectionTimeout =>
        'error-rest-client-connection-timeout'.i18n([
          messageArg,
        ]),
      RestClientErrorCode.receiveTimeout =>
        'error-rest-client-receive-timeout'.i18n([
          messageArg,
        ]),
      RestClientErrorCode.notFound => 'error-rest-client-not-found'.i18n([
        messageArg,
      ]),
      RestClientErrorCode.socketException =>
        'error-rest-client-socket-exception'.i18n([
          messageArg,
        ]),
      RestClientErrorCode.invalidInput => 'error-invalid-isbn'.i18n([
        messageArg,
      ]),
      RestClientErrorCode.unknown => 'error-unknown'.i18n([
        messageArg,
      ]),
    };
  }
}
