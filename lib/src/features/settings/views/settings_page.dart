import 'package:bookify/src/core/extensions/color_brightness/color_brightness_extension.dart';
import 'package:bookify/src/features/settings/views/widgets/delete_account_settings/widgets/delete_account_settings.dart';
import 'package:bookify/src/features/settings/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class SettingsPage extends StatelessWidget {
  /// The Route Name = '/settings'
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'settings-label'.i18n(),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const ThemeSettings(
                key: Key('ThemeSettings'),
              ),
              const SizedBox(
                height: 20,
              ),
              const TimeReadingSettings(
                key: Key('TimeReadingSettings'),
              ),
              const SizedBox(
                height: 20,
              ),
              const HourReadingSettings(
                key: Key('HourReadingSettings'),
              ),
              const SizedBox(
                height: 40,
              ),
              Divider(
                color: colorScheme.primary.lighten(),
              ),
              const DeleteAccountSettings(
                key: Key('DeleteAccountSettings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
