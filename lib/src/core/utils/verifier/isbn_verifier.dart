import 'package:characters/characters.dart';

/// A class to verify ISBN-10 and ISBN-13 codes.
///
/// This class uses regular expressions to validate the format of ISBN codes and then
/// checks the check digit for both ISBN-10 and ISBN-13 codes to ensure their validity.
class IsbnVerifier {
  // Regular expression to validate ISBN-10 and ISBN-13 codes.
  // This regex ensures the ISBN code contains only digits, 'X', or '-', and follows the structure of ISBN codes.
  // It checks for the presence of 9 digits followed by an 'X' or a digit, and optionally 3 more digits.
  static final _isbnRegExp = RegExp(
      r'^(?=(?:[^0-9]*[0-9]){9}[^0-9xX]*[0-9xX](?:(?:[^0-9]*[0-9]){3})?$)[\dXx-]+$');

  /// Getter for the ISBN format regular expression.
  /// This regex is used to validate if a given string is in a valid ISBN format.
  static RegExp get isbnFormatRegExp => _isbnRegExp;

  /// Verifies if the given value is a valid ISBN-10 or ISBN-13 code.
  ///
  /// - Removes spaces from the input value to ensure accurate validation.
  /// - Checks if the value is not empty and matches the ISBN format regex.
  /// - Removes hyphens and converts the value to lowercase for further processing.
  /// - Validates the ISBN code as either ISBN-10 or ISBN-13.
  /// - Returns the processed value if valid, otherwise null.
  String? verifyIsbn(String value) {
    value = value.replaceAll(' ', '');

    if (value.isNotEmpty && isbnFormatRegExp.hasMatch(value)) {
      value = value.replaceAll('-', '').toLowerCase();

      if (_validateIsbn10(value) || _validateIsbn13(value)) {
        return value;
      }
    }
    return null;
  }

  /// Validates the given value as an ISBN-10 code.
  ///
  /// - Checks if the value has exactly 10 characters, excluding the last character which can be 'X'.
  /// - Iterates through each character in the value, calculating the sum for the ISBN-10 check digit calculation.
  /// - Returns true if the result is divisible by 11, indicating a valid ISBN-10 code.
  bool _validateIsbn10(String value) {
    if (value.length == 10) {
      int result = 0;
      int multiple = 10;

      for (var actualChar in value.characters) {
        int sum = actualChar != 'x'
            ? int.parse(actualChar) * multiple
            : 10 * multiple;
        multiple--;
        result += sum;
      }

      if (result % 11 == 0) {
        return true;
      }
    }
    return false;
  }

  /// Validates the given value as an ISBN-13 code.
  ///
  /// - Checks if the value has exactly 13 characters.
  /// - Iterates through each character in the value, calculating the sum for the ISBN-13 check digit calculation,
  ///   alternating between 1 and 3 as the weight.
  /// - Returns true if the result is divisible by 10, indicating a valid ISBN-13 code.
  bool _validateIsbn13(String value) {
    if (value.length == 13) {
      int result = 0;
      bool isWeighted1 = true;

      for (var actualChar in value.characters) {
        int valueInt = int.parse(actualChar);
        int sum = isWeighted1 ? valueInt * 1 : valueInt * 3;
        isWeighted1 = !isWeighted1;
        result += sum;
      }

      if (result % 10 == 0) {
        return true;
      }
    }
    return false;
  }
}
