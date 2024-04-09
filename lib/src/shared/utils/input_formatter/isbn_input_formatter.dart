import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class IsbnMaskTextInputFormatter extends MaskTextInputFormatter {
  static const String _maskIsbn10 = '#-#####-###-S';
  static const String _maskIsbn13 = '###-#####-####-#';

  IsbnMaskTextInputFormatter()
      : super(
          mask: _maskIsbn10,
          filter: {
            '#': RegExp(r'[0-9]'),
            'S': RegExp(r'[xX0-9]'),
          },
        );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final clearTextValue = TextEditingValue(
      text: newValue.text.replaceAll('-', ''),
    );

    if (clearTextValue.text.length <= 10) {
      if (getMask() != _maskIsbn10) {
        return updateMask(mask: _maskIsbn10, newValue: clearTextValue);
      }
    } else {
      if (getMask() != _maskIsbn13) {
        return updateMask(mask: _maskIsbn13, newValue: clearTextValue);
      }
    }
    return super.formatEditUpdate(oldValue, newValue);
  }
}
