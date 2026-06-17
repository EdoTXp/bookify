import 'package:bookify/src/core/helper/launcher/launcher_helper.dart';
import 'package:bookify/src/shared/constants/strings/bookify_strings.dart';
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
      ..onTap = () async => await LauncherHelper.openUrl(
        BookifyStrings.termsUrl,
      );

    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () async => await LauncherHelper.openUrl(
        BookifyStrings.privacyUrl,
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            recognizer: _termsRecognizer,
          ),
          TextSpan(
            text: 'terms-information3'.i18n(),
          ),
          TextSpan(
            text: 'terms-information4'.i18n(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            recognizer: _privacyRecognizer,
          ),
          TextSpan(
            text: 'terms-information5'.i18n(),
          ),
        ],
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
      textAlign: TextAlign.center,
      textScaler: TextScaler.noScaling,
    );
  }
}
