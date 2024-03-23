import 'package:flutter/material.dart';

class EmptyBookButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  const EmptyBookButtonWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        width: 170,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
            color: Colors.grey[300]!,
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
