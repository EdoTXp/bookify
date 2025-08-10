import 'package:bookify/src/features/reading_page_time_calculator/views/widgets/reading_page_timer/book_ia_text_widget.dart';
import 'package:bookify/src/features/reading_page_time_calculator/views/widgets/reading_page_timer/timer_widget.dart';
import 'package:bookify/src/shared/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ReadingPageTimerLoadedStateWidget extends StatefulWidget {
  final void Function(int newTimeReading) onFinish;

  const ReadingPageTimerLoadedStateWidget({
    super.key,
    required this.onFinish,
  });

  @override
  State<ReadingPageTimerLoadedStateWidget> createState() =>
      _ReadingPageTimerLoadedStateWidgetState();
}

class _ReadingPageTimerLoadedStateWidgetState
    extends State<ReadingPageTimerLoadedStateWidget> {
  late StopWatchTimer _stopWatchTimer;
  late bool _stopWatchIsRunning;

  @override
  void initState() {
    super.initState();
    _stopWatchTimer = StopWatchTimer();
    _stopWatchIsRunning = _stopWatchTimer.isRunning;
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: _stopWatchTimer.secondTime,
                    initialData: 0,
                    builder: (_, seconds) {
                      return TimerWidget(
                        seconds: seconds.data ?? 0,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                if (!_stopWatchIsRunning)
                  IconButton(
                    tooltip: 'close-page-button-tooltip'.i18n(),
                    onPressed: Navigator.of(context).pop,
                    icon: Icon(
                      Icons.close_rounded,
                      color: colorScheme.secondary,
                    ),
                  )
                else
                  IconButton(
                    tooltip: 'reset-timer-button-tooltip'.i18n(),
                    onPressed: () {
                      _stopWatchTimer.onResetTimer();
                      setState(() {
                        _stopWatchIsRunning = false;
                      });
                    },
                    icon: Icon(
                      Icons.restart_alt_outlined,
                      color: colorScheme.secondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Expanded(
              child: BookIATextWidget(),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  child: BookifyOutlinedButton.expanded(
                    text: _stopWatchIsRunning
                        ? 'stop-timer-button'.i18n()
                        : 'start-timer-button'.i18n(),
                    suffixIcon: _stopWatchTimer.isRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    onPressed: () {
                      if (_stopWatchIsRunning) {
                        _stopWatchTimer.onStopTimer();
                        setState(() {
                          _stopWatchIsRunning = false;
                        });
                      } else {
                        _stopWatchTimer.onStartTimer();
                        setState(() {
                          _stopWatchIsRunning = true;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                StreamBuilder(
                  stream: _stopWatchTimer.secondTime,
                  initialData: 0,
                  builder: (_, seconds) {
                    if (seconds.data! > 0) {
                      return Flexible(
                        child: BookifyElevatedButton.expanded(
                          text: 'finish-timer-button'.i18n(),
                          suffixIcon: Icons.check_rounded,
                          onPressed: () {
                            _stopWatchTimer.onStopTimer();
                            widget.onFinish(seconds.data!);
                          },
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
