import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class BookIATextWidget extends StatelessWidget {
  const BookIATextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'book-ia-text'.i18n(),
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
