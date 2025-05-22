import 'package:bookify/src/features/hour_time_calculator/views/widgets/programming_reading/programming_reading_hour.dart';
import 'package:bookify/src/features/hour_time_calculator/views/widgets/reading_hour_information/reading_hour_information.dart';
import 'package:flutter/material.dart';

class HourTimeCalculatorPage extends StatefulWidget {
  /// The Route Name = '/reading_time_calculator'
  static const routeName = '/reading_time_calculator';

  const HourTimeCalculatorPage({super.key});

  @override
  State<HourTimeCalculatorPage> createState() => _HourTimeCalculatorPageState();
}

class _HourTimeCalculatorPageState extends State<HourTimeCalculatorPage> {
  late bool _canProgrammingHour;

  @override
  void initState() {
    super.initState();
    _canProgrammingHour = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: !_canProgrammingHour
            ? ReadingHourInformation(
                onPressedProgramming: () {
                  setState(() {
                    _canProgrammingHour = true;
                  });
                },
              )
            : const ProgrammingReadingHour(),
      ),
    );
  }
}
