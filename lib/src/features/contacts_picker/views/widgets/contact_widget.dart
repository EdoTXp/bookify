import 'package:bookify/src/shared/dtos/conctact_dto.dart';
import 'package:bookify/src/shared/widgets/contact_circle_avatar/contact_circle_avatar.dart';
import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  final ContactDto contactDto;
  final VoidCallback onTap;

  final bool isSelected;

  const ContactWidget({
    super.key,
    required this.contactDto,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: ContactCircleAvatar(
            name: contactDto.name,
            photo: contactDto.photo,
          ),
          title: Text(
            contactDto.name,
            textScaler: TextScaler.noScaling,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          trailing: Text(
            contactDto.phoneNumber ?? 'sem número',
            textScaler: TextScaler.noScaling,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          onTap: onTap,
          selected: isSelected,
          selectedTileColor: colorScheme.secondary.withOpacity(.7),
          selectedColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(21),
          ),
        ),
      ),
    );
  }
}
