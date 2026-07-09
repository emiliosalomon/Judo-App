import 'package:flutter/material.dart';

class JudoColors {
  static const red = Color(0xFFC8102E);
  static const black = Color(0xFF1A1A1A);
  static const white = Color(0xFFFFFFFF);
  // Judogi-Blau fuer die Logo-Illustration (Tori-Kimono).
  static const blue = Color(0xFF1565C0);
  // Akzentfarben nur fuer Belohnungs-Symbole (Sterne/Pokale/Serie) -
  // klassische Medaillen-/Trophaeen-Farben, kein neues Markenfarbschema.
  static const gold = Color(0xFFFFB300);
  static const flame = Color(0xFFFF7A1A);
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
      fontSize: 26,
      fontWeight: FontWeight.w900,
      color: JudoColors.white,
    ),
  ),
  // Deutlich groessere, fettere, verspieltere Schrift - jugendfreundlicher
  // als das Material-Default.
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
    titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
    titleSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
    bodyLarge: TextStyle(fontSize: 22, height: 1.35),
    bodyMedium: TextStyle(fontSize: 19, height: 1.35),
    bodySmall: TextStyle(fontSize: 17, height: 1.3),
    labelLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
  ),
  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
    subtitleTextStyle: TextStyle(fontSize: 16),
  ),
  // Runde, verspielte Formen statt scharfer Kanten.
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 0,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
    ),
  ),
  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);
