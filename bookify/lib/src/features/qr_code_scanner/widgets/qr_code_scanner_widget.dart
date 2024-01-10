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
  late final MobileScannerController scannerController;

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
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthOverlay = MediaQuery.sizeOf(context).width * 0.9;
    final heightOverlay = MediaQuery.sizeOf(context).height * 0.3;
    final centerOverlay = Offset(widthOverlay * .78, heightOverlay * .78);

    return MobileScanner(
      key: const Key('MobileScanner'),
      fit: BoxFit.contain,
      controller: scannerController,
      errorBuilder: (context, exception, _) {
        return Text(exception.errorDetails!.message!);
      },
      scanWindow: Rect.fromCenter(
        center: centerOverlay,
        width: widthOverlay,
        height: heightOverlay,
      ),
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;

        for (final barcode in barcodes) {
          if (barcode.rawValue != null) {
            widget.onDetect(barcode.rawValue!);
          }
        }
      },
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
