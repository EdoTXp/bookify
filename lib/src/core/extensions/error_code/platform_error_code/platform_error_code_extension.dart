import 'package:bookify/src/core/enums/platform_error_code.dart'; // Assicurati che l'import sia corretto
import 'package:localization/localization.dart';

extension PlatformErrorCodeExtension on PlatformErrorCode {
  String toLocalizedMessage(String? descriptionMessage) {
    final messageArg = descriptionMessage ?? '---';

    return switch (this) {
      PlatformErrorCode.permissionDenied =>
        'error-platform-permission-denied'.i18n([
          messageArg,
        ]),
      PlatformErrorCode.permissionPermanentlyDenied =>
        'error-platform-permission-permanently-denied'.i18n([
          messageArg,
        ]),
      PlatformErrorCode.unsupported => 'error-platform-unsupported'.i18n([
        messageArg,
      ]),
      PlatformErrorCode.unknown => 'error-unknown'.i18n([
        messageArg,
      ]),
    };
  }
}
