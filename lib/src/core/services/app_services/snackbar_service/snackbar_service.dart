import 'package:bookify/src/shared/theme/colors.dart';
import 'package:flutter/material.dart';

enum SnackBarType {
  info,
  warning,
  error,
  success;

  IconData _getIcon() {
    return switch (this) {
      SnackBarType.info => Icons.info_outline_rounded,
      SnackBarType.warning => Icons.warning_amber_rounded,
      SnackBarType.error => Icons.error_outline_rounded,
      SnackBarType.success => Icons.check_circle_outline_rounded,
    };
  }

  Color _toColor() {
    return switch (this) {
      SnackBarType.info => AppColor.bookifyPrimaryColor,
      SnackBarType.warning => AppColor.bookifyWarningColor,
      SnackBarType.error => AppColor.bookifyErrorColor,
      SnackBarType.success => AppColor.bookifySuccessColor,
    };
  }
}

class SnackbarService {
  static void showSnackBar(
    BuildContext context,
    String message,
    SnackBarType snackBarType, [
    Duration duration = const Duration(seconds: 2),
  ]) {
    final snackBar = SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      duration: duration,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.transparent,
          ),
          color: snackBarType._toColor(),
        ),
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              snackBarType._getIcon(),
              color: Colors.white,
              size: 32,
            ),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
