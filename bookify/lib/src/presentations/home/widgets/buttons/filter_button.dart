import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterButton extends StatefulWidget {
  final String text;
  final bool isClicked;

  const FilterButton({
    Key? key,
    required this.text,
    this.isClicked = false,
  }) : super(key: key);

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: (widget.isClicked)
            ? const Color(0xFFFF8CA2)
            : const Color(0xFF62B2DE),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          widget.text,
          style: GoogleFonts.roboto(
            fontSize: 23,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
