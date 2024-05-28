import 'package:flutter/material.dart';

class ContactInformationWidget extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String content;
  final double? height;
  final double? width;
  final bool enableToolTip;

  const ContactInformationWidget({
    super.key,
    required this.iconData,
    required this.title,
    required this.content,
    this.height,
    this.width = 100,
    this.enableToolTip = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: (enableToolTip) ? content : null,
      child: SizedBox(
        height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  iconData,
                  size: 18,
                  color: colorScheme.secondary,
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  title,
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              content,
              textScaler: TextScaler.noScaling,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
