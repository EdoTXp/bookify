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
  State<IsbnManuallyTextFormFieldWidget> createState() =>
      _IsbnManuallyTextFormFieldWidgetState();
}

class _IsbnManuallyTextFormFieldWidgetState
    extends State<IsbnManuallyTextFormFieldWidget> {
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
      children: [
        const SizedBox(
          height: 80,
        ),
        Container(
          color: Theme.of(context).primaryColorLight,
          height: 120,
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Center(
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: isbnManualyEC,
                inputFormatters: [isbnMaskFormatter],
                validator: Validatorless.multiple([
                  Validatorless.required('Esse campo precisa ser preenchido'),
                  Validatorless.min(
                    17,
                    'Esse campo precisa ter pelo menos 13 números',
                  ),
                ]),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                onTapOutside: (_) => context.unfocus(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 70.0),
                    hintText: '000-00-0000-000-0',
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
        const Spacer(),
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
