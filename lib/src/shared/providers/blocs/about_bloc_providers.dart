import 'package:bookify/src/features/about/bloc/about_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final aboutBlocProviders = [
  BlocProvider<AboutBloc>(
    create: (context) => AboutBloc(
      context.read(),
    ),
  ),
];
