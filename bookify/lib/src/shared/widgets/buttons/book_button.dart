import 'package:bookify/src/shared/widgets/buttons/book_widget.dart';
import 'package:flutter/material.dart';

class BookButton extends StatelessWidget {
  final String bookImageUrl;
  final void Function() onTap;

  const BookButton({
    Key? key,
    required this.bookImageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO Correct the click problem when the widget is not visible
    return InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: BookWidget(bookImageUrl: bookImageUrl));
  }
}
