import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

ColorScheme darkColorScheme = ColorScheme.fromSeed(
  error: const Color(0xFFE57373),
  surface: const Color(0xFF1E1E1E),
  primary: Color(0xFF4285F4),
  onSurface: const Color(0xFFAAAAAA),
  seedColor: Color(0xFF1A73E8),
  onPrimary: ExtraColors.white,
  brightness: Brightness.dark,
  background: const Color(0xFF121212),
  onBackground: ExtraColors.white,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  focusColor: darkColorScheme.primary,
  colorScheme: darkColorScheme,
  splashColor: const Color(0xFF2C2C2C),
  useMaterial3: true,
  primaryTextTheme: const TextTheme(
    titleLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: ExtraColors.white,
    ),
  ),
  scaffoldBackgroundColor: darkColorScheme.surface,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: ExtraColors.white,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Roboto',
      color: ExtraColors.white,
      fontSize: 27.0,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.0,
    ),
  ),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.grey[900],
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: TextStyle(
      fontFamily: 'Roboto',
      color: ExtraColors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    color: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0.5,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14.0,
      color: Color(0xFF8B8B8B),
    ),
    labelStyle: const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14.0,
      color: Color(0xFF8B8B8B),
    ),
    focusColor: darkColorScheme.primary,
    errorMaxLines: 4,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
    prefixIconColor: ExtraColors.white,
    suffixIconColor: ExtraColors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Color(0xFF424242), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Color(0xFF424242), width: 1),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Color(0xFF424242), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Color(0xFF424242), width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(width: 1.5, color: Color(0xFFE57373)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(width: 1.5, color: Color(0xFFE57373)),
    ),
    errorStyle: const TextStyle(
      fontFamily: 'Roboto',
      color: Color(0xFFEF5350),
      fontSize: 13,
    ),
    filled: true,
    fillColor: const Color(0xFF2C2C2C),
    alignLabelWithHint: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      padding: const EdgeInsets.all(13.0),
      elevation: 0,
      alignment: Alignment.center,
      fixedSize: const Size(double.maxFinite, 50),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      enableFeedback: true,
      foregroundColor: ExtraColors.white,
      backgroundColor: darkColorScheme.primary,
      side: const BorderSide(width: 0, color: Colors.transparent),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      padding: const EdgeInsets.all(13.0),
      elevation: 0,
      alignment: Alignment.center,
      fixedSize: const Size(double.maxFinite, 50),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      enableFeedback: true,
      foregroundColor: darkColorScheme.primary,
      backgroundColor: ExtraColors.transparent,
      side: BorderSide(width: 1, color: darkColorScheme.primary),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    shadowColor: Colors.transparent,
    dragHandleColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    modalBarrierColor: Colors.transparent,
    modalBackgroundColor: Colors.transparent,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    },
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: const TextStyle(fontFamily: 'Roboto'),
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      foregroundColor: ExtraColors.white,
    ),
  ),
);
