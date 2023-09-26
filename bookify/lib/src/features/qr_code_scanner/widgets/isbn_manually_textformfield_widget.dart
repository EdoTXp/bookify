import 'package:bookify/src/shared/helpers/form_helper.dart';
import 'package:bookify/src/shared/verifier/isbn_verifier.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
  final isbnManualyEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final maskIsbn10 = '#-#####-###-S#';
  final maskIsbn13 = '###-#####-####-#';
  final isbnRegExpVerifier = IsbnVerifier().isbnFormatRegExp;
  late final MaskTextInputFormatter isbnMaskFormatter;

  @override
  void initState() {
    super.initState();

    isbnMaskFormatter = MaskTextInputFormatter(
      filter: {'#': RegExp(r'[0-9]'), 'S': RegExp(r'[xX0-9]')},
    );
  }

  @override
  void dispose() {
    isbnManualyEC.dispose();
    super.dispose();
  }

  void _updateMask(String value) {
    setState(() {
      final valueClear = value.replaceAll('-', '');

      isbnManualyEC.value = valueClear.length < 11
          ? isbnMaskFormatter.updateMask(mask: maskIsbn10)
          : isbnMaskFormatter.updateMask(mask: maskIsbn13);
        
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 80,
        ),
        Container(
          color: Theme.of(context).primaryColorLight,
          height: 120,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Center(
              child: TextFormField(
                key: const Key('isbnManuallyTextFormField'),
                textAlign: TextAlign.center,
                controller: isbnManualyEC,
                onChanged: _updateMask,
                inputFormatters: [isbnMaskFormatter],
                validator: Validatorless.multiple([
                  Validatorless.required('Esse campo não pode estar vazio'),
                  Validatorless.regex(
                    isbnRegExpVerifier,
                    'Formato do ISBN inválido',
                  ),
                ]),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                onTapOutside: (_) => context.unfocus(),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 70.0),
                    hintText: '000-00000-0000-0',
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BookifyOutlinedButton(
            key: const Key('isbnManuallyOutlinedButton'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                widget.onTap(isbnManualyEC.text);
              }
            },
            text: 'Ir para o livro',
            suffixIcon: Icons.arrow_forward,
          ),
        ),
      ],
    );
  }
}
