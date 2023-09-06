import 'package:bookify/src/shared/helpers/form_helper.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validatorless/validatorless.dart';

class QrCodeScannerPage extends StatefulWidget {
  const QrCodeScannerPage({super.key});

  @override
  State<QrCodeScannerPage> createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  late final MobileScannerController scannerController;
  late final MaskTextInputFormatter isbnMaskFormatter;
  final isbnManualyEC = TextEditingController();

  bool isTextInputVisible = false;

  @override
  void initState() {
    super.initState();
    scannerController = MobileScannerController(
      formats: [
        BarcodeFormat.codebar,
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
      ],
      detectionTimeoutMs: 2000,
    );

    isbnMaskFormatter = MaskTextInputFormatter(
      mask: '###-##-####-###-#',
      filter: {"#": RegExp(r'[0-9]')},
    );

    // Lock the screen only portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    scannerController.dispose();
    isbnManualyEC.dispose();

    // Unlock the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  void _searchIsbn(BuildContext context, String value) {
    value = value.replaceAll('-', '');
    if (value.isNotEmpty && value.length == 13) {
      int isbn = int.parse(value);
      Navigator.pop(context, isbn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthOverlay = MediaQuery.sizeOf(context).width * .9;
    final heigthOverlay = MediaQuery.sizeOf(context).height * .3;

    String titleText;
    String changeModeText;
    IconData changeIconMode;

    // start mobileScanner
    if (!isTextInputVisible) {
      scannerController.start();
      titleText = 'Aponte a câmera para o código de barras do livro';
      changeModeText = 'Digitar o código manualmente';
      changeIconMode = Icons.keyboard;
    }
    // start manualyText
    else {
      scannerController.stop();
      titleText = 'Digite os números do código de barra';
      changeModeText = 'Scanear código';
      changeIconMode = Icons.qr_code;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 2,
            child: Text(
              titleText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Visibility(
            visible: !isTextInputVisible,
            child: Expanded(
              child: MobileScanner(
                controller: scannerController,
                errorBuilder: (context, exception, __) {
                  return Text(exception.errorDetails!.message!);
                },
                /* scanWindow: Rect.fromCenter(
                  center: Offset.zero,
                  width: widthOverlay,
                  height: heigthOverlay,
                ),*/
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;

                  for (final barcode in barcodes) {
                    debugPrint('Tipo: ${barcode.format.name}');

                    if (barcode.rawValue != null) {
                      _searchIsbn(context, barcode.rawValue!);
                    }
                  }
                },
                overlay: Container(
                  width: widthOverlay,
                  height: heigthOverlay,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 64,
            width: double.infinity,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextButton.icon(
                label: Text(changeModeText),
                icon: Icon(changeIconMode),
                onPressed: () =>
                    setState(() => isTextInputVisible = !isTextInputVisible),
              ),
            ),
          ),
          Visibility(
            visible: isTextInputVisible,
            child: Expanded(
              child: Column(
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
                              Validatorless.required(
                                  'Esse campo precisa ser preenchido'),
                              Validatorless.min(17,
                                  'Esse campo precisa ter pelo menos 13 números')
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
                      onPressed: () => _searchIsbn(context, isbnManualyEC.text),
                      text: 'Ir para o livro',
                      suffixIcon: Icons.arrow_forward,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
