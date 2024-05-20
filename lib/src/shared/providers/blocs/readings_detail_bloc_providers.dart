import 'package:bookify/src/features/readings_detail/bloc/readings_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final readingsDetailBlocProviders = [
  BlocProvider<ReadingsDetailBloc>(
    create: (context) => ReadingsDetailBloc(
      context.read(),
      context.read(),
    ),
  ),
];
