/// Eine Kyu-Guertelstufe nach OeJV-Pruefungsprogramm (11. bis 1. Kyu).
class KyuGrade {
  final int kyu;
  final String beltName;
  final int? minAge;
  final List<String> ukemiWaza;
  final List<String> nageWaza;
  final List<String> katameWaza;
  final List<String> anwendungsaufgaben;
  final List<String> theorieThemen;
  final List<String> zusatzbegriffe;

  /// Freitext-Hinweis fuer Grade ohne eigenes Technikprogramm (z.B. 11. Kyu).
  final String? hinweis;

  const KyuGrade({
    required this.kyu,
    required this.beltName,
    this.minAge,
    this.ukemiWaza = const [],
    this.nageWaza = const [],
    this.katameWaza = const [],
    this.anwendungsaufgaben = const [],
    this.theorieThemen = const [],
    this.zusatzbegriffe = const [],
    this.hinweis,
  });

  String get title => '$kyu. Kyu – $beltName';
}
