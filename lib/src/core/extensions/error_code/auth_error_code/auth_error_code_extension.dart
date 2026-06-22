import 'package:bookify/src/core/enums/auth_error_code.dart';
import 'package:localization/localization.dart';

extension AuthErrorCodeExtension on AuthErrorCode {
  String toLocalizedMessage(String? descriptionMessage) {
    final messageArg = descriptionMessage ?? '---';

    return switch (this) {
      AuthErrorCode.userNotFound => 'error-auth-user-not-found'.i18n([
        messageArg,
      ]),
      AuthErrorCode.wrongPassword => 'error-auth-wrong-password'.i18n([
        messageArg,
      ]),
      AuthErrorCode.invalidEmail => 'error-auth-invalid-email'.i18n([
        messageArg,
      ]),
      AuthErrorCode.accountDisabled => 'error-auth-account-disabled'.i18n([
        messageArg,
      ]),
      AuthErrorCode.tooManyRequests => 'error-auth-too-many-requests'.i18n([
        messageArg,
      ]),
      AuthErrorCode.operationNotAllowed =>
        'error-auth-operation-not-allowed'.i18n([messageArg]),
      AuthErrorCode.networkRequestFailed =>
        'error-auth-network-request-failed'.i18n([messageArg]),
      AuthErrorCode.internalError => 'error-auth-internal-error'.i18n([
        messageArg,
      ]),
      AuthErrorCode.unknown => 'error-unknown'.i18n([messageArg]),
    };
  }
}
