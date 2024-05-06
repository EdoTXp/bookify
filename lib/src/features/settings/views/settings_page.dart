import 'package:bookify/src/features/settings/views/widgets/theme_settings.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  /// The Route Name = '/settings'
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configurações',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              ThemeSettings(),
            ],
          ),
        ),
      ),
    );
  }
}
