import 'dart:math';

import 'technique_translations_data.dart';
import 'techniques_data.dart';

/// Eine einzelne Quiz-Frage: japanischer Technik-Name als Frage, drei
/// deutsche Uebersetzungen als Antwortmoeglichkeiten (davon eine richtig).
class QuizQuestion {
  final String technique;
  final String correctAnswer;
  final List<String> options;

  const QuizQuestion({
    required this.technique,
    required this.correctAnswer,
    required this.options,
  });
}

/// Alle Techniken, fuer die eine deutsche Uebersetzung hinterlegt ist -
/// die Grundmenge, aus der Quiz-Fragen gezogen werden.
List<String> get quizTechniquePool => techniqueTranslationsDe.keys.toList();

/// Waza-Gruppen aus dem offiziellen Technik-Katalog, um bei einer Frage
/// plausible (verwandte), aber falsche Antwortmoeglichkeiten zu waehlen -
/// statt komplett zufaelliger Uebersetzungen aus einer ganz anderen
/// Technik-Familie.
const _families = <List<String>>[
  kodokanGokyoNageWaza,
  osaeKomiWaza,
  shimeWaza,
  kansetsuWaza,
];

/// Waza-Gruppe von [technique], oder der gesamte Pool als Fallback (z.B.
/// fuer Dan-Zusatztechniken, die in keiner der offiziellen Gokyo-Listen
/// einzeln aufgefuehrt sind).
List<String> _familyOf(String technique) {
  for (final family in _families) {
    if (family.contains(technique)) return family;
  }
  return quizTechniquePool;
}

/// Baut eine Quiz-Frage zu [technique]: die richtige Uebersetzung plus zwei
/// falsche, bevorzugt aus derselben Waza-Gruppe (damit die falschen
/// Antworten plausibel bleiben statt offensichtlich falsch zu sein),
/// zufaellig gemischt.
QuizQuestion generateQuestion(String technique, Random random) {
  final correct = techniqueTranslationsDe[technique]!;

  List<String> distractorsFrom(Iterable<String> source) =>
      (source
              .where((t) => t != technique)
              .map((t) => techniqueTranslationsDe[t])
              .whereType<String>()
              .where((translation) => translation != correct)
              .toSet()
              .toList()
            ..shuffle(random))
          .toList();

  var distractors = distractorsFrom(_familyOf(technique)).take(2).toList();
  if (distractors.length < 2) {
    final fallback = distractorsFrom(
      quizTechniquePool,
    ).where((t) => !distractors.contains(t));
    distractors = [...distractors, ...fallback].take(2).toList();
  }

  final options = [correct, ...distractors]..shuffle(random);
  return QuizQuestion(
    technique: technique,
    correctAnswer: correct,
    options: options,
  );
}

/// Zieht [count] zufaellige, unterschiedliche Techniken aus dem Quiz-Pool
/// fuer eine Quiz-Runde.
List<String> pickQuizTechniques(int count, Random random) {
  final shuffled = quizTechniquePool.toList()..shuffle(random);
  return shuffled.take(count).toList();
}
