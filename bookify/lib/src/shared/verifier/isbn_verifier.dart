// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

class IsbnVerifier {
// regexp finded on https://www.geeksforgeeks.org/regular-expressions-to-validate-isbn-code/
  final _isbnRegExp = RegExp(
      r'^(?=(?:[^0-9]*[0-9]){9}(?:(?:[^0-9xX]*[0-9xX]){1})(?:(?:[^0-9]*[0-9]){3})?$)[\dXx-]+$');

  RegExp get isbnRegExp => _isbnRegExp;

  String? isbnTryParse(String value) {
    if (value.isNotEmpty && isbnRegExp.hasMatch(value)) {
      value = value.replaceAll('-', '');

      if (_isValidIsbn10(value) || _isValidIsbn13(value)) {
        return value.toLowerCase();
      }
    }
    return null;
  }

  bool _isValidIsbn10(String value) {
    if (value.length == 10) {
      int result = 0;
      int multipler = 10;
      for (int index = 0; index <= value.length - 1; index++) {
        String valueChar = value.characters.characterAt(index).first;
        int sum = valueChar.toLowerCase() != 'x'
            ? int.parse(valueChar) * multipler
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

  bool _isValidIsbn13(String value) {
    if (value.length == 13) {
      int result = 0;
      bool isweighted1 = true;
      for (int index = 0; index <= value.length - 1; index++) {
        int valueInt = int.parse(value.characters.characterAt(index).first);
        int sum = isweighted1 ? valueInt * 1 : valueInt * 3;
        isweighted1 = !isweighted1;
        result += sum;
      }
      if (result % 10 == 0) {
        return true;
      }
    }
    return false;
  }
}
