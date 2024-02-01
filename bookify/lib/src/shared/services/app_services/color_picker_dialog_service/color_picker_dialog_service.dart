import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialogService {
  static Future<Color> showColorPickerDialog(
    BuildContext context,
    Color? selectedColor,
  ) async {
    Color pickerColor = selectedColor ?? Colors.white;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        Color? newSelectedColor;

        return AlertDialog(
          title: const Center(
            child: Text(
              'Escolhe uma cor',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          scrollable: true,
          content: SingleChildScrollView(
            child: ColorPicker(
              hexInputBar: true,
              pickerColor: pickerColor,
              labelTypes: const [ColorLabelType.rgb],
              paletteType: PaletteType.hueWheel,
              enableAlpha: false,
              onColorChanged: (color) => newSelectedColor = color,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            BookifyElevatedButton.expanded(
              onPressed: () {
                if (newSelectedColor != null) {
                  pickerColor = newSelectedColor!;
                }
                Navigator.of(context).pop(pickerColor);
              },
              text: 'Confirmar',
            ),
          ],
        );
      },
    );

    return pickerColor;
  }
}
