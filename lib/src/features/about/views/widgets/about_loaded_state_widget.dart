import 'package:bookify/src/core/services/app_services/app_version_service/app_version.dart';
import 'package:bookify/src/core/services/app_services/launcher_service/launcher_service.dart';
import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class AboutLoadedStateWidget extends StatelessWidget {
  final AppVersion appVersion;

  const AboutLoadedStateWidget({
    super.key,
    required this.appVersion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              appVersion.appName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'version-label'.i18n([appVersion.version]),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              BookifyImages.logoMini,
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'design-by-label'.i18n(),
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                TextButton(
                  child: const Text(
                    'Fredson',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () async => await LauncherService.openUrl(
                    'https://www.linkedin.com/in/fredsoncosta/',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'developed-by-label'.i18n(),
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                TextButton(
                  child: const Text(
                    'Edoardo',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () async => await LauncherService.openUrl(
                    'https://www.linkedin.com/in/edoardofabrizio/',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
