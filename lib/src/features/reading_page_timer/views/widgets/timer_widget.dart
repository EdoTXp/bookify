import 'package:flutter/material.dart';

/// A widget that displays a countdown timer formatted as minutes and seconds.
///
/// It animates individual digits vertically as they change and highlights
class TimerWidget extends StatelessWidget {
  /// The total remaining time in seconds.
  final int seconds;

  const TimerWidget({
    super.key,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Prevent negative values by normalizing the input to zero.
    final int totalSeconds = seconds <= 0 ? 0 : seconds;
    final int minutes = (totalSeconds / 60).floor();
    final int remainingSeconds = totalSeconds % 60;

    // Extract individual digits for both minutes and seconds.
    final int minutesTens = minutes ~/ 10;
    final int minutesOnes = minutes % 10;
    final int secondsTens = remainingSeconds ~/ 10;
    final int secondsOnes = remainingSeconds % 10;

    const TextStyle baseStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );

    return Container(
      decoration: BoxDecoration(
        border: .all(
          width: 2,
          color: colorScheme.secondary,
        ),
        borderRadius: .circular(20),
      ),
      child: Row(
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        children: [
          _buildAnimatedDigit(
            value: minutesTens,
            valueKey: 'minutesTens',
            style: baseStyle,
          ),
          _buildAnimatedDigit(
            value: minutesOnes,
            valueKey: 'minutesOnes',
            style: baseStyle,
          ),
          const Text(
            'm:',
            style: baseStyle,
          ),
          _buildAnimatedDigit(
            value: secondsTens,
            valueKey: 'secondsTens',
            style: baseStyle,
          ),
          // Dynamically choose the style based on the timer status.
          _buildAnimatedDigit(
            value: secondsOnes,
            valueKey: 'secondsOnes',
            style: baseStyle.copyWith(
              color: colorScheme.secondary,
            ),
          ),
          const Text(
            's',
            style: baseStyle,
          ),
        ],
      ),
    );
  }

  /// Builds an individual digit wrapped in an [AnimatedSwitcher]
  /// to slide numbers vertically during transitions.
  Widget _buildAnimatedDigit({
    required int value,
    required String valueKey,
    required TextStyle style,
  }) {
    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final inAnimation = Tween<Offset>(
            begin: const Offset(0, 1),
            end: .zero,
          ).animate(animation);

          final outAnimation = Tween<Offset>(
            begin: const Offset(0, -1),
            end: .zero,
          ).animate(animation);

          if (child.key == ValueKey('${valueKey}_$value')) {
            return SlideTransition(
              position: inAnimation,
              child: child,
            );
          } else {
            return SlideTransition(
              position: outAnimation,
              child: child,
            );
          }
        },
        child: Text(
          '$value',
          // Combining the field type and value ensures the animation triggers
          // exclusively for the digit that actually changed.
          key: ValueKey('${valueKey}_$value'),
          style: style,
          // StrutStyle prevents subtle layout shifts caused by different digit widths.
          strutStyle: StrutStyle(
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
          ),
        ),
      ),
    );
  }
}
