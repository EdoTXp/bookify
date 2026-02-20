import 'book_ia_text_widget.dart';
import 'timer_widget.dart';
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
    extends State<ReadingPageTimerLoadedStateWidget>
    with WidgetsBindingObserver {
  late StopWatchTimer _stopWatchTimer;
  final ValueNotifier<bool> _isTimerRunningNotifier = ValueNotifier<bool>(
    false,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _stopWatchTimer = StopWatchTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive && _isTimerRunningNotifier.value) {
      _toggleTimer(false);
    }

    super.didChangeAppLifecycleState(state);
  }

  void _toggleTimer(bool start) {
    if (start) {
      _stopWatchTimer.onStartTimer();
    } else {
      _stopWatchTimer.onStopTimer();
    }
    _isTimerRunningNotifier.value = _stopWatchTimer.isRunning;
  }

  void _resetTimer() {
    _stopWatchTimer.onResetTimer();
    _isTimerRunningNotifier.value = false;
  }

  @override
  Future<void> dispose() async {
    await _stopWatchTimer.dispose();
    _isTimerRunningNotifier.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
                  child: StreamBuilder<int>(
                    stream: _stopWatchTimer.secondTime,
                    initialData: 0,
                    builder: (_, seconds) {
                      return TimerWidget(
                        key: const Key('TimerWidget'),
                        seconds: seconds.data ?? 0,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 5),
                ValueListenableBuilder<bool>(
                  valueListenable: _isTimerRunningNotifier,
                  builder: (context, isRunning, _) {
                    if (!isRunning) {
                      return IconButton(
                        tooltip: 'close-page-button-tooltip'.i18n(),
                        onPressed: Navigator.of(context).pop,
                        icon: Icon(
                          Icons.close_rounded,
                          color: colorScheme.secondary,
                        ),
                      );
                    } else {
                      return IconButton(
                        tooltip: 'reset-timer-button-tooltip'.i18n(),
                        onPressed: _resetTimer,
                        icon: Icon(
                          Icons.restart_alt_outlined,
                          color: colorScheme.secondary,
                        ),
                      );
                    }
                  },
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
                  child: ValueListenableBuilder(
                    valueListenable: _isTimerRunningNotifier,
                    builder: (context, isRunning, _) {
                      return BookifyOutlinedButton.expanded(
                        key: const Key('StartStopTimerButton'),
                        text: isRunning
                            ? 'stop-timer-button'.i18n()
                            : 'start-timer-button'.i18n(),
                        suffixIcon: isRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        onPressed: () => _toggleTimer(!isRunning),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                StreamBuilder<int>(
                  stream: _stopWatchTimer.secondTime,
                  initialData: 0,
                  builder: (_, snapshot) {
                    final seconds = snapshot.data ?? 0;
                    if (seconds > 0) {
                      return Flexible(
                        child: BookifyElevatedButton.expanded(
                          text: 'finish-timer-button'.i18n(),
                          suffixIcon: Icons.check_rounded,
                          onPressed: () {
                            _stopWatchTimer.onStopTimer();
                            widget.onFinish(seconds);
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
