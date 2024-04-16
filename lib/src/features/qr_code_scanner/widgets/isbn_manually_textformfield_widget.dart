import 'package:bookify/src/shared/helpers/form/form_helper.dart';
import 'package:bookify/src/shared/utils/input_formatter/isbn_input_formatter.dart';
import 'package:bookify/src/shared/utils/verifier/isbn_verifier.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

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
  final isbnRegExpVerifier = IsbnVerifier.isbnFormatRegExp;
  final isbnMaskFormatter = IsbnMaskTextInputFormatter();

  @override
  void dispose() {
    isbnManuallyEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const Spacer(),
        Container(
          color: colorScheme.primary.withOpacity(.5),
          height: 120,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Center(
              child: TextFormField(
                key: const Key('isbnManuallyTextFormField'),
                textAlign: TextAlign.center,
                controller: isbnManuallyEC,
                keyboardType: TextInputType.number,
                inputFormatters: [isbnMaskFormatter],
                validator: Validatorless.multiple([
                  Validatorless.required('Esse campo não pode estar vazio'),
                  Validatorless.regex(
                    isbnRegExpVerifier,
                    'Formato do ISBN inválido',
                  ),
                ]),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                onTapOutside: (_) => context.unfocus(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
                  hintText: '000-00000-0000-0',
                  hintStyle: TextStyle(
                    color: colorScheme.tertiary,
                  ),
                  errorStyle: const TextStyle(fontSize: 12),
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BookifyOutlinedButton.expanded(
            key: const Key('isbnManuallyOutlinedButton'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                widget.onTap(isbnManuallyEC.text);
              }
            },
            text: 'Ir para o livro',
            suffixIcon: Icons.arrow_back,
          ),
        ),
      ],
    );
  }
}
