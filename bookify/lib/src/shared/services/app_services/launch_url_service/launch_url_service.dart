import 'package:url_launcher/url_launcher_string.dart';

class LaunchUrlService {
  static Future<void> launchUrl(String url) async {
    final launchBookString = launchUrlString(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!await launchBookString) {
      throw Exception('Erro ao abrir o link: $url');
    }
  }
}
