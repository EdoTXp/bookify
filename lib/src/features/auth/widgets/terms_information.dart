import 'package:bookify/src/core/services/app_services/launcher_service/launcher_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class TermsInformation extends StatefulWidget {
  const TermsInformation({super.key});

  @override
  State<TermsInformation> createState() => _TermsInformationState();
}

class _TermsInformationState extends State<TermsInformation> {
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () async => await LauncherService.openUrl(
        'https://edotxp.github.io/projects/bookify/terms.html',
      );

    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () async => await LauncherService.openUrl(
        'https://edotxp.github.io/projects/bookify/privacy-policy.html',
      );
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'terms-information1'.i18n(),
        children: [
          TextSpan(
            text: 'terms-information2'.i18n(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            recognizer: _termsRecognizer,
          ),
          TextSpan(
            text: 'terms-information3'.i18n(),
          ),
          TextSpan(
            text: 'terms-information4'.i18n(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            recognizer: _privacyRecognizer,
          ),
          TextSpan(
            text: 'terms-information5'.i18n(),
          ),
        ],
        style: TextStyle(
          fontSize: 12,
        ),
      ),
      textAlign: TextAlign.center,
      textScaler: TextScaler.noScaling,
    );
  }
}
