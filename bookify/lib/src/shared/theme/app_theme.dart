import 'package:bookify/src/shared/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Theme for light mode
final appLightTheme = ThemeData(
  appBarTheme: _appBarTheme,
  textSelectionTheme: _textSelectionTheme,
  textTheme: _textTheme,
  searchBarTheme: _searchBarTheme,
  segmentedButtonTheme: _segmentedButtonTheme,
  splashColor: Colors.transparent,
  primaryColor: lightSelectedColor,
  hoverColor: Colors.red,
  unselectedWidgetColor: lightPrimaryColor,
  iconTheme: _iconTheme,
  textButtonTheme: _textButtonTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  outlinedButtonTheme: _outlinedButtonTheme,
  inputDecorationTheme: _inputDecorationTheme,
  floatingActionButtonTheme:
      _floatingActionButtonTheme.copyWith(backgroundColor: Colors.white),
  colorScheme: const ColorScheme.light(),
);

/// Theme for dark mode
final appDarkTheme = ThemeData(
  appBarTheme: _appBarTheme,
  textSelectionTheme: _textSelectionTheme,
  textTheme: _textTheme,
  searchBarTheme: _searchBarTheme,
  segmentedButtonTheme: _segmentedButtonTheme,
  splashColor: Colors.transparent,
  primaryColor: lightSelectedColor,
  unselectedWidgetColor: lightPrimaryColor,
  iconTheme: _iconTheme,
  textButtonTheme: _textButtonTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  outlinedButtonTheme: _outlinedButtonTheme,
  inputDecorationTheme: _inputDecorationTheme,
  floatingActionButtonTheme: _floatingActionButtonTheme.copyWith(
    backgroundColor: const Color(0xff404040),
  ),
  colorScheme: const ColorScheme.dark(),
);

// Theme Components

/// Invisible appBar
const _appBarTheme = AppBarTheme(
  backgroundColor: Colors.transparent,
  shadowColor: Colors.transparent,
  iconTheme: IconThemeData(color: lightSelectedColor),
);

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
  cursorColor: lightPrimaryColor,
  selectionColor: lightPrimaryColor,
);

const _searchBarTheme = SearchBarThemeData(
  side: MaterialStatePropertyAll(
    BorderSide(color: lightSelectedColor),
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
    color: lightSelectedColor,
  )),
);

const _segmentedButtonTheme = SegmentedButtonThemeData(
  style: ButtonStyle(
    surfaceTintColor: MaterialStatePropertyAll(lightSelectedColor),
    visualDensity: VisualDensity.comfortable,
    overlayColor: MaterialStatePropertyAll(Colors.white),
    textStyle: MaterialStatePropertyAll(TextStyle(
      fontSize: 12,
      overflow: TextOverflow.ellipsis,
    )),
    side: MaterialStatePropertyAll(BorderSide(color: lightSelectedColor)),
    iconColor: MaterialStatePropertyAll(lightSelectedColor),
  ),
);

const _iconTheme = IconThemeData(color: lightPrimaryColor);

const _textButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    foregroundColor: MaterialStatePropertyAll(lightPrimaryColor),
    iconColor: MaterialStatePropertyAll(lightPrimaryColor),
    surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
    textStyle: MaterialStatePropertyAll(
      TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
);

final _elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: const MaterialStatePropertyAll(lightSelectedColor),
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 14)),
  ),
);

final _outlinedButtonTheme = OutlinedButtonThemeData(
  style: ButtonStyle(
    foregroundColor: const MaterialStatePropertyAll(lightSelectedColor),
    overlayColor: MaterialStatePropertyAll(Colors.grey[200]),
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    side: const MaterialStatePropertyAll(
      BorderSide(
        width: 2,
        color: lightSelectedColor,
      ),
    ),
    textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 14)),
  ),
);

const _inputDecorationTheme = InputDecorationTheme(
  floatingLabelStyle: TextStyle(color: lightPrimaryColor),
);

const _floatingActionButtonTheme = FloatingActionButtonThemeData(
  splashColor: Colors.transparent,
  foregroundColor: lightPrimaryColor,
  shape: RoundedRectangleBorder(
    side: BorderSide(color: lightPrimaryColor),
    borderRadius: BorderRadius.all(Radius.circular(15)),
  ),
);
