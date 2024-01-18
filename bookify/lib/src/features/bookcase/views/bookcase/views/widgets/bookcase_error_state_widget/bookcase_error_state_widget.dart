import 'package:flutter/material.dart';

class BookcaseErrorStateWidget extends StatelessWidget {
  final String message;

  const BookcaseErrorStateWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body:  Text('Aqui tem Um erro $message'),
    );
  }
}
