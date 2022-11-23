import 'package:flutter/material.dart';

class PublisherCircularButton extends StatelessWidget {
  final String publisher;

  const PublisherCircularButton({super.key, required this.publisher});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).unselectedWidgetColor,
          radius: 30,
          child: Text(
            publisher.characters.first.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          publisher,
          style: const TextStyle(),
        )
      ],
    );
  }
}
