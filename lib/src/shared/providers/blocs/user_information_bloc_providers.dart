import 'package:bookify/src/features/profile/views/widgets/user_information_row/bloc/user_information_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final userInformationBlocProviders = [
  BlocProvider<UserInformationBloc>(
    create: (context) => UserInformationBloc(
      context.read(),
      context.read(),
      context.read(),
      context.read(),
    ),
  ),
];