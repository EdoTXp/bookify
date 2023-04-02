import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedBoxChoiceChip extends StatefulWidget {
  final String label;
  final void Function(bool value) onSelected;
  final Color? backgroundColor;
  final Color? selectedColor;

  const RoundedBoxChoiceChip({
    Key? key,
    required this.label,
    required this.onSelected,
    this.backgroundColor,
    this.selectedColor,
  }) : super(key: key);

  @override
  State<RoundedBoxChoiceChip> createState() => _RoundedBoxChoiceChipState();
}

class _RoundedBoxChoiceChipState extends State<RoundedBoxChoiceChip> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: SizedBox(
        height: 30,
        width: 130,
        child: Center(
          child: Text(widget.label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                color: Colors.white,
              )),
        ),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      pressElevation: 0,
      tooltip: "A lista de livros será filtrada por ${widget.label}",
      backgroundColor:
          widget.backgroundColor ?? Theme.of(context).unselectedWidgetColor,
      selectedColor: widget.backgroundColor ?? Theme.of(context).primaryColor,
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
