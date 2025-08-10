import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:localization/localization.dart';

class ColorPickerDialogService {
  static Future<Color> showColorPickerDialog(
    BuildContext context,
    Color? selectedColor,
  ) async {
    Color pickerColor = selectedColor ?? Colors.white;
    Color? newSelectedColor;

    await ColorPicker(
      color: pickerColor,
      heading: Text('select-color-title'.i18n()),
      showColorCode: true,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      onColorChanged: (color) => newSelectedColor = color,
    ).showPickerDialog(
      context,
    );

    if (newSelectedColor == null) {
      return pickerColor;
    } else {
      return newSelectedColor!;
    }
  }
}
