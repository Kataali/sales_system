import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

ColorScheme lightColorScheme = ColorScheme.fromSeed(
  error: const Color(0xFFDD211F),
  surface: const Color(0xFFF5F5F5),
  primary: Color(0xFF0D47A1),
  onSurface: const Color(0xFF8B8B8B),
  seedColor: Color(0xFF1A73E8),
  onPrimary: ExtraColors.white,
  brightness: Brightness.light,
  background: ExtraColors.white,
  onBackground: ExtraColors.black,
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  focusColor: lightColorScheme.primary,
  colorScheme: lightColorScheme,
  splashColor: const Color(0xFFF5F5F5),
  useMaterial3: true,
  primaryTextTheme: const TextTheme(
    titleLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  scaffoldBackgroundColor: lightColorScheme.surface,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Roboto',
      color: ExtraColors.black,
      fontSize: 27.0,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.0,
    ),
  ),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white, // or your chosen color
      statusBarIconBrightness:
          Brightness.dark, // This will make the status bar icons dark
    ),

    // ... other properties
    titleTextStyle: TextStyle(
      fontFamily: 'Roboto',
      color: ExtraColors.black,
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
      color: ExtraColors.grey,
    ),
    labelStyle: const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14.0,
      color: ExtraColors.grey,
    ),
    focusColor: lightColorScheme.primary,
    errorMaxLines: 4,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
    prefixIconColor: ExtraColors.black,
    suffixIconColor: ExtraColors.black,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: ExtraColors.darkGrey, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: ExtraColors.darkGrey, width: 1),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: ExtraColors.darkGrey, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: ExtraColors.darkGrey, width: 1),
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
    filled: false,
    fillColor: lightColorScheme.surface,
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
      backgroundColor: lightColorScheme.primary,
      side: const BorderSide(width: 0, color: Colors.transparent),
      disabledBackgroundColor: ExtraColors.darkGrey,
      disabledForegroundColor: ExtraColors.grey,
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
      foregroundColor: lightColorScheme.primary,
      backgroundColor: ExtraColors.transparent,
      side: BorderSide(width: 1, color: lightColorScheme.primary),
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
      foregroundColor: ExtraColors.black,
    ),
  ),
);
