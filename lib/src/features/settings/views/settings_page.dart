import 'package:bookify/src/features/settings/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  /// The Route Name = '/settings'
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Configurações',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              ThemeSettings(),
              SizedBox(
                height: 20,
              ),
              TimeReadingSettings(),
              SizedBox(
                height: 20,
              ),
              HourReadingSettings(),
            ],
          ),
        ),
      ),
    );
  }
}
