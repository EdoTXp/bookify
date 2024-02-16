import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScannerWidget extends StatefulWidget {
  final ValueChanged<String> onDetect;

  const QrCodeScannerWidget({
    super.key,
    required this.onDetect,
  });

  @override
  State<QrCodeScannerWidget> createState() => _QrCodeScannerWidgetState();
}

class _QrCodeScannerWidgetState extends State<QrCodeScannerWidget> {
  late final MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();

    _scannerController = MobileScannerController(
      formats: [
        BarcodeFormat.codebar,
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
      ],
      detectionTimeoutMs: 2000,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetectCaptures(capture) {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        widget.onDetect(barcode.rawValue!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthOverlay = MediaQuery.sizeOf(context).width * 0.9;
    final heightOverlay = MediaQuery.sizeOf(context).height * 0.3;
    final centerOverlay = Offset(widthOverlay * .78, heightOverlay * .78);

    return MobileScanner(
      key: const Key('MobileScanner'),
      controller: _scannerController,
      errorBuilder: (context, _, __) {
        return InfoItemStateWidget.withErrorState(
          message: 'Occoreu algum erro com a câmera',
          onPressed: () async {
            await Future.wait(
              [
                _scannerController.stop(),
                _scannerController.start(),
              ],
            );
          },
        );
      },
      scanWindow: Rect.fromCenter(
        center: centerOverlay,
        width: widthOverlay,
        height: heightOverlay,
      ),
      onDetect: _onDetectCaptures,
      overlay: Container(
        width: widthOverlay,
        height: heightOverlay,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
