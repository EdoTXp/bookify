import 'package:bookify/src/features/contacts_picker/views/widgets/widgets.dart';
import 'package:bookify/src/shared/dtos/conctact_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContactsPickerLoadedStateWidget extends StatefulWidget {
  final List<ContactDto> contatcts;
  final void Function(ContactDto contactDto) onSelectedContact;

  const ContactsPickerLoadedStateWidget({
    super.key,
    required this.contatcts,
    required this.onSelectedContact,
  });

  @override
  State<ContactsPickerLoadedStateWidget> createState() =>
      _ContactsPickerLoadedStateWidgetState();
}

class _ContactsPickerLoadedStateWidgetState
    extends State<ContactsPickerLoadedStateWidget> {
  ContactDto? selectedContactDto;
  int selectedIndex = -1;
  bool isSelectedMode = false;

  void _clearData() {
    setState(() {
      selectedIndex = -1;
      selectedContactDto = null;
      isSelectedMode = false;
    });
  }

  void _clickOnContact(ContactDto contactDto, int index) {
    if (selectedContactDto != null && selectedContactDto!.name.isNotEmpty) {
      setState(() {
        selectedContactDto = contactDto;
        selectedIndex = index;
        isSelectedMode = true;
      });
      return;
    }
    setState(() {
      selectedContactDto = contactDto;
      selectedIndex = index;
      isSelectedMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isSelectedMode) ...[
          ContactSelectedRow(
            onClearPressed: _clearData,
            onConfirmPressed: () => selectedContactDto != null
                ? widget.onSelectedContact(selectedContactDto!)
                : null,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
        Expanded(
          child: GestureDetector(
            onTap: _clearData,
            child: ListView.builder(
              itemCount: widget.contatcts.length,
              itemBuilder: (context, index) {
                return ContactWidget(
                  contactDto: widget.contatcts[index],
                  isSelected: selectedIndex == index,
                  onTap: () => _clickOnContact(
                    widget.contatcts[index],
                    index,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
