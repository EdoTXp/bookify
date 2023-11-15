import 'package:flutter/widgets.dart';

class IsbnVerifier {
// regexp finded on https://www.geeksforgeeks.org/regular-expressions-to-validate-isbn-code/
  static final _isbnRegExp = RegExp(
      r'^(?=(?:[^0-9]*[0-9]){9}(?:(?:[^0-9xX]*[0-9xX]){1})(?:(?:[^0-9]*[0-9]){3})?$)[\dXx-]+$');

  /// [RegExp] used to identify whether the source is a valid ISBN-10, with or without the 'X', or a valid ISBN-13.
  /// Using this format: r'^(?=(?:[^0-9]*[0-9]){9}(?:(?:[^0-9xX]*[0-9xX]){1})(?:(?:[^0-9]*[0-9]){3})?$)[\dXx-]+$'
  static RegExp get isbnFormatRegExp => _isbnRegExp;

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

  bool _validateIsbn10(String value) {
    if (value.length == 10) {
      int result = 0;
      int multipler = 10;

      for (var actualChar in value.characters) {
        int sum = actualChar != 'x'
            ? int.parse(actualChar) * multipler
            : 10 * multipler;
        multipler--;
        result += sum;
      }

      if (result % 11 == 0) {
        return true;
      }
    }
    return false;
  }

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
