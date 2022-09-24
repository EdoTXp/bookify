import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: const Center(
          child: Text(
        'Profile Page',
        style: TextStyle(color: Colors.black),
      )),
    );
  }
}
