import 'package:bookify/src/shared/helpers/form_helper.dart';
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
  State<IsbnManuallyTextFormFieldWidget> createState() => _IsbnManuallyTextFormFieldWidgetState();
}

class _IsbnManuallyTextFormFieldWidgetState extends State<IsbnManuallyTextFormFieldWidget> {
  late final MaskTextInputFormatter isbnMaskFormatter;
  final isbnManualyEC = TextEditingController();

  @override
  void initState() {
    super.initState();

    isbnMaskFormatter = MaskTextInputFormatter(
      mask: '###-##-####-###-#',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  @override
  void dispose() {
    isbnManualyEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            color: Theme.of(context).primaryColorLight,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: TextFormField(
                  controller: isbnManualyEC,
                  inputFormatters: [isbnMaskFormatter],
                  validator: Validatorless.multiple([
                    Validatorless.required('Esse campo precisa ser preenchido'),
                    Validatorless.min(
                        17, 'Esse campo precisa ter pelo menos 13 números')
                  ]),
                  onTapOutside: (_) => context.unfocus(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text(
                      textAlign: TextAlign.center,
                      'Código',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BookifyOutlinedButton(
            onPressed: () => widget.onTap(isbnManualyEC.text),
            text: 'Ir para o livro',
            suffixIcon: Icons.arrow_forward,
          ),
        ),
      ],
    );
  }
}
