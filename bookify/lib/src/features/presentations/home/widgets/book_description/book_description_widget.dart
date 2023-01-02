import 'package:flutter/material.dart';

class BookDescriptionWidget extends StatelessWidget {
  final String title;
  final String content;

  const BookDescriptionWidget(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).unselectedWidgetColor,
        ),
        children: [
          TextSpan(
            text: content,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1!.color,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
