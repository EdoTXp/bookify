import 'dart:typed_data';
import 'package:flutter/material.dart';

class ContactCircleAvatar extends StatelessWidget {
  final String name;
  final Uint8List? photo;

  const ContactCircleAvatar({
    super.key,
    required this.name,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircleAvatar(
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
    );
  }
}
