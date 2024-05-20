import 'package:bookify/src/features/loan_insertion/bloc/loan_insertion_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final loanInsertionBlocProviders = [
  BlocProvider<LoanInsertionBloc>(
    create: (context) => LoanInsertionBloc(
      context.read(),
      context.read(),
      context.read(),
    ),
  ),
];
