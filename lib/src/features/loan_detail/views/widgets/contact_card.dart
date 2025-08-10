import 'dart:typed_data';

import 'package:bookify/src/shared/widgets/contact_circle_avatar/contact_circle_avatar.dart';
import 'package:bookify/src/shared/widgets/contact_information_widget/contact_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ContactCard extends StatelessWidget {
  final String? name;
  final Uint8List? photo;
  final String? phone;

  const ContactCard({
    super.key,
    this.name,
    this.photo,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contactName = name ?? 'no-name-label'.i18n();
    final mediaQueryWidth = MediaQuery.sizeOf(context).width;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(
          alpha: .3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ContactCircleAvatar(
                name: contactName,
                photo: photo,
                width: 80,
                height: 80,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContactInformationWidget(
                      iconData: Icons.person,
                      title: 'name-label'.i18n(),
                      content: contactName,
                      width: mediaQueryWidth,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ContactInformationWidget(
                      iconData: Icons.phone_android_rounded,
                      title: 'contact-number-label'.i18n(),
                      content: phone ?? 'no-contact-number-label'.i18n(),
                      width: mediaQueryWidth,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
