import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class Header extends StatelessWidget {
  final String bookTitle;
  final String fistAuthorName;
  final int pagesReaded;
  final int pageCount;

  const Header({
    super.key,
    required this.bookTitle,
    required this.fistAuthorName,
    required this.pagesReaded,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.sizeOf(context).width,
      color: colorScheme.primary.withValues(
        alpha: .1,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              '$bookTitle - $fistAuthorName'.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'you-are-on-page-title'.i18n(),
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              '$pagesReaded/$pageCount',
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
