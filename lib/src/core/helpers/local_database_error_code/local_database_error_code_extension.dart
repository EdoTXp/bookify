import 'package:bookify/src/shared/enums/local_database_error_code.dart';
import 'package:localization/localization.dart';

// TODO Localizate the messages 

extension LocalDatabaseErrorCodeExtension on LocalDatabaseErrorCode {
  String toLocalizedMessage(String? descriptionMessage) {
    final messageArg = descriptionMessage ?? '---';

    return switch (this) {
      LocalDatabaseErrorCode.noSuchTable =>
        'error-local-database-no-such-table'.i18n([
          messageArg,
        ]),
      LocalDatabaseErrorCode.duplicateColumn =>
        'error-local-database-duplicate-column'.i18n([
          messageArg,
        ]),
      LocalDatabaseErrorCode.syntaxError =>
        'error-local-database-syntax-error'.i18n([
          messageArg,
        ]),
      LocalDatabaseErrorCode.openFailed =>
        'error-local-database-open-failed'.i18n([
          messageArg,
        ]),
      LocalDatabaseErrorCode.databaseClosed =>
        'error-local-database-database-closed'.i18n([
          messageArg,
        ]),
      LocalDatabaseErrorCode.readOnly => 'error-local-database-read-only'.i18n([
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
      LocalDatabaseErrorCode.invalidData =>
        'error-local-database-invalid-data'.i18n([
          messageArg,
        ]),
      LocalDatabaseErrorCode.unknown => 'error-local-database-unknown'.i18n([
        messageArg,
      ]),
    };
  }
}
