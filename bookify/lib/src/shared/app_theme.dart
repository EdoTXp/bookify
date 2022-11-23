import 'package:bookify/src/shared/colors.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

final appLightTheme = ThemeData(
  splashColor: Colors.red,
  primaryColor: lightSelectedColor,
  unselectedWidgetColor: lightPrimaryColor,
  backgroundColor: Colors.black,
  iconTheme: const IconThemeData(color:  lightPrimaryColor),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: lightPrimaryColor,
    backgroundColor: Colors.white,
  ),
);

final appDarkTheme = ThemeData.dark(
);
