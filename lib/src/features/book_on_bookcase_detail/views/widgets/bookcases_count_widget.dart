import 'package:flutter/material.dart';

enum StatusType { loaded, error }

class BookcasesCountWidget extends StatelessWidget {
  final String message;
  final StatusType statusType;

  const BookcasesCountWidget({
    super.key,
    required this.message,
    required this.statusType,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: statusType == StatusType.loaded
            ? colorScheme.secondary
            : colorScheme.error,
        borderRadius: BorderRadius.circular(
          22,
        ),
      ),
      child: Text(
        statusType == StatusType.loaded
            ? 'Estantes com esse livro: $message'
            : message,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        textScaler: TextScaler.noScaling,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
