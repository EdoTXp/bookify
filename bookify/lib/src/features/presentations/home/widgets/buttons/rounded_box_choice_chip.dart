import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedBoxChoiceChip extends StatefulWidget {
  final String label;
  final void Function(bool value) onSelected;

  const RoundedBoxChoiceChip({
    Key? key,
    required this.label,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<RoundedBoxChoiceChip> createState() => _RoundedBoxChoiceChipState();
}

class _RoundedBoxChoiceChipState extends State<RoundedBoxChoiceChip> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            color: Colors.white,
          )),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      pressElevation: 0,
      tooltip: "A lista de livros será filtrada por ${widget.label}",
      backgroundColor: const Color(0xFF62B2DE),
      selectedColor: const Color(0xFFFF8CA2),
      selected: isSelected,
      onSelected: ((value) {
        widget.onSelected(value);
        setState(() {
          isSelected = value;
        });
      }),
    );
  }
}
