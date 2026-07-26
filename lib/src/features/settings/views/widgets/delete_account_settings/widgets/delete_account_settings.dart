import 'dart:io';

import 'package:bookify/src/core/extensions/color_brightness/color_brightness_extension.dart';
import 'package:bookify/src/core/extensions/show_dialog/show_dialog_extension.dart';
import 'package:bookify/src/core/extensions/show_snackbar/show_snackbar_extension.dart';
import 'package:bookify/src/features/settings/views/widgets/delete_account_settings/bloc/delete_account_bloc.dart';
import 'package:bookify/src/features/settings/views/widgets/settings_container.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class DeleteAccountSettings extends StatefulWidget {
  const DeleteAccountSettings({super.key});

  @override
  State<DeleteAccountSettings> createState() => _DeleteAccountSettingsState();
}

class _DeleteAccountSettingsState extends State<DeleteAccountSettings> {
  late final DeleteAccountBloc _deleteAccountBloc;

  @override
  void initState() {
    super.initState();
    _deleteAccountBloc = context.read<DeleteAccountBloc>();
  }

  void _onDeleteAccountListener(
    BuildContext context,
    DeleteAccountState state,
  ) {
    if (state is DeleteAccountLoadedState) {
      _closeApp();
    } else if (state is DeleteAccountErrorState) {
      context.showSnackBar(
        'error-deleting-account'.i18n(),
        SnackBarType.error,
      );
    }
  }

  void _closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsContainer(
      lightColor: colorScheme.secondary.lighten(0.18),
      darkColor: colorScheme.secondary.darken(0.6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'delete-account-title'.i18n(),
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'delete-account-desc'.i18n(),
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
            listener: _onDeleteAccountListener,
            builder: (context, state) {
              if (state is DeleteAccountLoadingState) {
                return const CenterCircularProgressIndicator();
              }

              return TextButton(
                key: const Key('DeleteAccountTextButton'),
                onPressed: () async {
                  await context.showAlertDialog(
                    title: 'delete-title'.i18n(),
                    content: 'delete-description'.i18n(),
                    confirmButtonFunction: () {
                      _deleteAccountBloc.add(DeletedAccountEvent());
                      Navigator.of(context).pop();
                    },
                  );
                },
                child: Text(
                  'delete-button'.i18n(),
                  style: TextStyle(
                    color: colorScheme.tertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
