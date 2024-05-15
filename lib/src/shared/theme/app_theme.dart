import 'package:bookify/src/shared/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Theme for light mode
final appLightTheme = ThemeData(
  appBarTheme: _appBarTheme.copyWith(
    systemOverlayStyle: const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    ),
  ),
  textSelectionTheme: _textSelectionTheme,
  progressIndicatorTheme: _progressIndicatorTheme,
  textTheme: _textTheme,
  searchBarTheme: _searchBarTheme,
  segmentedButtonTheme: _segmentedButtonTheme,
  splashColor: Colors.transparent,
  iconTheme: _iconTheme,
  sliderTheme: _sliderTheme,
  radioTheme: _radioTheme,
  textButtonTheme: _textButtonTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  outlinedButtonTheme: _outlinedButtonTheme,
  inputDecorationTheme: _inputDecorationTheme,
  floatingActionButtonTheme:
      _floatingActionButtonTheme.copyWith(backgroundColor: Colors.white),
  disabledColor: AppColor.bookifyDisabledColor,
  colorScheme: const ColorScheme.light(
    primary: AppColor.bookifyPrimaryColor,
    secondary: AppColor.bookifySecondaryColor,
    tertiary: AppColor.bookifyTertiaryColor,
    error: AppColor.bookifyErrorColor,
  ),
);

/// Theme for dark mode
final appDarkTheme = ThemeData(
  appBarTheme: _appBarTheme.copyWith(
    systemOverlayStyle: const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColor.bookifyDarkBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: AppColor.bookifyDarkBackgroundColor,
      statusBarIconBrightness: Brightness.light, // For Android (light icons)
      statusBarBrightness: Brightness.dark, // For iOS (light icons)
    ),
  ),
  textSelectionTheme: _textSelectionTheme,
  progressIndicatorTheme: _progressIndicatorTheme,
  textTheme: _textTheme,
  searchBarTheme: _searchBarTheme,
  segmentedButtonTheme: _segmentedButtonTheme,
  splashColor: Colors.transparent,
  iconTheme: _iconTheme,
  sliderTheme: _sliderTheme,
  radioTheme: _radioTheme,
  textButtonTheme: _textButtonTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  outlinedButtonTheme: _outlinedButtonTheme,
  inputDecorationTheme: _inputDecorationTheme,
  floatingActionButtonTheme: _floatingActionButtonTheme.copyWith(
    backgroundColor: AppColor.bookifyDarkBackgroundColor,
  ),
  disabledColor: AppColor.bookifyDisabledColor,
  colorScheme: const ColorScheme.dark(
    primary: AppColor.bookifyPrimaryColor,
    secondary: AppColor.bookifySecondaryColor,
    tertiary: AppColor.bookifyTertiaryColor,
    error: AppColor.bookifyErrorColor,
    surface: AppColor.bookifyDarkBackgroundColor,
  ),
);

// Theme Components

/// Invisible appBar
const _appBarTheme = AppBarTheme(
  backgroundColor: Colors.transparent,
  shadowColor: Colors.transparent,
  surfaceTintColor: Colors.transparent,
  iconTheme: IconThemeData(
    color: AppColor.bookifySecondaryColor,
  ),
);

const _progressIndicatorTheme = ProgressIndicatorThemeData(
  color: AppColor.bookifySecondaryColor,
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
  cursorColor: AppColor.bookifyPrimaryColor,
  selectionColor: AppColor.bookifyPrimaryColor,
);

const _searchBarTheme = SearchBarThemeData(
  side: WidgetStatePropertyAll(
    BorderSide(color: AppColor.bookifySecondaryColor),
  ),
  elevation: WidgetStatePropertyAll(0),
  padding: WidgetStatePropertyAll(
    EdgeInsets.symmetric(horizontal: 16),
  ),
  textStyle: WidgetStatePropertyAll(
    TextStyle(
      fontSize: 14,
    ),
  ),
  hintStyle: WidgetStatePropertyAll(
    TextStyle(
      fontSize: 14,
      color: AppColor.bookifySecondaryColor,
    ),
  ),
);

