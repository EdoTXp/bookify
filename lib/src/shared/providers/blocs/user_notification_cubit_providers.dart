import 'package:bookify/src/shared/cubits/user_notification_cubit/user_notification_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final userNotificationCubitProviders = [
  BlocProvider<UserNotificationCubit>(
    create: (context) => UserNotificationCubit(
      context.read(),
    ),
  ),
];
