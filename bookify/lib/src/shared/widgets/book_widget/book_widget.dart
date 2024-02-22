import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookWidget extends StatelessWidget {
  final String bookImageUrl;
  final double? height;
  final double? width;
  final Color? borderColor;
  final bool withShadow;

  const BookWidget({
    super.key,
    required this.bookImageUrl,
    this.height,
    this.width,
    this.borderColor,
    this.withShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = borderColor ?? Colors.blueGrey[200]!;

    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: bookImageUrl,
      imageBuilder: (_, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: (withShadow)
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                    ),
                  ]
                : null,
            border: Border.all(color: color),
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
      placeholder: (context, _) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (_, __, ___) => Icon(
        Icons.error_rounded,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
