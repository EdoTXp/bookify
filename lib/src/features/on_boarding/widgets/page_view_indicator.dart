import 'package:flutter/material.dart';

class PageViewIndicator extends StatelessWidget {
  final int quantity;
  final int currentPage;

  const PageViewIndicator({
    super.key,
    required this.quantity,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        quantity,
        (index) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 4.0,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withOpacity(
                currentPage == index ? 0.9 : 0.4,
              ),
            ),
          );
        },
      ),
    );
  }
}
