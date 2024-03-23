import 'package:flutter/material.dart';

class EmptyContactButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const EmptyContactButtonWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
            color: Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(42),
        ),
        child: const Icon(
          Icons.add_rounded,
          size: 42,
        ),
      ),
    );
  }
}
