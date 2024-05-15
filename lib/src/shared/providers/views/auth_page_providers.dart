import 'package:bookify/src/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final authPageProviders = [
  BlocProvider<AuthBloc>(
    create: (context) => AuthBloc(
      context.read(),
    ),
  ),
];
