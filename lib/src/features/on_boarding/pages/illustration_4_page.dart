import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class Illustration4Page extends StatelessWidget {
  const Illustration4Page({super.key});

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
              key: const Key('Illustration4'),
              height: mediaQuerySizeOf.height * .4,
              width: mediaQuerySizeOf.width,
              BookifyImages.illustration_4,
              fit: BoxFit.scaleDown,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'onboarding-title4'.i18n(),
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
              'onboarding-description4'.i18n(),
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
