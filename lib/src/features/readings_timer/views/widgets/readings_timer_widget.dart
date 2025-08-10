import 'package:bookify/src/core/dtos/reading_dto.dart';
import 'package:bookify/src/core/services/app_services/lock_screen_orientation_service/lock_screen_orientation_service.dart';
import 'package:bookify/src/core/services/app_services/play_alarm_sound_service/play_alarm_sound_service.dart';
import 'package:bookify/src/core/services/app_services/time_picker_dialog_service.dart/time_picker_dialog_service.dart';
import 'package:bookify/src/core/services/app_services/wake_lock_screen_service/wake_lock_screen_service.dart';
import 'package:bookify/src/features/readings_timer/views/widgets/header.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ReadingsTimerWidget extends StatefulWidget {
  final ReadingDto readingDto;
  final int timerDurationInSeconds;

  const ReadingsTimerWidget({
    super.key,
    required this.readingDto,
    required this.timerDurationInSeconds,
  });

  @override
  State<ReadingsTimerWidget> createState() => _ReadingsTimerWidgetState();
}

class _ReadingsTimerWidgetState extends State<ReadingsTimerWidget> {
  late final CountDownController _countDownController;
  late final PlayAlarmSoundService _alarmService;
  late int _timerDuration;
  late bool _timerIsStarted;
  late bool _timerIsEnded;

  @override
  void initState() {
    super.initState();
    LockScreenOrientationService.lockOrientationScreen(
      orientation: Orientation.portrait,
    );

    _countDownController = CountDownController();
    _alarmService = PlayAlarmSoundService(
      volume: 1.0,
    );
    _timerIsStarted = false;
    _timerIsEnded = true;
    _timerDuration = widget.timerDurationInSeconds;
  }

  @override
  void dispose() {
    LockScreenOrientationService.unLockOrientationScreen();
    WakeLockScreenService.unlockWakeScreen();
    _alarmService.dispose();
    super.dispose();
  }

  Future<void> _editTimer(BuildContext context) async {
    final timeDay = await TimePickerDialogService.showTimePickerDialog(context);

    if (timeDay != null) {
      final durationInSeconds = Duration(
        hours: timeDay.hour,
        minutes: timeDay.minute,
      ).inSeconds;

      if (durationInSeconds > 0) {
        setState(() {
          _timerDuration = durationInSeconds;
          _countDownController.restart(duration: _timerDuration);
          WakeLockScreenService.lockWakeScreen();
          _timerIsStarted = true;
          _timerIsEnded = false;
        });
      }
    }
  }

  void _startTimer() {
    _countDownController.start();
    setState(() {
      _timerIsStarted = true;
      _timerIsEnded = false;
      WakeLockScreenService.lockWakeScreen();
    });
  }

  Future<void> _stopTimer() async {
    _countDownController.reset();
    await _alarmService.stop();

    setState(() {
      _timerIsEnded = true;
      WakeLockScreenService.unlockWakeScreen();
    });
  }

  void _resumeTimer() {
    setState(() {
      _timerIsStarted = true;
    });
    _countDownController.resume();
  }

  void _pauseTimer() {
    setState(() {
      _timerIsStarted = false;
    });
    _countDownController.pause();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final book = widget.readingDto.book;
    final reading = widget.readingDto.reading;

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(
                bookTitle: book.title,
                fistAuthorName: book.authors.first.name,
                pagesReaded: reading.pagesReaded,
                pageCount: book.pageCount,
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                child: Text(
                  'edit-timer-button'.i18n(),
                  style: TextStyle(
                    color: colorScheme.secondary,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () async => await _editTimer(context),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: CircularCountDownTimer(
                  controller: _countDownController,
                  duration: _timerDuration,
                  height: MediaQuery.sizeOf(context).height * .55,
                  width: MediaQuery.sizeOf(context).width * .85,
                  fillColor: colorScheme.secondary,
                  ringColor: Colors.grey[50]!,
                  backgroundColor: colorScheme.primary.withValues(
                    alpha: .7,
                  ),
                  strokeWidth: 20.0,
                  isReverse: true,
                  isReverseAnimation: true,
                  textFormat: CountdownTextFormat.HH_MM_SS,
                  strokeCap: StrokeCap.round,
                  autoStart: false,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  onComplete: () async {
                    WakeLockScreenService.unlockWakeScreen();
                    await _alarmService.playAlarm();
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _timerIsEnded
                    ? BookifyElevatedButton.expanded(
                        text: 'start-timer-label'.i18n(),
                        suffixIcon: Icons.timer_rounded,
                        onPressed: _startTimer,
                      )
                    : Row(
                        children: [
                          Flexible(
                            child: BookifyOutlinedButton.expanded(
                              text: 'stop-timer-button'.i18n(),
                              suffixIcon: Icons.stop_rounded,
                              onPressed: () async => await _stopTimer(),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: BookifyElevatedButton.expanded(
                              text: _timerIsStarted
                                  ? 'pause-button'.i18n()
                                  : 'continue-button'.i18n(),
                              suffixIcon: _timerIsStarted
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              onPressed:
                                  _timerIsStarted ? _pauseTimer : _resumeTimer,
                            ),
                          ),
                        ],
                      ),
              ),
              if (_timerIsEnded)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BookifyOutlinedButton.expanded(
                    key: const Key('End Timer Button'),
                    text: 'finish-and-return-button'.i18n(),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
