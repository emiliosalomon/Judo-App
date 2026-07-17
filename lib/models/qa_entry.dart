/// Zu welchem Bildschirm ein [QaEntry] bei Bedarf weiterleiten kann, um
/// mehr Kontext zu zeigen als die kurze Antwort auf der Suchseite selbst.
enum QaTargetType { none, kyuGrade, rulesTopic, kata }

/// Ein durchsuchbarer Frage-Antwort-Eintrag fuer die KI-Suche: buendelt
/// Inhalte aus allen bestehenden Datenquellen (Kyu-Theoriefragen,
/// Regelwerk, Kata, Standardsituationen, Technik-Uebersetzungen) in ein
/// einheitliches Format, das per Volltext-Abgleich durchsucht werden kann
/// (siehe qa_search.dart).
class QaEntry {
  final String question;
  final String answer;
  final String source;
  final QaTargetType targetType;

  /// Kyu-Nummer, wenn [targetType] == kyuGrade.
  final int? kyuNumber;

  /// RulesTopic-Id, wenn [targetType] == rulesTopic.
  final String? rulesTopicId;

  /// Kata-Name (Schluessel in judoKataInfos), wenn [targetType] == kata.
  final String? kataName;

  const QaEntry({
    required this.question,
    required this.answer,
    required this.source,
    this.targetType = QaTargetType.none,
    this.kyuNumber,
    this.rulesTopicId,
    this.kataName,
  });
}
