import 'package:bookify/src/features/profile/views/widgets/widgets.dart';
import 'package:bookify/src/features/settings/views/settings_page.dart';
import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:bookify/src/shared/widgets/contact_circle_avatar/contact_circle_avatar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                BookifyImages.profileHeaderBackground,
                height: 136,
                width: MediaQuery.sizeOf(context).width,
                fit: BoxFit.fill,
              ),
              const Positioned(
                bottom: -90,
                child: ContactCircleAvatar(
                  height: 133,
                  width: 133,
                  name: 'name',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 120,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: UserInformationRow(),
          ),
          Divider(
            color: colorScheme.primary,
          ),
          const SizedBox(
            height: 40,
          ),
          TextIconButton(
            label: 'Configurações',
            iconData: Icons.settings,
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                SettingsPage.routeName,
              );
            },
          ),
          TextIconButton(
            label: 'Notificações',
            iconData: Icons.notifications_outlined,
            onPressed: () {},
          ),
          const SizedBox(
            height: 30,
          ),
          TextIconButton(
            label: 'Sair',
            iconData: Icons.exit_to_app_outlined,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