const _segmentedButtonTheme = SegmentedButtonThemeData(
  style: ButtonStyle(
    surfaceTintColor: WidgetStatePropertyAll(AppColor.bookifySecondaryColor),
    visualDensity: VisualDensity.comfortable,
    textStyle: WidgetStatePropertyAll(
      TextStyle(
        fontSize: 12,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    side: WidgetStatePropertyAll(
        BorderSide(color: AppColor.bookifySecondaryColor)),
    iconColor: WidgetStatePropertyAll(AppColor.bookifySecondaryColor),
  ),
);

const _iconTheme = IconThemeData(color: AppColor.bookifyPrimaryColor);

final _sliderTheme = SliderThemeData(
  trackHeight: 2.0,
  activeTrackColor: AppColor.bookifyPrimaryColor,
  inactiveTrackColor: AppColor.bookifyPrimaryColor.withOpacity(.10),
  disabledActiveTrackColor: AppColor.bookifyPrimaryColor,
  disabledInactiveTrackColor: AppColor.bookifyPrimaryColor.withOpacity(.10),
  trackShape: const RoundedRectSliderTrackShape(),
  tickMarkShape: SliderTickMarkShape.noTickMark,
  overlayShape: SliderComponentShape.noOverlay,
  valueIndicatorTextStyle: const TextStyle(fontSize: 14),
  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
  thumbShape: const RoundSliderThumbShape(),
  thumbColor: AppColor.bookifySecondaryColor,
  disabledThumbColor: AppColor.bookifySecondaryColor,
  valueIndicatorColor: AppColor.bookifySecondaryColor,
);

const _radioTheme = RadioThemeData(
    fillColor: WidgetStatePropertyAll(
      AppColor.bookifySecondaryColor,
    ),
    overlayColor: WidgetStatePropertyAll(
      AppColor.bookifySecondaryColor,
    ));

const _textButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    foregroundColor: WidgetStatePropertyAll(
      AppColor.bookifyPrimaryColor,
    ),
    iconColor: WidgetStatePropertyAll(
      AppColor.bookifyPrimaryColor,
    ),
    textStyle: WidgetStatePropertyAll(
      TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);

final _elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: const WidgetStatePropertyAll(
      AppColor.bookifySecondaryColor,
    ),
    foregroundColor: const WidgetStatePropertyAll(Colors.white),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
    ),
    iconColor: const WidgetStatePropertyAll(
      Colors.white,
    ),
    textStyle: const WidgetStatePropertyAll(
      TextStyle(
        fontSize: 14,
      ),
    ),
  ),
);

final _outlinedButtonTheme = OutlinedButtonThemeData(
  style: ButtonStyle(
    foregroundColor: const WidgetStatePropertyAll(
      AppColor.bookifySecondaryColor,
    ),
    overlayColor: WidgetStatePropertyAll(Colors.grey[200]),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    side: const WidgetStatePropertyAll(
      BorderSide(
        width: 2,
        color: AppColor.bookifySecondaryColor,
      ),
    ),
    iconColor: const WidgetStatePropertyAll(AppColor.bookifySecondaryColor),
    textStyle: const WidgetStatePropertyAll(
      TextStyle(
        fontSize: 14,
        color: AppColor.bookifySecondaryColor,
      ),
    ),
  ),
);

final _inputDecorationTheme = InputDecorationTheme(
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: AppColor.bookifySecondaryColor,
    ),
  ),
  disabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: AppColor.bookifyDisabledColor,
    ),
  ),
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: AppColor.bookifyPrimaryColor,
    ),
  ),
  errorBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: AppColor.bookifyErrorColor,
    ),
  ),
  focusedErrorBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColor.bookifyErrorColor,
    ),
  ),
  errorStyle: const TextStyle(
    fontSize: 12,
    color: AppColor.bookifyErrorColor,
  ),
  labelStyle: WidgetStateTextStyle.resolveWith(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.focused)) {
        return const TextStyle(
          color: AppColor.bookifySecondaryColor,
          fontSize: 14,
        );
      } else if (states.contains(WidgetState.disabled)) {
        return const TextStyle(
          color: AppColor.bookifyDisabledColor,
          fontSize: 14,
        );
      } else if (states.contains(WidgetState.error)) {
        return const TextStyle(
          color: AppColor.bookifyErrorColor,
          fontSize: 14,
        );
      }

      return const TextStyle(
        color: AppColor.bookifyPrimaryColor,
        fontSize: 14,
      );
    },
  ),
  floatingLabelStyle: WidgetStateTextStyle.resolveWith(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.focused)) {
        return const TextStyle(
          color: AppColor.bookifySecondaryColor,
          fontSize: 14,
        );
      } else if (states.contains(WidgetState.disabled)) {
        return const TextStyle(
          color: AppColor.bookifyDisabledColor,
          fontSize: 14,
        );
      } else if (states.contains(WidgetState.error)) {
        return const TextStyle(
          color: AppColor.bookifyErrorColor,
          fontSize: 14,
        );
      }

      return const TextStyle(
        color: AppColor.bookifyPrimaryColor,
        fontSize: 14,
      );
    },
  ),
);

const _floatingActionButtonTheme = FloatingActionButtonThemeData(
  splashColor: Colors.transparent,
  foregroundColor: AppColor.bookifyPrimaryColor,
  shape: RoundedRectangleBorder(
    side: BorderSide(color: AppColor.bookifyPrimaryColor),
    borderRadius: BorderRadius.all(Radius.circular(15)),
  ),
);
