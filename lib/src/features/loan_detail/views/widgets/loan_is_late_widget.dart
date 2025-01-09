import 'package:flutter/material.dart';

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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: Colors.amber,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Empréstimo atrasado!',
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
