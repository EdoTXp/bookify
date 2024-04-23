import 'package:bookify/src/features/readings/bloc/readings_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final readingsPageProviders = [
  BlocProvider<ReadingsBloc>(
    create: (context) => ReadingsBloc(
      context.read(),
      context.read(),
    ),
  ),
];
