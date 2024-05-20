import 'package:bookify/src/features/profile/views/widgets/user_circle_avatar.dart';
import 'package:bookify/src/features/settings/views/settings_page.dart';
import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:bookify/src/core/models/user_model.dart';
import 'package:bookify/src/core/services/app_services/show_dialog_service/show_dialog_service.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class ProfileLoadedStateWidget extends StatelessWidget {
  final UserModel userModel;
  final VoidCallback onPressedLogOut;

  const ProfileLoadedStateWidget({
    super.key,
    required this.userModel,
    required this.onPressedLogOut,
  });

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
              Positioned(
                bottom: -90,
                child: UserCircleAvatar(
                  userModel: userModel,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              userModel.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            color: colorScheme.primary,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: UserInformationRow(),
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
            onPressed: () async {
              await ShowDialogService.showAlertDialog(
                context: context,
                title: 'Fazer o logout',
                content:
                    'Clicando em CONFIRMAR, todas as configurações serão apagadas.\nTem certeza?',
                confirmButtonFunction: () {
                  onPressedLogOut();
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
