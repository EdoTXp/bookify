import 'package:flutter/material.dart';

class ContactInformationWidget extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String content;
  final CrossAxisAlignment columnCrossAxisAlignment;

  const ContactInformationWidget({
    super.key,
    required this.iconData,
    required this.title,
    required this.content,
    this.columnCrossAxisAlignment = CrossAxisAlignment.end
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: columnCrossAxisAlignment,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              iconData,
              size: 18,
              color: colorScheme.secondary,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Text(
          content,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
