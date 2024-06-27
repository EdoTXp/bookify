import 'package:bookify/src/core/services/app_services/app_version_service/app_version.dart';
import 'package:bookify/src/core/services/app_services/launcher_service/launcher_service.dart';
import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:flutter/material.dart';

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
              'Versão: ${appVersion.version}',
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
                const Text(
                  'Projetado por',
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
                const Text(
                  'Desenvolvido por',
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
