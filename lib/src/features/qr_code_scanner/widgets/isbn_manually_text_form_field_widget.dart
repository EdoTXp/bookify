import 'package:bookify/src/features/qr_code_scanner/widgets/isbn_text_form_field.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';

class IsbnManuallyTextFormFieldWidget extends StatefulWidget {
  final ValueChanged<String> onTap;

  const IsbnManuallyTextFormFieldWidget({
    super.key,
    required this.onTap,
  });

  @override
  State<IsbnManuallyTextFormFieldWidget> createState() =>
      _IsbnManuallyTextFormFieldWidgetState();
}

class _IsbnManuallyTextFormFieldWidgetState
    extends State<IsbnManuallyTextFormFieldWidget> {
  final isbnManuallyEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    isbnManuallyEC.dispose();
    super.dispose();
  }

  void _onPressedButton() {
    if (formKey.currentState!.validate()) {
      widget.onTap(isbnManuallyEC.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        IsbnTextFormField(
          isbnManuallyEC: isbnManuallyEC,
          formKey: formKey,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BookifyOutlinedButton.expanded(
            key: const Key('isbnManuallyOutlinedButton'),
            onPressed: _onPressedButton,
            text: 'Ir para o livro',
            suffixIcon: Icons.arrow_back,
          ),
        ),
      ],
    );
  }
}
