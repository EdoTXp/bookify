import 'package:bookify/src/core/helpers/size/size_for_small_device_extension.dart';
import 'package:bookify/src/core/models/user_hour_time_model.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/features/time_picker/views/widgets/time_picker_widget.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class TimePickerPage extends StatefulWidget {
  /// The Route Name = '/time_picker'
  static const routeName = '/time_picker';

  final UserHourTimeModel? userHourTimeModel;

  const TimePickerPage({
    super.key,
    this.userHourTimeModel,
  });

  @override
  State<TimePickerPage> createState() => _TimePickerPageState();
}

class _TimePickerPageState extends State<TimePickerPage> {
  late TimeOfDay startingTime;
  late TimeOfDay endingTime;

  @override
  void initState() {
    super.initState();

    startingTime = TimeOfDay(
      hour: widget.userHourTimeModel?.startingHour ?? 0,
      minute: widget.userHourTimeModel?.startingMinute ?? 0,
    );

    endingTime = TimeOfDay(
      hour: widget.userHourTimeModel?.endingHour ?? 0,
      minute: widget.userHourTimeModel?.endingMinute ?? 0,
    );
  }

  int compareTimes(TimeOfDay firstTime, TimeOfDay secondTime) {
    final double firstTimeDouble = firstTime.hour + firstTime.minute / 60.0;
    final double secondTimeDouble = secondTime.hour + secondTime.minute / 60.0;

    if (firstTimeDouble < secondTimeDouble) {
      return -1;
    } else if (firstTimeDouble > secondTimeDouble) {
      return 1;
    } else {
      return 0;
    }
  }

  void _defineTimer() {
    final endTimesIsGreaterThanStart = compareTimes(
      startingTime,
      endingTime,
    );

    if (endTimesIsGreaterThanStart > -1) {
      SnackbarService.showSnackBar(
        context,
        'end-times-is-greater-than-start'.i18n(),
        SnackBarType.error,
      );
      return;
    }

    Navigator.of(context).pop(
      [
        startingTime,
        endingTime,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(builder: (context, constraints) {
        final isSmallDevice = constraints.biggest.isSmallDevice();

        return SingleChildScrollView(
          child: SizedBox(
            height: isSmallDevice
                ? MediaQuery.sizeOf(context).height
                : constraints.biggest.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 30.0,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TimePickerWidget(
                    onTimeSelected: (TimeOfDay time) {
                      setState(() {
                        startingTime = time;
                      });
                    },
                    hour: startingTime.hour,
                    minute: startingTime.minute,
                  ),
                  const Text('|'),
                  Text('to-time'.i18n()),
                  const Text('|'),
                  TimePickerWidget(
                    onTimeSelected: (TimeOfDay time) {
                      setState(() {
                        endingTime = time;
                      });
                    },
                    hour: endingTime.hour,
                    minute: endingTime.minute,
                  ),
                  const Spacer(),
                  BookifyOutlinedButton.expanded(
                    text: 'define-return-button'.i18n(),
                    onPressed: _defineTimer,
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
