import 'package:bookify/src/features/loan/bloc/loan_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final loanPageProviders = [
  BlocProvider<LoanBloc>(
    create: (context) => LoanBloc(
      context.read(),
      context.read(),
      context.read(),
    ),
  ),
];