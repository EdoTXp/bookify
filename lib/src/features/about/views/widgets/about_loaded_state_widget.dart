import 'package:bookify/src/core/models/app_version_model.dart';
import 'package:bookify/src/core/helper/launcher/launcher_helper.dart';
import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:bookify/src/shared/constants/strings/bookify_strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class AboutLoadedStateWidget extends StatefulWidget {
  final AppVersionModel appVersionModel;

  const AboutLoadedStateWidget({
    super.key,
    required this.appVersionModel,
  });

  @override
  State<AboutLoadedStateWidget> createState() => _AboutLoadedStateWidgetState();
}

class _AboutLoadedStateWidgetState extends State<AboutLoadedStateWidget> {
  late TapGestureRecognizer _designerRecognizer;
  late TapGestureRecognizer _developerRecognizer;

  @override
  void initState() {
    super.initState();

    _designerRecognizer = TapGestureRecognizer()
      ..onTap = () async => await LauncherHelper.openUrl(
        BookifyStrings.designerUrl,
      );

    _developerRecognizer = TapGestureRecognizer()
      ..onTap = () async => await LauncherHelper.openUrl(
        BookifyStrings.developerUrl,
      );
  }

  @override
  void dispose() {
    _designerRecognizer.dispose();
    _developerRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              widget.appVersionModel.appName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Text(
              'version-label'.i18n([widget.appVersionModel.version]),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 220,
              height: 220,
              decoration: Theme.brightnessOf(context) == Brightness.dark
                  ? const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    )
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  BookifyImages.logoMini,
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text.rich(
              TextSpan(
                text: 'design-by-label'.i18n(),
                style: const TextStyle(
                  fontSize: 15,
                ),
                children: [
                  TextSpan(
                    text: ' Fredson',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: .bold,
                      color: colorScheme.primary,
                    ),
                    recognizer: _designerRecognizer,
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'developed-by-label'.i18n(),
                style: const TextStyle(
                  fontSize: 15,
                ),
                children: [
                  TextSpan(
                    text: ' Edoardo',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: .bold,
                      color: colorScheme.primary,
                    ),
                    recognizer: _developerRecognizer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
