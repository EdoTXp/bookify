import 'package:bookify/src/core/models/user_model.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/contact_circle_avatar/contact_circle_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserCircleAvatar extends StatelessWidget {
  final UserModel userModel;

  const UserCircleAvatar({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    if (userModel.photo != null) {
      return CachedNetworkImage(
        height: 133,
        width: 133,
        imageUrl: userModel.photo!,
        imageBuilder: (_, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          );
        },
        placeholder: (context, _) => const CenterCircularProgressIndicator(),
        errorWidget: (_, __, ___) => Icon(
          Icons.error_rounded,
          color: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      return ContactCircleAvatar(
        height: 133,
        width: 133,
        name: userModel.name,
      );
    }
  }
}
