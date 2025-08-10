import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class LoanIsLateWidget extends StatelessWidget {
  const LoanIsLateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.amber.withValues(
          alpha: .5,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber_outlined,
            color: Colors.amber,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'late-loan-label'.i18n(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
