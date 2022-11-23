import 'package:flutter/material.dart';

class BookButton extends StatelessWidget {
  final String bookUrl;
  final void Function() onTap;

  const BookButton({
    Key? key,
    required this.bookUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO corregere il problema del click quando il widget non è visibile
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image:
              DecorationImage(image: NetworkImage(bookUrl), fit: BoxFit.fill),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }
}
