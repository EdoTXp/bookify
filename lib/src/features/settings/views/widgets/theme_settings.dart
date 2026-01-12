import 'package:bookify/src/features/settings/views/widgets/settings_container.dart';
import 'package:bookify/src/shared/cubits/user_theme_cubit/user_theme_cubit.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  late final UserThemeCubit _userThemeCubit;

  @override
  void initState() {
    super.initState();
    _userThemeCubit = context.read<UserThemeCubit>();
  }

  Widget _getWidgetOnThemeSetting(BuildContext context, UserThemeState state) {
    return switch (state) {
      UserThemeLoadingState() => const CenterCircularProgressIndicator(),
      UserThemeLoadedState(:final themeMode) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: _onChangedRadioButton,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'light-theme-label'.i18n(),
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Radio<ThemeMode>.adaptive(
                  value: ThemeMode.light,
                ),
                Text(
                  'dark-theme-label'.i18n(),
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Radio<ThemeMode>.adaptive(
                  value: ThemeMode.dark,
                ),
                Text(
                  'system-theme-label'.i18n(),
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Radio<ThemeMode>.adaptive(
                  value: ThemeMode.system,
                ),
              ],
            ),
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
    if (value == null) return;
    _userThemeCubit.setTheme(themeMode: value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsContainer(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'theme-label'.i18n(),
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<UserThemeCubit, UserThemeState>(
            bloc: _userThemeCubit,
            builder: _getWidgetOnThemeSetting,
          ),
        ],
      ),
    );
  }
}
