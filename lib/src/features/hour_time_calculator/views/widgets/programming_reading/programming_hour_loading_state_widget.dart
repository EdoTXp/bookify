import 'package:bookify/src/core/helpers/size/size_for_small_device_extension.dart';
import 'package:bookify/src/core/models/user_hour_time_model.dart';
import 'package:bookify/src/features/hour_time_calculator/views/widgets/programming_reading/hour_time_selected_widget.dart';
import 'package:bookify/src/features/hour_time_calculator/views/widgets/programming_reading/repeat_time_widget.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';

class ProgrammingHourLoadingStateWidget extends StatefulWidget {
  final void Function(UserHourTimeModel userHourTimeModel) onSelectedUserModel;
  final UserHourTimeModel? initialUserHourTimeModel;

  const ProgrammingHourLoadingStateWidget({
    super.key,
    required this.onSelectedUserModel,
    this.initialUserHourTimeModel,
  });

  @override
  State<ProgrammingHourLoadingStateWidget> createState() =>
      _ProgrammingHourLoadingStateWidgetState();
}

class _ProgrammingHourLoadingStateWidgetState
    extends State<ProgrammingHourLoadingStateWidget> {
  late UserHourTimeModel userHourTimeModel;

  @override
  void initState() {
    super.initState();
    userHourTimeModel = UserHourTimeModel(
      repeatHourTimeType: widget.initialUserHourTimeModel?.repeatHourTimeType ??
          RepeatHourTimeType.daily,
      startingHour: widget.initialUserHourTimeModel?.startingHour ?? 7,
      startingMinute: widget.initialUserHourTimeModel?.startingMinute ?? 0,
      endingHour: widget.initialUserHourTimeModel?.endingHour ?? 8,
      endingMinute: widget.initialUserHourTimeModel?.endingMinute ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallDevice = constraints.biggest.isSmallDevice();

          return SingleChildScrollView(
            child: SizedBox(
              height: isSmallDevice
                  ? MediaQuery.sizeOf(context).height
                  : constraints.biggest.height,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: Navigator.of(context).pop,
                        icon: Icon(
                          Icons.close_rounded,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RepeatTimeWidget(
                      initialRepeatTimeSelected:
                          userHourTimeModel.repeatHourTimeType.toIntValue(),
                      onSelectedRepeatTime: (int selectedRepeatTime) {
                        setState(() {
                          userHourTimeModel = userHourTimeModel.copyWith(
                            repeatHourTimeType: RepeatHourTimeType.toType(
                              selectedRepeatTime,
                            ),
                          );
                        });
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    HourTimeSelectedWidget(
                      userHourTimeModel: userHourTimeModel,
                      onSelectedTimes: (
                        TimeOfDay startingTime,
                        TimeOfDay endingTime,
                      ) {
                        setState(() {
                          userHourTimeModel = userHourTimeModel.copyWith(
                            startingHour: startingTime.hour,
                            startingMinute: startingTime.minute,
                            endingHour: endingTime.hour,
                            endingMinute: endingTime.minute,
                          );
                        });
                      },
                    ),
                    const Spacer(),
                    BookifyOutlinedButton.expanded(
                      text: 'Finalizar',
                      suffixIcon: Icons.check_rounded,
                      onPressed: () {
                        widget.onSelectedUserModel(userHourTimeModel);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
