import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class TermsInformation extends StatelessWidget {
  const TermsInformation({super.key});

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
          ),
          TextSpan(
            text: 'terms-information3'.i18n(),
          ),
          TextSpan(
            text: 'terms-information4'.i18n(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
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
