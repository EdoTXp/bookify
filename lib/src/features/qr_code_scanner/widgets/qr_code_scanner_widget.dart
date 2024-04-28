import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
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

    _scannerController.barcodes.listen(_onDetectCaptures);
    _scannerController.start();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetectCaptures(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        widget.onDetect(barcode.rawValue!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final layoutSize = constraints.biggest;
            final widthOverlay = layoutSize.width * 0.9;
            final heightOverlay = layoutSize.height * 0.3;
            final centerOverlay = layoutSize.center(Offset.zero);

            return MobileScanner(
              key: const Key('MobileScanner'),
              controller: _scannerController,
              errorBuilder: (context, _, __) {
                return Center(
                  child: InfoItemStateWidget.withErrorState(
                    message: 'Occoreu algum erro com a câmera',
                    onPressed: () async {
                      await Future.wait(
                        [
                          _scannerController.stop(),
                          _scannerController.start(),
                        ],
                      );
                    },
                  ),
                );
              },
              placeholderBuilder: (_, __) =>
                  const CenterCircularProgressIndicator(),
              scanWindow: Rect.fromCenter(
                center: centerOverlay,
                width: widthOverlay,
                height: heightOverlay,
              ),
              overlayBuilder: (context, _) {
                return Container(
                  width: widthOverlay,
                  height: heightOverlay,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            );
          },
        ),
        ListenableBuilder(
          listenable: _scannerController,
          builder: (_, __) {
            final scannerValue = _scannerController.value;

            if (scannerValue.isRunning) {
              return Positioned(
                right: 10,
                child: IconButton(
                  color: colorScheme.secondary,
                  onPressed: _scannerController.toggleTorch,
                  icon: Icon(
                    scannerValue.torchState.rawValue == 0
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    color: colorScheme.secondary,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
