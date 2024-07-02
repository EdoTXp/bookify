import 'package:bookify/src/core/helpers/color_brightness/color_brightness_extension.dart';
import 'package:bookify/src/core/models/user_hour_time_model.dart';
import 'package:bookify/src/features/time_picker/views/time_picker_page.dart';
import 'package:flutter/material.dart';

class HourTimeSelectedWidget extends StatefulWidget {
  final void Function(TimeOfDay startingTime, TimeOfDay endingTime)
      onSelectedTimes;
  final UserHourTimeModel? userHourTimeModel;

  const HourTimeSelectedWidget({
    super.key,
    required this.onSelectedTimes,
    this.userHourTimeModel,
  });

  @override
  State<HourTimeSelectedWidget> createState() => _HourTimeSelectedWidgetState();
}

class _HourTimeSelectedWidgetState extends State<HourTimeSelectedWidget> {
  late TimeOfDay _startingTime;
  late TimeOfDay _endingTime;

  @override
  void initState() {
    super.initState();
    _startingTime = TimeOfDay(
      hour: widget.userHourTimeModel?.startingHour ?? 7,
      minute: widget.userHourTimeModel?.startingMinute ?? 0,
    );

    _endingTime = TimeOfDay(
      hour: widget.userHourTimeModel?.endingHour ?? 8,
      minute: widget.userHourTimeModel?.endingMinute ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuerySizeOf = MediaQuery.sizeOf(context);

    return Material(
      child: InkWell(
        onTap: () async {
          final times = await Navigator.of(context).pushNamed(
            TimePickerPage.routeName,
            arguments: widget.userHourTimeModel,
          ) as List<TimeOfDay>?;

          if (times != null) {
            setState(() {
              _startingTime = times[0];
              _endingTime = times[1];
            });

            widget.onSelectedTimes(
              times[0],
              times[1],
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 30.0,
          ),
          width: mediaQuerySizeOf.width,
          decoration: BoxDecoration(
            color: colorScheme.primary.darken(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                'Defina a melhor hora para as suas leituras:',
                textAlign: TextAlign.center,
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: mediaQuerySizeOf.width,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_startingTime.format(context)} até ${_endingTime.format(context)}',
                  textScaler: TextScaler.noScaling,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
