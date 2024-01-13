import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

enum SnackBarType {
  info,
  warning,
  error,
  success;

  String typeToString() {
    return switch (this) {
      SnackBarType.info => 'Informação',
      SnackBarType.warning => 'Atenção',
      SnackBarType.error => 'Erro',
      SnackBarType.success => 'Sucesso',
    };
  }

  ContentType _toContentType() {
    return switch (this) {
      SnackBarType.info => ContentType.help,
      SnackBarType.warning => ContentType.warning,
      SnackBarType.error => ContentType.failure,
      SnackBarType.success => ContentType.success,
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
        title: snackBarType.typeToString(),
        message: message,
        contentType: snackBarType._toContentType(),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
