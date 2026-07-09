/// Eine Dan-Meistergradstufe nach OeJV-Danordnung (1. bis 10. Dan).
class DanGrade {
  final int dan;
  final String beltDescription;
  final String? kata;
  final List<String> zusatztechniken;

  /// Freitext-Hinweis, z.B. fuer Grade mit nur beispielhaften
  /// Kombinationsketten oder reduzierten Ueberpruefungs-Anforderungen.
  final String? hinweis;

  const DanGrade({
    required this.dan,
    required this.beltDescription,
    this.kata,
    this.zusatztechniken = const [],
    this.hinweis,
  });

  String get title => '$dan. Dan';
}
