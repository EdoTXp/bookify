import 'package:bookify/src/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final authBlocProviders = [
  BlocProvider<AuthBloc>(
    create: (context) => AuthBloc(
      context.read(),
    ),
  ),
];
