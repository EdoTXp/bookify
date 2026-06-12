import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

abstract class ShowDialogService {
  ShowDialogService._();

  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    VoidCallback? cancelButtonFunction,
    required VoidCallback confirmButtonFunction,
  }) async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(title),
          content: Text(content),
          actions: [
            _AdaptiveTextButton(
              onPressed:
                  cancelButtonFunction ?? () => Navigator.of(context).pop(),
              text: 'no-button'.i18n(),
            ),
            _AdaptiveTextButton(
              key: const Key('ConfirmDialogButton'),
              onPressed: confirmButtonFunction,
              isIOSDefaultAction: true,
              text: 'confirm-button'.i18n(),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showSimpleDialog({
    required BuildContext context,
    required String title,
  }) async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(title),
        actions: [
          _AdaptiveTextButton(
            key: const Key('OkDialogButton'),
            isIOSDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            text: 'ok-button'.i18n(),
          ),
        ],
      ),
    );
  }
}

class _AdaptiveTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isIOSDefaultAction;

  const _AdaptiveTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isIOSDefaultAction = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final child = Text(
      text,
      style: TextStyle(
        color: theme.colorScheme.tertiary,
        fontSize: 14,
      ),
    );

    if (theme.platform == TargetPlatform.iOS) {
      return CupertinoDialogAction(
        onPressed: onPressed,
        isDefaultAction: isIOSDefaultAction,
        child: child,
      );
    }
    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
