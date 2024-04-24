import 'package:bookify/src/features/readings_insertion/bloc/readings_insertion_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final readingsInsertionPageProviders = [
  BlocProvider<ReadingsInsertionBloc>(
    create: (context) => ReadingsInsertionBloc(
      context.read(),
      context.read(),
    ),
  ),
];
