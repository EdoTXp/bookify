import 'package:bookify/src/shared/blocs/user_theme_bloc/user_theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final userThemeProviders = [
  BlocProvider<UserThemeBloc>(
    create: (context) => UserThemeBloc(
      context.read(),
    ),
  ),
];
