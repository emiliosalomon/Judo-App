import '../l10n/strings.dart';
import '../models/kata_info.dart';
import '../models/qa_entry.dart';
import 'anwendungsaufgabe_description_data.dart';
import 'kyu_grades_data.dart';
import 'rules_data.dart';
import 'technique_translations_data.dart';

/// App-weiter Frage-Antwort-Index fuer die KI-Suche: baut aus allen
/// bereits vorhandenen Inhalts-Datenquellen eine durchsuchbare, flache
/// Liste von [QaEntry] auf. Wird einmalig beim App-Start berechnet.
final List<QaEntry> judoQaIndex = _buildQaIndex();

List<QaEntry> _buildQaIndex() {
  final entries = <QaEntry>[];

  for (final grade in judoKyuGrades) {
    for (final theorie in grade.theorieThemen) {
      if (theorie.answer == null) continue;
      entries.add(
        QaEntry(
          question: theorie.question,
          answer: theorie.answer!,
          source: '${grade.title} – Theorie',
          targetType: QaTargetType.kyuGrade,
          kyuNumber: grade.kyu,
        ),
      );
    }
  }

  for (final topic in judoRulesTopics) {
    for (final section in topic.sections) {
      final parts = <String>[
        if (section.text != null) section.text!,
        ...section.bullets,
      ];
      final answer = parts.isEmpty
          ? AppStrings.rulesPendingNote
          : parts.join('\n');
      entries.add(
        QaEntry(
          question: section.title,
          answer: answer,
          source: 'Regelwerk – ${topic.title}',
          targetType: QaTargetType.rulesTopic,
          rulesTopicId: topic.id,
        ),
      );
    }
  }

  for (final info in judoKataInfos.values) {
    entries.add(
      QaEntry(
        question: 'Was ist die Kata ${info.name} (${info.meaning})?',
        answer: info.description,
        source: 'Kata',
        targetType: QaTargetType.kata,
        kataName: info.name,
      ),
    );
  }

  anwendungsaufgabeDescriptions.forEach((term, description) {
    entries.add(
      QaEntry(
        question: 'Was bedeutet „$term“?',
        answer: description,
        source: 'Standardsituationen',
      ),
    );
  });

  techniqueTranslationsDe.forEach((japanisch, deutsch) {
    entries.add(
      QaEntry(
        question: 'Was bedeutet $japanisch auf Deutsch?',
        answer: '$japanisch heißt auf Deutsch: $deutsch.',
        source: 'Technik-Übersetzung',
      ),
    );
  });

  // Dan-Grade sind hier bewusst nicht mit eigenen Fragen vertreten: sie
  // haben (anders als die Kyu-Stufen) kein eigenes theorieThemen-Programm
  // in den Datenquellen, siehe dan_grade.dart.

  return entries;
}
