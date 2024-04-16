import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/// Custom formatter for ISBN input fields.
///
/// This formatter dynamically switches between ISBN-10 and ISBN-13 masks based on the input length.
/// It ensures that the input matches the expected format for ISBN codes, including the use of hyphens and the special character 'X' in ISBN-10 codes.
class IsbnMaskTextInputFormatter extends MaskTextInputFormatter {
  // Mask for ISBN-10 format, allowing for a single digit, followed by hyphens and digits, and ending with 'X' or a digit.
  static const String _maskIsbn10 = '#-#####-###-S';
  // Mask for ISBN-13 format, allowing for three digits, followed by hyphens and digits.
  static const String _maskIsbn13 = '###-#####-####-#';

  /// Constructor for the ISBN mask formatter.
  ///
  /// Initializes the formatter with the ISBN-10 mask and a filter for digits and 'X'.
  IsbnMaskTextInputFormatter()
      : super(
          mask: _maskIsbn10,
          filter: {
            '#': RegExp(r'[0-9]'), // Matches any digit.
            'S': RegExp(r'[xX0-9]'), // Matches 'X', 'x', or any digit.
          },
        );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Removes hyphens from the input value to determine the correct mask.
    final clearTextValue = TextEditingValue(
      text: newValue.text.replaceAll('-', ''),
    );

    // Checks if the input length is 10 or less, indicating an ISBN-10 code.
    if (clearTextValue.text.length <= 10) {
      // If the current mask is not ISBN-10, updates it.
      if (getMask() != _maskIsbn10) {
        return updateMask(mask: _maskIsbn10, newValue: clearTextValue);
      }
    } else {
      // If the current mask is not ISBN-13, updates it.
      if (getMask() != _maskIsbn13) {
        return updateMask(mask: _maskIsbn13, newValue: clearTextValue);
      }
    }
    // If the input does not require a mask change, proceeds with the default formatting.
    return super.formatEditUpdate(oldValue, newValue);
  }
}
