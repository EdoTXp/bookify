import 'package:bookify/src/features/reading_page_time_calculator/views/widgets/reading_page_information/reading_page_information_widget.dart';
import 'package:bookify/src/features/reading_page_time_calculator/views/widgets/reading_page_timer/reading_page_timer_widget.dart';
import 'package:flutter/material.dart';

class ReadingPageTimeCalculatorPage extends StatefulWidget {
  /// The Route Name = '/reading_page_time_calculator'
  static const routeName = '/reading_page_time_calculator';

  const ReadingPageTimeCalculatorPage({super.key});

  @override
  State<ReadingPageTimeCalculatorPage> createState() =>
      _ReadingPageTimeCalculatorPageState();
}

class _ReadingPageTimeCalculatorPageState
    extends State<ReadingPageTimeCalculatorPage> {
  late bool _canCalculateReadingPage;

  @override
  void initState() {
    super.initState();
    _canCalculateReadingPage = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: !_canCalculateReadingPage
            ? ReadingPageInformationWidget(
                onPressedCalculated: () {
                  setState(() {
                    _canCalculateReadingPage = true;
                  });
                },
              )
            : const ReadingPageTimerWidget(),
      ),
    );
  }
}
