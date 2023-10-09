import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class IsbnMaskTextInputFormatter extends MaskTextInputFormatter {
  static const String _maskIsbn10 = '#-#####-###-S';
  static const String _maskIsbn13 = '###-#####-####-#';
  bool _maskIsChanged = false;

  IsbnMaskTextInputFormatter()
      : super(
          mask: _maskIsbn10,
          filter: {'#': RegExp(r'[0-9]'), 'S': RegExp(r'[xX0-9]')},
        );

  bool get maskIsChanged => _maskIsChanged;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    newValue = TextEditingValue(text: newValue.text.replaceAll('-', ''));

    if (newValue.text.length <= 10) {
      if (getMask() != _maskIsbn10) {
        updateMask(mask: _maskIsbn10, newValue: newValue);
        _maskIsChanged = true;
      } else {
        _maskIsChanged = false;
      }
    } else {
      if (getMask() != _maskIsbn13) {
        updateMask(mask: _maskIsbn13, newValue: newValue);
        _maskIsChanged = true;
      } else {
        _maskIsChanged = false;
      }
    }

    return super.formatEditUpdate(oldValue, newValue);
  }
}
