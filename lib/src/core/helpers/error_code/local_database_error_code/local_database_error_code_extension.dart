import 'package:bookify/src/shared/enums/local_database_error_code.dart';
import 'package:localization/localization.dart';

extension LocalDatabaseErrorCodeExtension on LocalDatabaseErrorCode {
  String toLocalizedMessage(String? descriptionMessage) {
    final messageArg = descriptionMessage ?? '---';

    return switch (this) {
      LocalDatabaseErrorCode.openFailed =>
        'error-local-database-open-failed'.i18n([
          messageArg,
        ]),

      LocalDatabaseErrorCode.uniqueConstraint =>
        'error-local-database-unique-constraint'.i18n([
          messageArg,
        ]),
      LocalDatabaseErrorCode.notNullConstraint =>
        'error-local-database-not-null-constraint'.i18n([
          messageArg,
        ]),
      LocalDatabaseErrorCode.conversionFailed =>
        'error-local-database-conversion-failed'.i18n([
          messageArg,
        ]),
      LocalDatabaseErrorCode.unknown => 'error-unknown'.i18n([
        messageArg,
      ]),
      LocalDatabaseErrorCode.operationFailed =>
        'error-local-database-operation-failed'.i18n([
          messageArg,
        ]),
    };
  }
}
