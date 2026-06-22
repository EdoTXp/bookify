import 'package:bookify/src/core/enums/platform_error_code.dart';

class PlatformException implements Exception {
  final PlatformErrorCode code;
  final String? descriptionMessage;

  const PlatformException(
    this.code, {
    this.descriptionMessage,
  });

  @override
  String toString() => 'PlatformException: [$code] $descriptionMessage';
}
