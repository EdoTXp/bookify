import 'package:bookify/src/features/profile/bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final profilePageProviders = [
  BlocProvider<ProfileBloc>(
    create: (context) => ProfileBloc(
      context.read(),
      context.read(),
    ),
  ),
];
