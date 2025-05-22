import 'package:bookify/src/core/models/user_hour_time_model.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/features/hour_time_calculator/bloc/hour_time_calculator_bloc.dart';
import 'package:bookify/src/features/hour_time_calculator/views/widgets/programming_reading/programming_hour_loading_state_widget.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgrammingReadingHour extends StatefulWidget {
  const ProgrammingReadingHour({super.key});

  @override
  State<ProgrammingReadingHour> createState() => _ProgrammingHourState();
}

class _ProgrammingHourState extends State<ProgrammingReadingHour> {
  late HourTimeCalculatorBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<HourTimeCalculatorBloc>()..add(GotHourTimeEvent());
  }

  Widget _getWidgetOnHourTimeCalculatorState(
    BuildContext context,
    HourTimeCalculatorState state,
  ) {
    return switch (state) {
      HourTimeCalculatorLoadingState() ||
      HourTimeCalculatorInsertedState() ||
      HourTimeCalculatorRemovedNotificationState() =>
        const CenterCircularProgressIndicator(),
      HourTimeCalculatorLoadedState(:final userHourTimeModel) =>
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
      HourTimeCalculatorErrorState(:final errorMessage) => Center(
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
    return BlocConsumer<HourTimeCalculatorBloc, HourTimeCalculatorState>(
      bloc: _bloc,
      listener: (context, state) {
        final snackBarText = switch (state) {
          HourTimeCalculatorInsertedState() =>
            'Hora de leitura calculado com sucesso.',
          HourTimeCalculatorRemovedNotificationState() =>
            'Notificação removida com sucesso.',
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
      builder: _getWidgetOnHourTimeCalculatorState,
    );
  }
}
