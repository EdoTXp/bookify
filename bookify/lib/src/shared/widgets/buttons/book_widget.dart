import 'package:flutter/material.dart';

class BookWidget extends StatelessWidget {
  final String bookImageUrl;
  final double? height;
  final double? width;

  const BookWidget({
    super.key,
    required this.bookImageUrl,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey[200]!,
        ),
        image: DecorationImage(
          image: NetworkImage(bookImageUrl),
          fit: BoxFit.fill,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
    );
  }
}
