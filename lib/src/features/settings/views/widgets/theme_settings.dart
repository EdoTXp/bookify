import 'package:bookify/src/features/settings/views/widgets/settings_container.dart';
import 'package:bookify/src/shared/blocs/user_theme_bloc/user_theme_bloc.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  late final UserThemeBloc _userThemeBloc;

  @override
  void initState() {
    super.initState();
    _userThemeBloc = context.read<UserThemeBloc>();
  }

  Widget _getWidgetOnThemeSetting(BuildContext context, UserThemeState state) {
    return switch (state) {
      UserThemeLoadingState() => const CenterCircularProgressIndicator(),
      UserThemeLoadedState(:final themeMode) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tema Claro',
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Radio<ThemeMode>.adaptive(
                value: ThemeMode.light,
                groupValue: themeMode,
                onChanged: _onChangedRadioButton,
              ),
              Text(
                'Tema Escuro',
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Radio<ThemeMode>.adaptive(
                value: ThemeMode.dark,
                groupValue: themeMode,
                onChanged: _onChangedRadioButton,
              ),
              Text(
                'Tema Sistema',
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Radio<ThemeMode>.adaptive(
                value: ThemeMode.system,
                groupValue: themeMode,
                onChanged: _onChangedRadioButton,
              ),
            ],
          ),
        ),
      UserThemeErrorState(:final errorMessage) => Text(
          errorMessage,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
    };
  }

  void _onChangedRadioButton(ThemeMode? value) {
    _userThemeBloc.add(
      InsertedUserThemeEvent(
        themeMode: value!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tema',
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
          BlocBuilder<UserThemeBloc, UserThemeState>(
            bloc: _userThemeBloc,
            builder: _getWidgetOnThemeSetting,
          ),
        ],
      ),
    );
  }
}
