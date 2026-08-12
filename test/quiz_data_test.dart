import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/dan_grades_data.dart';
import 'package:judo_app/data/kyu_grades_data.dart';
import 'package:judo_app/data/quiz_data.dart';
import 'package:judo_app/data/technique_translations_data.dart';

void main() {
  test('generateQuestion liefert genau 3 unterschiedliche Optionen, '
      'darunter die richtige Antwort', () {
    final random = Random(1);
    for (final technique in quizTechniquePool) {
      final question = generateQuestion(technique, random);
      expect(question.options.length, 3);
      expect(question.options.toSet().length, 3);
      expect(question.options, contains(question.correctAnswer));
    }
  });

  test('generateQuestion mischt die Reihenfolge ueber mehrere Aufrufe', () {
    final random = Random(2);
    const technique = 'O-soto-gari';
    final positions = <int>{};
    for (var i = 0; i < 20; i++) {
      final question = generateQuestion(technique, random);
      positions.add(question.options.indexOf(question.correctAnswer));
    }
    // Bei 20 Versuchen sollte die richtige Antwort nicht immer an
    // derselben Position stehen (sonst waere es kein echtes Mischen).
    expect(positions.length, greaterThan(1));
  });

  test('pickQuizTechniques liefert die angeforderte Anzahl unterschiedlicher '
      'Techniken', () {
    final random = Random(3);
    final picked = pickQuizTechniques(10, random);
    expect(picked.length, 10);
    expect(picked.toSet().length, 10);
    for (final technique in picked) {
      expect(quizTechniquePool, contains(technique));
    }
  });

  test('generateQuestion beschraenkt falsche Antwortmoeglichkeiten auf den '
      'uebergebenen Pool, wenn einer angegeben ist', () {
    final random = Random(4);
    // Kleiner, klar definierter Pool: nur die Uebersetzungen dieser drei
    // Techniken duerfen als Antwortmoeglichkeit auftauchen.
    final pool = ['O-soto-gari', 'O-uchi-gari', 'Ko-soto-gari'];
    final allowedTranslations = pool
        .map((t) => techniqueTranslationsDe[t])
        .toSet();
    for (var i = 0; i < 10; i++) {
      final question = generateQuestion('O-soto-gari', random, pool: pool);
      for (final option in question.options) {
        expect(allowedTranslations, contains(option));
      }
    }
  });

  test('techniquesOfKyuGrade findet die Techniken einer einfachen Kyu-Stufe '
      '(10. Kyu: Uki-goshi, O-soto-otoshi)', () {
    final grade = judoKyuGrades.firstWhere((g) => g.kyu == 10);
    expect(
      techniquesOfKyuGrade(grade),
      containsAll(['Uki-goshi', 'O-soto-otoshi']),
    );
  });

  test(
    'techniquesOfKyuGrade findet "O-uchi (Barai/Gari)"/"Ko-uchi (Barai/Gari)" '
    '(6. Kyu) trotz der Klammer-Schreibweise, die kein reiner '
    'Teilstring-Treffer waere',
    () {
      final grade = judoKyuGrades.firstWhere((g) => g.kyu == 6);
      expect(
        techniquesOfKyuGrade(grade),
        containsAll(['O-uchi-gari', 'Ko-uchi-gari']),
      );
    },
  );

  test('techniquesOfDanGrade findet Zusatztechniken trotz Suffix wie '
      '"(min. 3 Varianten)"', () {
    final grade = judoDanGrades.firstWhere((g) => g.dan == 1);
    expect(grade.zusatztechniken, isNotEmpty);
    expect(techniquesOfDanGrade(grade), isNotEmpty);
  });

  test('quizTechniquesWithoutGrade und die Kyu-/Dan-Zuordnungen ueber­'
      'schneiden sich nicht (jede Technik gehoert hoechstens zu einer '
      'Kategorie: einer Guertelstufe oder "sonstige")', () {
    final assigned = <String>{
      for (final grade in judoKyuGrades) ...techniquesOfKyuGrade(grade),
      for (final grade in judoDanGrades) ...techniquesOfDanGrade(grade),
    };
    expect(assigned.intersection(quizTechniquesWithoutGrade), isEmpty);
    // Zusammen ergeben beide Gruppen wieder den gesamten Quiz-Pool.
    expect(
      assigned.union(quizTechniquesWithoutGrade),
      quizTechniquePool.toSet(),
    );
  });

  test('quizPoolForGrades liefert die Vereinigung der ausgewaehlten '
      'Guertelstufen (und ist leer, wenn nichts ausgewaehlt ist)', () {
    expect(quizPoolForGrades({}), isEmpty);

    final grade10 = judoKyuGrades.firstWhere((g) => g.kyu == 10);
    final grade9 = judoKyuGrades.firstWhere((g) => g.kyu == 9);
    final pool = quizPoolForGrades({grade10.title, grade9.title});
    expect(
      pool.toSet(),
      techniquesOfKyuGrade(grade10).union(techniquesOfKyuGrade(grade9)),
    );
  });

  test('quizDefaultGradeSelection enthaelt alle Kyu-Stufen mit eigenem '
      'Technikprogramm, aber keine Dan-Stufen', () {
    final selection = quizDefaultGradeSelection;
    for (final grade in judoKyuGrades) {
      if (techniquesOfKyuGrade(grade).isNotEmpty) {
        expect(selection, contains(grade.title));
      }
    }
    for (final grade in judoDanGrades) {
      expect(selection, isNot(contains(grade.title)));
    }
  });
}
