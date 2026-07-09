import 'package:flutter/material.dart';

class JudoColors {
  static const red = Color(0xFFC8102E);
  static const black = Color(0xFF1A1A1A);
  static const white = Color(0xFFFFFFFF);
  // Judogi-Blau fuer die Logo-Illustration (Tori-Kimono).
  static const blue = Color(0xFF1565C0);
}

final judoTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: JudoColors.red,
    primary: JudoColors.red,
    onPrimary: JudoColors.white,
    secondary: JudoColors.black,
    surface: JudoColors.white,
  ),
  scaffoldBackgroundColor: JudoColors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: JudoColors.black,
    foregroundColor: JudoColors.white,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: JudoColors.white,
    ),
  ),
  // Groessere, fettere Schrift fuer bessere Lesbarkeit (auch fuer juengere
  // Nutzer) als das Material-Default.
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
    titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    titleSmall: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
    bodyLarge: TextStyle(fontSize: 19, height: 1.35),
    bodyMedium: TextStyle(fontSize: 17, height: 1.35),
    bodySmall: TextStyle(fontSize: 15, height: 1.3),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  ),
  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    subtitleTextStyle: TextStyle(fontSize: 14),
  ),
);
