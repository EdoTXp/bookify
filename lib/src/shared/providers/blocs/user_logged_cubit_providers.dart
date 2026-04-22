import 'package:bookify/src/shared/cubits/user_logged_cubit/user_logged_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final userLoggedCubitProviders = [
  BlocProvider<UserLoggedCubit>(
    create: (context) => UserLoggedCubit(
      context.read(),
    ),
  ),
];
