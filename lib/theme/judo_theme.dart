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
      fontSize: 30,
      fontWeight: FontWeight.w900,
      color: JudoColors.white,
    ),
  ),
  // Nochmal deutlich groessere, fettere, verspieltere Schrift - maximal
  // jugendfreundlich statt nuechtern-erwachsen.
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
    titleMedium: TextStyle(fontSize: 29, fontWeight: FontWeight.w800),
    titleSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
    bodyLarge: TextStyle(fontSize: 26, height: 1.3),
    bodyMedium: TextStyle(fontSize: 22, height: 1.3),
    bodySmall: TextStyle(fontSize: 19, height: 1.25),
    labelLarge: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
  ),
  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
    subtitleTextStyle: TextStyle(fontSize: 18),
  ),
  // Runde, verspielte Formen statt scharfer Kanten.
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    elevation: 0,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
    ),
  ),
  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  ),
  checkboxTheme: CheckboxThemeData(
    materialTapTargetSize: MaterialTapTargetSize.padded,
    side: const BorderSide(color: JudoColors.black, width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  ),
);
