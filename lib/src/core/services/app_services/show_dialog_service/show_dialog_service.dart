import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowDialogService {
  static final bool _isAndroidPlatform = Platform.isAndroid;

  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    VoidCallback? cancelButtonFunction,
    required VoidCallback confirmButtonFunction,
  }) async {
    final Widget titleWidget = Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );

    final Widget contentWidget = Text(
      content,
      style: const TextStyle(fontSize: 14),
    );

    const Widget cancelButtonWidget = Text(
      'NÃO',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    const Widget confirmButtonWidget = Text(
      'CONFIRMAR',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    if (_isAndroidPlatform) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: titleWidget,
            content: contentWidget,
            actions: [
              TextButton(
                onPressed:
                    cancelButtonFunction ?? () => Navigator.of(context).pop(),
                child: cancelButtonWidget,
              ),
              TextButton(
                key: const Key('Confirm Dialog Button'),
                onPressed: confirmButtonFunction,
                child: confirmButtonWidget,
              ),
            ],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: titleWidget,
            content: contentWidget,
            actions: [
              CupertinoDialogAction(
                onPressed:
                    cancelButtonFunction ?? () => Navigator.of(context).pop(),
                child: cancelButtonWidget,
              ),
              CupertinoDialogAction(
                key: const Key('Confirm Dialog Button'),
                isDefaultAction: true,
                onPressed: confirmButtonFunction,
                child: confirmButtonWidget,
              ),
            ],
          );
        },
      );
    }
  }

  static Future<void> showSimpleDialog({
    required BuildContext context,
    required String title,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;

    final Widget titleWidget = Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
    );

    final Widget okButtonWidget = Text(
      'OK',
      style: TextStyle(
        fontSize: 16,
        color: colorScheme.primary,
      ),
    );

    if (_isAndroidPlatform) {
      await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: titleWidget,
            children: [
              SimpleDialogOption(
                key: const Key('Ok Dialog Button'),
                onPressed: () => Navigator.pop(context),
                child: okButtonWidget,
              ),
            ],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: titleWidget,
            actions: [
              CupertinoDialogAction(
                key: const Key('Ok Dialog Button'),
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
                child: okButtonWidget,
              ),
            ],
          );
        },
      );
    }
  }
}
