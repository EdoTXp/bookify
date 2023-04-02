import 'package:flutter/material.dart';


class FilterRowWidget extends StatelessWidget {
  final Text text;
  final IconData? prefixIcon;
  final Color? iconColor;
  final IconData? suffixIcon;
  final double? width;

/// Class that creates a [Row] with a [required] [Text] in it and two optional icons in front [prefixIcon] and behind [suffixIcon].
  const FilterRowWidget({
    Key? key,
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.iconColor,
    this.width = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (prefixIcon != null) ...[
          Icon(
            prefixIcon,
            color: iconColor ?? Theme.of(context).colorScheme.background,
          ),
          SizedBox(width: width),
        ],
        text,
        if (suffixIcon != null) ...[
          SizedBox(width: width),
          Icon(
            suffixIcon,
            color: iconColor ?? Theme.of(context).colorScheme.background,
          ),
        ],
      ],
    );
  }
}
