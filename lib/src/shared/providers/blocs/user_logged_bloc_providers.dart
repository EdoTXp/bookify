import 'package:bookify/src/shared/blocs/user_logged_bloc/user_logged_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final userLoggedBlocProviders = [
  BlocProvider<UserLoggedBloc>(
    create: (context) => UserLoggedBloc(
      context.read(),
    ),
  ),
];
