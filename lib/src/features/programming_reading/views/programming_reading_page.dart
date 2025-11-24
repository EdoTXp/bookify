import 'package:bookify/src/core/models/user_hour_time_model.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/features/programming_reading/bloc/programming_reading_bloc.dart';
import 'package:bookify/src/features/programming_reading/views/widgets/programming_hour_loading_state_widget.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class ProgrammingReadingPage extends StatefulWidget {
  /// The Route Name = '/programming_reading_page'
  static const routeName = '/programming_reading_page';

  const ProgrammingReadingPage({super.key});

  @override
  State<ProgrammingReadingPage> createState() => _ProgrammingHourState();
}

class _ProgrammingHourState extends State<ProgrammingReadingPage> {
  late ProgrammingReadingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ProgrammingReadingBloc>()..add(GotHourTimeEvent());
  }

  Widget _getWidgetOnProgrammingReadingState(
    BuildContext context,
    ProgrammingReadingState state,
  ) {
    return switch (state) {
      ProgrammingReadingLoadingState() ||
      ProgrammingReadingInsertedState() ||
      ProgrammingReadingRemovedNotificationState() =>
        const CenterCircularProgressIndicator(),
      ProgrammingReadingLoadedState(:final userHourTimeModel) =>
        ProgrammingHourLoadingStateWidget(
          initialUserHourTimeModel: userHourTimeModel,
          onSelectedUserModel: (UserHourTimeModel userHourTimeModel) {
            _bloc.add(
              InsertedHourTimeEvent(
                userHourTimeModel: userHourTimeModel,
              ),
            );
          },
          onRemoveReadingNotification: () => _bloc.add(
            RemovedNotificationHourTimeEvent(),
          ),
        ),
      ProgrammingReadingErrorState(:final errorMessage) => Center(
          child: InfoItemStateWidget.withErrorState(
            message: errorMessage,
            onPressed: _onRefreshPage,
          ),
        ),
    };
  }

  void _onRefreshPage() {
    _bloc.add(GotHourTimeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProgrammingReadingBloc, ProgrammingReadingState>(
        bloc: _bloc,
        listener: (context, state) {
          final snackBarText = switch (state) {
            ProgrammingReadingInsertedState() =>
              'reading-time-calculate-success-snackbar'.i18n(),
            ProgrammingReadingRemovedNotificationState() =>
              'reading-time-notification-removed-success-snackbar'.i18n(),
            _ => null,
          };

          if (snackBarText != null) {
            SnackbarService.showSnackBar(
              context,
              snackBarText,
              SnackBarType.success,
            );

            Future.delayed(
              const Duration(seconds: 2),
            ).then(
              Navigator.of(context).pop,
            );
          }
        },
        builder: _getWidgetOnProgrammingReadingState,
      ),
    );
  }
}
