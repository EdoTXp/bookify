import 'package:bookify/src/shared/helpers/form_helper.dart';
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
  final formKey = GlobalKey<FormState>();

  bool isTextInputVisible = false;

  @override
  void initState() {
    super.initState();
    scannerController = MobileScannerController();

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

  @override
  Widget build(BuildContext context) {
    final widthOverlay = MediaQuery.sizeOf(context).width * .9;
    final heigthOverlay = MediaQuery.sizeOf(context).height * .3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 2,
            child: const Text(
              'Aponte a câmera para o código de barras do livro',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: MobileScanner(
              controller: scannerController,
              errorBuilder: (context, exception, __) {
                return Text(exception.errorDetails!.message!);
              },
              scanWindow: Rect.fromCenter(
                center: Offset.zero,
                width: widthOverlay,
                height: heigthOverlay,
              ),
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;

                for (final barcode in barcodes) {
                  debugPrint('Barcode found! ${barcode.rawValue}');
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
          SizedBox(
            height: 64,
            width: double.infinity,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextButton.icon(
                label: const Text('Digitar o código manualmente'),
                icon: const Icon(Icons.keyboard),
                onPressed: () {
                  setState(() {
                    isTextInputVisible = !isTextInputVisible;
                    isTextInputVisible
                        ? scannerController.stop()
                        : scannerController.start();
                  });
                },
              ),
            ),
          ),
          Visibility(
            visible: isTextInputVisible,
            child: SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: TextFormField(
                    controller: isbnManualyEC,
                    inputFormatters: [isbnMaskFormatter],
                    validator: Validatorless.multiple([
                      Validatorless.required(
                          'Esse campo precisa ser preenchido'),
                      Validatorless.min(
                          17, 'Esse campo precisa ter pelo menos 13 números')
                    ]),
                    onFieldSubmitted: (value) {
                      value = value.replaceAll('-', '');
                      if (value.isNotEmpty && value.length == 13) {
                        int isbn = int.parse(value);
                        Navigator.pop(context, isbn);
                      }
                    },
                    onTapOutside: (_) => context.unfocus(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text(
                        'Digite os números do código de barra',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
