import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bookify/src/shared/theme/colors.dart';
import 'package:flutter/material.dart';

enum SnackBarType {
  info,
  warning,
  error,
  success;

  ContentType _toContentType() {
    return switch (this) {
      SnackBarType.info => ContentType.help,
      SnackBarType.warning => ContentType.warning,
      SnackBarType.error => ContentType.failure,
      SnackBarType.success => ContentType.success,
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

  @override
  String toString() {
    return switch (this) {
      SnackBarType.info => 'Informação',
      SnackBarType.warning => 'Atenção',
      SnackBarType.error => 'Erro',
      SnackBarType.success => 'Sucesso',
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
      content: AwesomeSnackbarContent(
        title: snackBarType.toString(),
        message: message,
        contentType: snackBarType._toContentType(),
        color: snackBarType._toColor(),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
