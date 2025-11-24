import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int seconds;

  const TimerWidget({super.key, required this.seconds});

  String _formatTimeStringMinutesSeconds(int seconds) {
    // Handle zero or negative seconds
    if (seconds <= 0) {
      return '00m:00s';
    }

    // Convert seconds into minutes and remaining seconds
    int minutes = (seconds / 60).floor();
    seconds = seconds % 60;

    // Format the time string with leading zeros for minutes
    return "${minutes.toString().padLeft(2, '0')}m:${seconds.toString().padLeft(2, '0')}s";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: colorScheme.secondary,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _formatTimeStringMinutesSeconds(
          seconds,
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
