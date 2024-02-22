import 'package:flutter/material.dart';

class LoanPage extends StatefulWidget {
  final String? searchQuery;

  const LoanPage({
    super.key,
    this.searchQuery,
  });

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
      ),
    );
  }
}
