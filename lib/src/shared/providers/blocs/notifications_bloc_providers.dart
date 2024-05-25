import 'package:bookify/src/features/notifications/bloc/notifications_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final notificationsBlocProviders = [
  BlocProvider<NotificationsBloc>(
    create: (context) => NotificationsBloc(
      context.read(),
    ),
  ),
];
