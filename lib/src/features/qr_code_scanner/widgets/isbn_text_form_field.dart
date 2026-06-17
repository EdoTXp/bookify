import 'package:bookify/src/core/extensions/textfield_unfocus/textfield_unfocus_extension.dart';
import 'package:bookify/src/core/helper/input_formatter/isbn_input_formatter_helper.dart';
import 'package:bookify/src/core/helper/verifier/isbn_verifier_helper.dart';
import 'package:localization/localization.dart';
import 'package:validatorless/validatorless.dart';
import 'package:flutter/material.dart';

class IsbnTextFormField extends StatelessWidget {
  final TextEditingController isbnManuallyEC;
  final GlobalKey<FormState> formKey;

  const IsbnTextFormField({
    super.key,
    required this.isbnManuallyEC,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final isbnRegExpVerifier = IsbnVerifierHelper.isbnFormatRegExp;
    final isbnMaskFormatter = IsbnMaskTextInputFormatterHelper();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.primary.withValues(
        alpha: .5,
      ),
      height: 120,
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Center(
          child: TextFormField(
            key: const Key('isbnManuallyTextFormField'),
            textAlign: TextAlign.center,
            controller: isbnManuallyEC,
            inputFormatters: [isbnMaskFormatter],
            validator: Validatorless.multiple([
              Validatorless.required('field-cannot-be-empty-error'.i18n()),
              Validatorless.regex(
                isbnRegExpVerifier,
                'invalid-ISBN-format-error'.i18n(),
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
    );
  }
}
