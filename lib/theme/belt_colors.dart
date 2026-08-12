import 'package:flutter/material.dart';

/// Guertelfarben (OeJV-Kyu-Programm + Dan) als Anzeigefarben. Zweifarbige
/// Guertel (z.B. "Weiß-Gelb") liefern zwei Farben fuer eine geteilte
/// Darstellung, einfarbige nur eine.
class BeltColors {
  static const weiss = Color(0xFFF5F5F5);
  static const gelb = Color(0xFFFFD500);
  static const orange = Color(0xFFFF8A00);
  static const gruen = Color(0xFF2E9E4C);
  static const blau = Color(0xFF1565C0);
  static const braun = Color(0xFF6D4C25);
  static const schwarz = Color(0xFF1A1A1A);
  static const rot = Color(0xFFC8102E);

  static const _byName = <String, Color>{
    'weiß': weiss,
    'weiss': weiss,
    'gelb': gelb,
    'orange': orange,
    'grün': gruen,
    'gruen': gruen,
    'blau': blau,
    'braun': braun,
    'schwarz': schwarz,
    'rot': rot,
  };

  BeltColors._();
}

/// Zerlegt einen Guertelnamen wie "Weiß-Gelb" oder "Weiß (Sonne)" in seine
/// 1-2 Anzeigefarben. Unbekannte/unparsbare Namen liefern Grau als Fallback.
List<Color> beltColorsFromName(String name) {
  final withoutSuffix = name.split('(').first.trim();
  final parts = withoutSuffix
      .split('-')
      .map((p) => p.trim().toLowerCase())
      .where((p) => p.isNotEmpty);
  final colors = [
    for (final part in parts)
      if (BeltColors._byName[part] != null) BeltColors._byName[part]!,
  ];
  if (colors.isEmpty) return const [Color(0xFF9E9E9E)];
  return colors;
}
