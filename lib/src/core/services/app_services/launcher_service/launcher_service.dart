import 'package:url_launcher/url_launcher.dart';

class LauncherService {
  static Future<void> openUrl(String url) async {
    try {
      final uri = Uri.parse(url);

      final urlIsLaunched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!urlIsLaunched) {
        throw 'Erro ao abrir o link';
      }
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado: $e');
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
          throw 'Erro ao efetuar a chamada';
        }
      } else {
        throw 'Não foi possível executar a ação de chamada';
      }
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado: $e');
    }
  }
}
