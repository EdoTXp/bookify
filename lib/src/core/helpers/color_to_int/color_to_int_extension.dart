import 'package:flutter/material.dart';

/// Extension for the [Color] class that adds a method to convert a color to an integer.
extension ColorToIntExtension on Color {
  /// Converts a floating-point value (0.0 - 1.0) to an 8-bit integer (0 - 255).
  static int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }

  /// Converts the color to a 32-bit integer in ARGB format.
  int colorToInt() {
    return _floatToInt8(a) << 24 | // Alpha
        _floatToInt8(r) << 16 | // Red
        _floatToInt8(g) << 8 | // Green
        _floatToInt8(b) << 0; // Blue
  }
}
