import 'package:bookify/src/core/errors/platform_exception/platform_exception.dart';
import 'package:bookify/src/core/enums/platform_error_code.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class LauncherHelper {
  LauncherHelper._();

  static Future<void> openUrl(String url) async {
    try {
      final uri = Uri.parse(url);

      final urlIsLaunched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!urlIsLaunched) {
        throw const PlatformException(
          PlatformErrorCode.unknown,
          descriptionMessage: 'Impossible to launch the URL',
        );
      }
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }

  static Future<void> launchCall(String phone) async {
    try {
      final uri = Uri.parse(
        'tel:$phone',
      );

      if (await canLaunchUrl(uri)) {
        final callIsLaunched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!callIsLaunched) {
          throw const PlatformException(
            PlatformErrorCode.unknown,
            descriptionMessage: 'Impossible to launch the call',
          );
        }
      } else {
        throw const PlatformException(
          PlatformErrorCode.unsupported,
          descriptionMessage: 'The phone number format is not supported',
        );
      }
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }
}
