import 'dart:typed_data';
import 'package:flutter/material.dart';

class ContactCircleAvatar extends StatelessWidget {
  final String name;
  final Uint8List? photo;
  final double? height;
  final double? width;
  final VoidCallback? onTap;

  const ContactCircleAvatar({
    super.key,
    required this.name,
    this.photo,
    this.height,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: onTap,
        child: CircleAvatar(
          backgroundImage: (photo != null) ? MemoryImage(photo!) : null,
          backgroundColor: (photo == null) ? colorScheme.secondary : null,
          child: (photo == null)
              ? Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
