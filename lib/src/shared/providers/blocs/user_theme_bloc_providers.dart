import 'package:bookify/src/shared/cubits/user_theme_cubit/user_theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final userThemeBlocProviders = [
  BlocProvider<UserThemeCubit>(
    create: (context) => UserThemeCubit(
      context.read(),
    ),
  ),
];
