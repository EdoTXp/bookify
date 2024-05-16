import 'package:flutter/material.dart';

class TermsInformations extends StatelessWidget {
  const TermsInformations({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        text: 'Ao inscrever-se, concorda com os ',
        children: [
          TextSpan(
            text: 'Termos de serviço ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: 'e a '),
          TextSpan(
            text: 'Política de privacidade ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: 'da Bookify.'),
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
