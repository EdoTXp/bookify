import 'package:bookify/src/shared/theme/colors.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

final appLightTheme = ThemeData(
    searchBarTheme: const SearchBarThemeData(
        side: MaterialStatePropertyAll(
          BorderSide(color: lightSelectedColor),
        ),
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
        hintStyle:
            MaterialStatePropertyAll(TextStyle(color: lightSelectedColor))),
    splashColor: Colors.red,
    primaryColor: lightSelectedColor,
    unselectedWidgetColor: lightPrimaryColor,
    iconTheme: const IconThemeData(color: lightPrimaryColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: lightPrimaryColor,
      backgroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.light(background: Colors.black));

final appDarkTheme = ThemeData(
    searchBarTheme: const SearchBarThemeData(
        side: MaterialStatePropertyAll(
          BorderSide(color: lightSelectedColor),
        ),
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
        hintStyle:
            MaterialStatePropertyAll(TextStyle(color: lightSelectedColor))),
    splashColor: Colors.red,
    primaryColor: lightSelectedColor,
    unselectedWidgetColor: lightPrimaryColor,
    iconTheme: const IconThemeData(color: lightPrimaryColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: lightPrimaryColor, backgroundColor: Color(0xff2D2D32)),
    colorScheme: const ColorScheme.dark());
