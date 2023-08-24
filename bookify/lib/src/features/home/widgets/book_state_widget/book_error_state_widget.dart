import 'package:flutter/material.dart';

import '../../../../shared/widgets/buttons/buttons.dart';

class BookErrorSateWidget extends StatelessWidget {
  final String stateMessage;
  final void Function() onPressed;

  const BookErrorSateWidget({
    required this.stateMessage,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'OPS!! $stateMessage',
              style: const TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 4,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 20,
            ),
            BookifyElevatedButton(
                onPressed: onPressed,
                suffixIcon: Icons.replay_outlined,
                text: 'Tentar novamente')
          ],
        ),
      ),
    );
  }
}
