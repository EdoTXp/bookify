import 'package:bookify/src/features/hour_time_calculator/bloc/hour_time_calculator_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final hourTimeCalculatorBlocProviders = [
  BlocProvider<HourTimeCalculatorBloc>(
    create: (context) => HourTimeCalculatorBloc(
      context.read(),
      context.read(),
    ),
  ),
];
