import 'package:flutter/material.dart';

/// Extension on the Color class to add functionality for darkening and lightening colors.
extension ColorBrightnessExtension on Color {
  /// Method to darken the color by a specified amount.
  /// The amount parameter defaults to 0.1 (10%) if not provided.
  ///
  /// It asserts that the amount is between 0 and 1.
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    // Convert the color to HSL (Hue, Saturation, Lightness) format.
    final hsl = HSLColor.fromColor(this);
    // Adjust the lightness by subtracting the amount, clamping between 0.0 and 1.0.
    final hslDark = hsl.withLightness(
      (hsl.lightness - amount).clamp(
        0.0,
        1.0,
      ),
    );

    // Convert the HSL color back to a regular Color object and return it.
    return hslDark.toColor();
  }

  /// Method to lighten the color by a specified amount.
  /// The amount parameter defaults to 0.1 (10%) if not provided.
  ///
  /// It asserts that the amount is between 0 and 1.
  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    // Convert the color to HSL (Hue, Saturation, Lightness) format.
    final hsl = HSLColor.fromColor(this);
    // Adjust the lightness by adding the amount, clamping between 0.0 and 1.0.
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(
        0.0,
        1.0,
      ),
    );

    // Convert the HSL color back to a regular Color object and return it.
    return hslLight.toColor();
  }
}
