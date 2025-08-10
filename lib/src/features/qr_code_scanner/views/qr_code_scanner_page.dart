import 'package:bookify/src/core/helpers/size/size_for_small_device_extension.dart';
import 'package:bookify/src/features/qr_code_scanner/widgets/isbn_manually_text_form_field_widget.dart';
import 'package:bookify/src/features/qr_code_scanner/widgets/qr_code_scanner_widget.dart';
import 'package:bookify/src/shared/constants/icons/bookify_icons.dart';
import 'package:bookify/src/core/services/app_services/lock_screen_orientation_service/lock_screen_orientation_service.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class QrCodeScannerPage extends StatefulWidget {
  /// The Route Name = '/qr_code_scanner'
  static const routeName = '/qr_code_scanner';

  const QrCodeScannerPage({super.key});

  @override
  State<QrCodeScannerPage> createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  bool _qrCodeScannerIsVisible = true;

  @override
  void initState() {
    super.initState();
    LockScreenOrientationService.lockOrientationScreen(
      orientation: Orientation.portrait,
    );
  }

  @override
  void dispose() {
    LockScreenOrientationService.unLockOrientationScreen();
    super.dispose();
  }

  void _searchIsbn(BuildContext context, String isbn) {
    Navigator.pop(context, isbn);
  }

  @override
  Widget build(BuildContext context) {
    String titleText;
    String changeModeText;
    IconData changeModeIcon;

    // start QrCodeScannerWidget
    if (_qrCodeScannerIsVisible) {
      titleText = 'point-the-camera-label'.i18n();
      changeModeText = 'enter-code-manually-label'.i18n();
      changeModeIcon = Icons.keyboard;
    }
    // start IsbnManuallyTextFormFieldWidget
    else {
      titleText = 'enter-barcode-label'.i18n();
      changeModeText = 'scan-code-label'.i18n();
      changeModeIcon = BookifyIcons.qr_code;
    }

    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallDevice = constraints.biggest.isSmallDevice();

          return SingleChildScrollView(
            child: SizedBox(
              height: isSmallDevice
                  ? MediaQuery.sizeOf(context).height * .8
                  : constraints.biggest.height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      titleText,
                      textScaler: TextScaler.noScaling,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: (_qrCodeScannerIsVisible)
                        ? QrCodeScannerWidget(
                            key: const Key('qrCodeScannerWidget'),
                            onDetect: (qrCodeValue) => _searchIsbn(
                              context,
                              qrCodeValue,
                            ),
                          )
                        : IsbnManuallyTextFormFieldWidget(
                            key: const Key('isbnManuallyTextFormFieldWidget'),
                            onTap: (textFormFieldValue) => _searchIsbn(
                              context,
                              textFormFieldValue,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 64,
                    width: double.infinity,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        key: const Key('changeModeTextButton'),
                        label: Text(
                          changeModeText,
                          textScaler: TextScaler.noScaling,
                        ),
                        icon: Icon(changeModeIcon),
                        onPressed: () => setState(() {
                          _qrCodeScannerIsVisible = !_qrCodeScannerIsVisible;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
