import 'package:url_launcher/url_launcher_string.dart';

class BookDetailController {
  Future<void> launchUrl(String bookUrl) async {
    Future<bool> launchBookString = launchUrlString(
      bookUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!await launchBookString) {
      throw 'Could not launch $bookUrl';
    }
  }
}
