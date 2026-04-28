import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:localization/localization.dart';

extension StorageErrorCodeExtension on StorageErrorCode {
  String toLocalizedMessage(String? descriptionMessage) {
    final messageArg = descriptionMessage ?? '---';

    return switch (this) {
      StorageErrorCode.invalidValue => 'error-storage-invalid-value'.i18n([
        messageArg,
      ]),
      StorageErrorCode.dataLoss => 'error-storage-data-loss'.i18n([messageArg]),
      StorageErrorCode.notFound => 'error-storage-not-found'.i18n([messageArg]),
      StorageErrorCode.writeFailed => 'error-storage-write-failed'.i18n([
        messageArg,
      ]),
      StorageErrorCode.readFailed => 'error-storage-read-failed'.i18n([
        messageArg,
      ]),
      StorageErrorCode.unknown => 'error-unknown'.i18n([messageArg]),
    };
  }
}
