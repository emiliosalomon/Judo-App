/// Eine Theorie-Frage mit Antwort, fuers Karteikarten-Lernprinzip
/// (antippen zeigt die Antwort, nochmal antippen blendet sie wieder aus).
class TheoryQuestion {
  final String question;

  /// null = Antwort noch nicht hinterlegt (z.B. OeJV/Oesterreich-spezifische
  /// Details, die nicht ohne verlaessliche Quelle geraten werden sollen).
  final String? answer;

  const TheoryQuestion({required this.question, this.answer});
}
