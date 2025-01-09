import 'package:bookify/src/core/helpers/color_to_int/color_to_int_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test the int value of the color ', () {
    test('Test if yellow color as correct int', () {
      final yellowColor = Color(0xFFFFEB3B);
      final int yellowColorInt = yellowColor.colorToInt();
      final newYellowColor = Color(yellowColorInt);

      expect(newYellowColor, equals(yellowColor));
    });

    test('Test if red color as correct int', () {
      final redColor = Color(0xFFE57373);
      final int redColorInt = redColor.colorToInt();
      final newRedColor = Color(redColorInt);

      expect(newRedColor, equals(redColor));
    });

    test('Test if blue color as correct int', () {
      final blueColor = Color(0xFF64B5F6);
      final int blueColorInt = blueColor.colorToInt();
      final newBlueColor = Color(blueColorInt);

      expect(newBlueColor, equals(blueColor));
    });

    test('Test if green color as correct int', () {
      final greenColor = Color(0xFF81C784);
      final int greenColorInt = greenColor.colorToInt();
      final newGreenColor = Color(greenColorInt);

      expect(newGreenColor, equals(greenColor));
    });
  });
}
