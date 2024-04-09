import 'package:flutter/material.dart';

class EmptyContactButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final double height;
  final double width;

  const EmptyContactButtonWidget({
    super.key,
    required this.onTap,
    this.height = 100,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
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
