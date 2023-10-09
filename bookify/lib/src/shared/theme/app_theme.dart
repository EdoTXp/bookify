import 'package:bookify/src/shared/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Theme for light mode
final appLightTheme = ThemeData(
  appBarTheme: _appBarTheme,
  textSelectionTheme: _textSelectionTheme,
  progressIndicatorTheme: _progressIndicatorTheme,
  textTheme: _textTheme,
  searchBarTheme: _searchBarTheme,
  segmentedButtonTheme: _segmentedButtonTheme,
  splashColor: Colors.transparent,
  iconTheme: _iconTheme,
  textButtonTheme: _textButtonTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  outlinedButtonTheme: _outlinedButtonTheme,
  inputDecorationTheme: _inputDecorationTheme,
  floatingActionButtonTheme:
      _floatingActionButtonTheme.copyWith(backgroundColor: Colors.white),
  colorScheme: const ColorScheme.light(
    primary: bookifyPrimaryColor,
    secondary: bookifySecundaryColor,
    tertiary: bookifyTertiaryColor,
    error: bookifyErrorColor,
  ),
);

/// Theme for dark mode
final appDarkTheme = ThemeData(
  appBarTheme: _appBarTheme,
  textSelectionTheme: _textSelectionTheme,
  progressIndicatorTheme: _progressIndicatorTheme,
  textTheme: _textTheme,
  searchBarTheme: _searchBarTheme,
  segmentedButtonTheme: _segmentedButtonTheme,
  splashColor: Colors.transparent,
  iconTheme: _iconTheme,
  textButtonTheme: _textButtonTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  outlinedButtonTheme: _outlinedButtonTheme,
  inputDecorationTheme: _inputDecorationTheme,
  floatingActionButtonTheme: _floatingActionButtonTheme.copyWith(
    backgroundColor: const Color(0xff404040),
  ),
  colorScheme: const ColorScheme.dark(
    primary: bookifyPrimaryColor,
    secondary: bookifySecundaryColor,
    tertiary: bookifyTertiaryColor,
    error: bookifyErrorColor,
  ),
);

// Theme Components

/// Invisible appBar
const _appBarTheme = AppBarTheme(
  backgroundColor: Colors.transparent,
  shadowColor: Colors.transparent,
  iconTheme: IconThemeData(color: bookifySecundaryColor),
);

const _progressIndicatorTheme = ProgressIndicatorThemeData(color: bookifySecundaryColor);

final _textTheme = TextTheme(
  displayLarge: GoogleFonts.roboto(fontSize: 64),
  headlineLarge: GoogleFonts.roboto(fontSize: 40),
  headlineSmall: GoogleFonts.roboto(fontSize: 32),
  titleLarge: GoogleFonts.roboto(
    fontWeight: FontWeight.w500,
    fontSize: 28,
  ),
  titleMedium: GoogleFonts.roboto(
    fontWeight: FontWeight.w500,
    fontSize: 24,
    letterSpacing: .15,
  ),
  titleSmall: GoogleFonts.roboto(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    letterSpacing: .1,
  ),
  labelLarge: GoogleFonts.roboto(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    letterSpacing: .1,
  ),
  labelMedium: GoogleFonts.roboto(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    letterSpacing: .5,
  ),
  labelSmall: GoogleFonts.roboto(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    letterSpacing: .5,
  ),
  bodyLarge: GoogleFonts.roboto(
    fontSize: 24,
    letterSpacing: .15,
  ),
  bodyMedium: GoogleFonts.roboto(
    fontSize: 20,
    letterSpacing: .25,
  ),
  bodySmall: GoogleFonts.roboto(
    fontSize: 16,
    letterSpacing: .4,
  ),
);

const _textSelectionTheme = TextSelectionThemeData(
  cursorColor: bookifyPrimaryColor,
  selectionColor: bookifyPrimaryColor,
);

const _searchBarTheme = SearchBarThemeData(
  side: MaterialStatePropertyAll(
    BorderSide(color: bookifySecundaryColor),
  ),
  elevation: MaterialStatePropertyAll(0),
  padding: MaterialStatePropertyAll(
    EdgeInsets.symmetric(horizontal: 16),
  ),
  textStyle: MaterialStatePropertyAll(TextStyle(
    fontSize: 14,
  )),
  hintStyle: MaterialStatePropertyAll(TextStyle(
    fontSize: 14,
    color: bookifySecundaryColor,
  )),
);

const _segmentedButtonTheme = SegmentedButtonThemeData(
  style: ButtonStyle(
    surfaceTintColor: MaterialStatePropertyAll(bookifySecundaryColor),
    visualDensity: VisualDensity.comfortable,
    textStyle: MaterialStatePropertyAll(TextStyle(
      fontSize: 12,
      overflow: TextOverflow.ellipsis,
    )),
    side: MaterialStatePropertyAll(BorderSide(color: bookifySecundaryColor)),
    iconColor: MaterialStatePropertyAll(bookifySecundaryColor),
  ),
);

const _iconTheme = IconThemeData(color: bookifyPrimaryColor);

final _textButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    foregroundColor: const MaterialStatePropertyAll(bookifyPrimaryColor),
    iconColor: const MaterialStatePropertyAll(bookifyPrimaryColor),
    overlayColor: MaterialStatePropertyAll(Colors.grey[200]),
    textStyle: const MaterialStatePropertyAll(
      TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
);

final _elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: const MaterialStatePropertyAll(bookifySecundaryColor),
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 14)),
  ),
);

final _outlinedButtonTheme = OutlinedButtonThemeData(
  style: ButtonStyle(
    foregroundColor: const MaterialStatePropertyAll(bookifySecundaryColor),
    overlayColor: MaterialStatePropertyAll(Colors.grey[200]),
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    side: const MaterialStatePropertyAll(
      BorderSide(
        width: 2,
        color: bookifySecundaryColor,
      ),
    ),
    textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 14)),
  ),
);

const _inputDecorationTheme = InputDecorationTheme(
  floatingLabelStyle: TextStyle(color: bookifyPrimaryColor),
);

const _floatingActionButtonTheme = FloatingActionButtonThemeData(
  splashColor: Colors.transparent,
  foregroundColor: bookifyPrimaryColor,
  shape: RoundedRectangleBorder(
    side: BorderSide(color: bookifyPrimaryColor),
    borderRadius: BorderRadius.all(Radius.circular(15)),
  ),
);
