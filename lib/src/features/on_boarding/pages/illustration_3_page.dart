import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class Illustration3Page extends StatelessWidget {
  const Illustration3Page({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuerySizeOf = MediaQuery.sizeOf(context);

    return SizedBox(
      height: mediaQuerySizeOf.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              key: const Key('Illustration3'),
              height: mediaQuerySizeOf.height * .4,
              width: mediaQuerySizeOf.width,
              BookifyImages.illustration_3,
              fit: BoxFit.scaleDown,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'onboarding-title3'.i18n(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 32,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'onboarding-description3'.i18n(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
