import 'package:bookify/src/features/readings_timer/bloc/readings_timer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final readingsTimerBlocProviders = [
  BlocProvider<ReadingsTimerBloc>(
    create: (context) => ReadingsTimerBloc(
      context.read(),
    ),
  ),
];
