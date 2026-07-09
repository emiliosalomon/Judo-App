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
  ),
);
