/// Eine Dan-Meistergradstufe nach OeJV-Danordnung (1. bis 10. Dan).
class DanGrade {
  final int dan;
  final String beltDescription;
  final String? kata;
  final List<String> zusatztechniken;

  /// Kontertechnik-Ketten ("Angriff > Kontertechnik"), Anlage der
  /// Danordnung. Nur fuer Grade hinterlegt, bei denen die vollstaendige
  /// Liste (statt nur Beispielen) aus einer verlaesslichen Quelle vorliegt.
  final List<String> gonosenGaeshiWaza;

  /// Kombinationsketten ("Angriffstechnik > Zieltechnik"), Anlage der
  /// Danordnung. Nur fuer Grade hinterlegt, bei denen die vollstaendige
  /// Liste (statt nur Beispielen) aus einer verlaesslichen Quelle vorliegt.
  final List<String> renrakuRensokuWaza;

  /// Freitext-Hinweis, z.B. fuer Grade mit nur beispielhaften
  /// Kombinationsketten oder reduzierten Ueberpruefungs-Anforderungen.
  final String? hinweis;

  const DanGrade({
    required this.dan,
    required this.beltDescription,
    this.kata,
    this.zusatztechniken = const [],
    this.gonosenGaeshiWaza = const [],
    this.renrakuRensokuWaza = const [],
    this.hinweis,
  });

  String get title => '$dan. Dan';
}
