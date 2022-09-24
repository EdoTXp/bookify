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
          style: GoogleFonts.roboto(
            fontSize: 23,
            color: Colors.white,
          )),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      padding: const EdgeInsets.all(30),
      pressElevation: 0,
      tooltip: "A lista de livros será filtrada por ${widget.label}",
      backgroundColor: const Color(0xFF62B2DE),
      selectedColor: const Color(0xFFFF8CA2),
      selected: isSelected,
      onSelected: ((value) {
        setState(() {
          isSelected = value;
          widget.onSelected(value);
        });
      }),
    );
  }
}


    //TODO Aggiungere il ChoseClip al posto del container




   /* return Container(
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
    );*/