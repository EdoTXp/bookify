import 'package:flutter/material.dart';

class EmptyBookButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final double height;
  final double width;
  final bool bookIsValid;

  const EmptyBookButtonWidget({
    super.key,
    required this.onTap,
    this.height = 200,
    this.width = 100,
    required this.bookIsValid,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colorBorder = bookIsValid ? Colors.grey[300]! : colorScheme.error;


    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
            color: colorBorder,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(
          Icons.add_rounded,
          size: 82,
        ),
      ),
    );
  }
}
