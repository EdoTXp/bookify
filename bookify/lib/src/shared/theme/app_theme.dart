import 'package:bookify/src/shared/theme/colors.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

final appLightTheme = ThemeData(
    splashColor: Colors.red,
    primaryColor: lightSelectedColor,
    unselectedWidgetColor: lightPrimaryColor,
    iconTheme: const IconThemeData(color: lightPrimaryColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: lightPrimaryColor,
      backgroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.light(background: Colors.black));

final appDarkTheme = ThemeData.dark();
