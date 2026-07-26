import 'package:bookify/src/features/settings/views/widgets/delete_account_settings/bloc/delete_account_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final deleteAccountBlocProviders = [
  BlocProvider<DeleteAccountBloc>(
    create: (context) => DeleteAccountBloc(
      authService: context.read(),
      localDatabaseService: context.read(),
      storageService: context.read(),
    ),
  ),
];
