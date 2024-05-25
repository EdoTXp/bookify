import 'package:bookify/src/features/notifications/bloc/notifications_bloc.dart';
import 'package:bookify/src/features/notifications/views/widgets/notifications_loaded_state_widget.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatefulWidget {
  /// The Route Name = '/notifications'
  static const routeName = '/notifications';

  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late NotificationsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<NotificationsBloc>()
      ..add(
        GotNotificationsEvent(),
      );
  }

  Widget _getWidgetOnNotificationsState(
    BuildContext context,
    NotificationsState state,
  ) {
    return switch (state) {
      NotificationsLoadingState() => const CenterCircularProgressIndicator(),
      NotificationEmptyState() => const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Não foi encontrada nenhuma notificação',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      NotificationsLoadedState(:final notifications) =>
        NotificationsLoadedStateWidget(
          notifications: notifications,
        ),
      NotificationErrorState(:final errorMessage) =>
        InfoItemStateWidget.withErrorState(
          message: errorMessage,
          onPressed: _onRefreshPage,
        ),
    };
  }

  void _onRefreshPage() {
    _bloc.add(
      GotNotificationsEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notificações',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        bloc: _bloc,
        builder: _getWidgetOnNotificationsState,
      ),
    );
  }
}
