import 'package:bookify/src/features/loan_detail/bloc/loan_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final loanDetailPageProviders = [
  BlocProvider<LoanDetailBloc>(
    create: (context) => LoanDetailBloc(
      context.read(),
      context.read(),
      context.read(),
      context.read(),
    ),
  ),
];
