import 'dart:math';

import '../models/dan_grade.dart';
import '../models/kyu_grade.dart';
import 'dan_grades_data.dart';
import 'fuzzy_technique_match.dart';
import 'kyu_grades_data.dart';
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

/// Waza-Gruppe von [technique] (nur die Teilmenge, die auch in [pool]
/// enthalten ist), oder [pool] selbst als Fallback (z.B. fuer
/// Dan-Zusatztechniken, die in keiner der offiziellen Gokyo-Listen einzeln
/// aufgefuehrt sind).
List<String> _familyOf(String technique, List<String> pool) {
  for (final family in _families) {
    if (family.contains(technique)) {
      final inPool = family.where(pool.contains).toList();
      return inPool.isEmpty ? pool : inPool;
    }
  }
  return pool;
}

/// Baut eine Quiz-Frage zu [technique]: die richtige Uebersetzung plus zwei
/// falsche, bevorzugt aus derselben Waza-Gruppe (damit die falschen
/// Antworten plausibel bleiben statt offensichtlich falsch zu sein),
/// zufaellig gemischt. Falsche Antworten kommen nur aus [pool] (Standard:
/// der gesamte Katalog) - so tauchen z.B. bei einer auf niedrige Kyu-Grade
/// eingeschraenkten Runde keine Uebersetzungen fortgeschrittener Techniken
/// als Antwortmoeglichkeit auf.
QuizQuestion generateQuestion(
  String technique,
  Random random, {
  List<String>? pool,
}) {
  final effectivePool = pool ?? quizTechniquePool;
  final correct = techniqueTranslationsDe[technique]!;

  List<String> distractorsFrom(Iterable<String> source) =>
      (source
              .where((t) => t != technique && effectivePool.contains(t))
              .map((t) => techniqueTranslationsDe[t])
              .whereType<String>()
              .where((translation) => translation != correct)
              .toSet()
              .toList()
            ..shuffle(random))
          .toList();

  var distractors = distractorsFrom(
    _familyOf(technique, effectivePool),
  ).take(2).toList();
  if (distractors.length < 2) {
    final fallback = distractorsFrom(
      effectivePool,
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

/// Zieht [count] zufaellige, unterschiedliche Techniken aus [pool]
/// (Standard: der gesamte Katalog) fuer eine Quiz-Runde.
List<String> pickQuizTechniques(
  int count,
  Random random, {
  List<String>? pool,
}) {
  final shuffled = (pool ?? quizTechniquePool).toList()..shuffle(random);
  return shuffled.take(count).toList();
}

/// Kyu-Programmpunkte, die per Klammer-Schreibweise zwei Techniken auf
/// einmal benennen (z.B. "O-uchi (Barai/Gari)") - der reine Teilstring-
/// Abgleich faende hier keinen Treffer, da "O-uchi-gari" nicht Wort fuer
/// Wort in "O-uchi (Barai/Gari)" vorkommt (derselbe Fall wie bei den
/// kuratierten Video-Links in technique_video_data.dart).
const _combinedGradeEntrySynonyms = <String, List<String>>{
  'O-uchi (Barai/Gari)': ['O-uchi-gari'],
  'Ko-uchi (Barai/Gari)': ['Ko-uchi-gari'],
};

Set<String> _matchesForRawEntry(String raw) {
  final synonym = _combinedGradeEntrySynonyms[raw];
  if (synonym != null) return synonym.toSet();
  return findAllTechniqueMatches(raw, quizTechniquePool);
}

/// Alle quizbaren Techniken (siehe [quizTechniquePool]), die zum
/// OeJV-Pruefungsprogramm von [grade] gehoeren.
Set<String> techniquesOfKyuGrade(KyuGrade grade) => {
  for (final raw in [...grade.nageWaza, ...grade.katameWaza])
    ..._matchesForRawEntry(raw),
};

/// Alle quizbaren Techniken, die zu den Zusatztechniken von [grade]
/// gehoeren.
Set<String> techniquesOfDanGrade(DanGrade grade) => {
  for (final raw in grade.zusatztechniken) ..._matchesForRawEntry(raw),
};

/// Sammel-Auswahl fuer Techniken, die keinem einzelnen Kyu-/Dan-Programm
/// zugeordnet werden konnten (z.B. Kata-spezifische Techniken oder
/// weiterfuehrende Gokyo-Techniken ohne eigenen Kyu-/Dan-Programmpunkt) -
/// eigene, separat auswaehlbare Kategorie, statt bei jeder Gruppenauswahl
/// automatisch mit dabei zu sein.
const quizOtherCategoryLabel = 'Weiterführend / Kata';

Set<String> get quizTechniquesWithoutGrade {
  final assigned = <String>{
    for (final grade in judoKyuGrades) ...techniquesOfKyuGrade(grade),
    for (final grade in judoDanGrades) ...techniquesOfDanGrade(grade),
  };
  return quizTechniquePool.toSet().difference(assigned);
}

/// Alle auswaehlbaren Gruppen-Labels fuer die Guertelstufen-Auswahl, in
/// Anzeige-Reihenfolge (Kyu absteigend, dann Dan aufsteigend, dann
/// Sonstiges) - Stufen ohne eigenes Technikprogramm (z.B. 11. Kyu) werden
/// ausgelassen, da eine Auswahl dort keine Wirkung haette.
List<String> get quizGradeLabels => [
  for (final grade in judoKyuGrades)
    if (techniquesOfKyuGrade(grade).isNotEmpty) grade.title,
  for (final grade in judoDanGrades)
    if (techniquesOfDanGrade(grade).isNotEmpty) grade.title,
  if (quizTechniquesWithoutGrade.isNotEmpty) quizOtherCategoryLabel,
];

/// Standardauswahl beim ersten Oeffnen des Quiz: alle Kyu-Stufen (das
/// gesamte Schuelergrad-Programm), aber keine Dan-Zusatztechniken oder
/// Kata-Techniken - Anfaenger sollen nicht ungefragt mit Pruefungsstoff
/// hoeherer Grade konfrontiert werden.
Set<String> get quizDefaultGradeSelection => {
  for (final grade in judoKyuGrades)
    if (techniquesOfKyuGrade(grade).isNotEmpty) grade.title,
};

/// Baut den Quiz-Pool aus den ausgewaehlten Guertelstufen-/Kategorie-Labels
/// (siehe [quizGradeLabels]).
List<String> quizPoolForGrades(Set<String> selectedLabels) {
  final pool = <String>{};
  for (final grade in judoKyuGrades) {
    if (selectedLabels.contains(grade.title)) {
      pool.addAll(techniquesOfKyuGrade(grade));
    }
  }
  for (final grade in judoDanGrades) {
    if (selectedLabels.contains(grade.title)) {
      pool.addAll(techniquesOfDanGrade(grade));
    }
  }
  if (selectedLabels.contains(quizOtherCategoryLabel)) {
    pool.addAll(quizTechniquesWithoutGrade);
  }
  return pool.toList();
}
