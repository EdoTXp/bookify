import 'package:bookify/src/shared/theme/colors.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

/// Theme for light mode
final appLightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      iconTheme: IconThemeData(color: lightSelectedColor),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: lightPrimaryColor,
      selectionColor: lightPrimaryColor,
    ),
    searchBarTheme: const SearchBarThemeData(
      side: MaterialStatePropertyAll(
        BorderSide(color: lightSelectedColor),
      ),
      elevation: MaterialStatePropertyAll(0),
      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
      hintStyle: MaterialStatePropertyAll(TextStyle(color: lightSelectedColor)),
    ),
    segmentedButtonTheme: const SegmentedButtonThemeData(
      style: ButtonStyle(
        surfaceTintColor: MaterialStatePropertyAll(lightSelectedColor),
        visualDensity: VisualDensity.comfortable,
        textStyle: MaterialStatePropertyAll(
            TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis)),
        side: MaterialStatePropertyAll(BorderSide(color: lightSelectedColor)),
        iconColor: MaterialStatePropertyAll(lightSelectedColor),
      ),
    ),
    splashColor: Colors.red,
    primaryColor: lightSelectedColor,
    unselectedWidgetColor: lightPrimaryColor,
    iconTheme: const IconThemeData(color: lightPrimaryColor),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
          overlayColor: MaterialStatePropertyAll(Colors.transparent),
          foregroundColor: MaterialStatePropertyAll(lightPrimaryColor),
          iconColor: MaterialStatePropertyAll(lightPrimaryColor),
          textStyle:
              MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.bold))),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: lightPrimaryColor),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: lightPrimaryColor,
      backgroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.light(background: Colors.black));

/// Theme for dark mode
final appDarkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      iconTheme: IconThemeData(color: lightSelectedColor),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: lightPrimaryColor,
      selectionColor: lightPrimaryColor,
    ),
    searchBarTheme: const SearchBarThemeData(
      side: MaterialStatePropertyAll(
        BorderSide(color: lightSelectedColor),
      ),
      elevation: MaterialStatePropertyAll(0),
      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
      hintStyle: MaterialStatePropertyAll(TextStyle(color: lightSelectedColor)),
    ),
    segmentedButtonTheme: const SegmentedButtonThemeData(
      style: ButtonStyle(
        surfaceTintColor: MaterialStatePropertyAll(lightSelectedColor),
        visualDensity: VisualDensity.comfortable,
        textStyle: MaterialStatePropertyAll(
            TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis)),
        side: MaterialStatePropertyAll(BorderSide(color: lightSelectedColor)),
        iconColor: MaterialStatePropertyAll(lightSelectedColor),
      ),
    ),
    splashColor: Colors.red,
    primaryColor: lightSelectedColor,
    unselectedWidgetColor: lightPrimaryColor,
    iconTheme: const IconThemeData(color: lightPrimaryColor),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(lightPrimaryColor),
          iconColor: MaterialStatePropertyAll(lightPrimaryColor),
          textStyle:
              MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.bold))),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: lightPrimaryColor),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: lightPrimaryColor, backgroundColor: Color(0xff2D2D32)),
    colorScheme: const ColorScheme.dark());
