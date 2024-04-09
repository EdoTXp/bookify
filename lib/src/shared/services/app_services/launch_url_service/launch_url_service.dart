import 'package:url_launcher/url_launcher_string.dart';

class LaunchUrlService {
  static Future<void> launchUrl(String url) async {
    try {
      final launchUrl = launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );

      final bool isSuccefullyLaunch = await launchUrl;

      if (!isSuccefullyLaunch) {
        throw Exception('Erro ao abrir o link');
      }
    } catch (e) {
      throw Exception('Occoreu um erro inesperado: $e');
    }
  }
}
