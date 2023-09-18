import 'package:cached_network_image/cached_network_image.dart';
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
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: bookImageUrl,
      imageBuilder: (_, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey[200]!),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        );
      },
      placeholder: (context, _) => Center(
          child:
              CircularProgressIndicator(color: Theme.of(context).primaryColor)),
      errorWidget: (_, __, ___) => const Icon(
        Icons.error,
        color: Colors.red,
      ),
    );
  }
}
