import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/qa_index.dart';
import 'package:judo_app/data/qa_search.dart';
import 'package:judo_app/models/qa_entry.dart';

void main() {
  test(
    'judoQaIndex ist nicht leer und jeder Eintrag hat Frage und Antwort',
    () {
      expect(judoQaIndex, isNotEmpty);
      for (final entry in judoQaIndex) {
        expect(entry.question, isNotEmpty);
        expect(entry.answer, isNotEmpty);
        expect(entry.source, isNotEmpty);
      }
    },
  );

  test('searchQa findet einen Eintrag auch ohne exakte Schreibweise (Umlaute, '
      'Bindestriche)', () {
    final matches = searchQa('wie lang muss der guertel sein', judoQaIndex);

    expect(matches, isNotEmpty);
    expect(matches.first.entry.answer.toLowerCase(), contains('20'));
  });

  test('searchQa liefert leere Liste bei reiner Stoppwort-Anfrage', () {
    final matches = searchQa('was ist der und die', judoQaIndex);
    expect(matches, isEmpty);
  });

  test('searchQa liefert leere Liste, wenn nichts thematisch passt', () {
    final matches = searchQa('xyzxyzxyz123', judoQaIndex);
    expect(matches, isEmpty);
  });

  test('searchQa respektiert das uebergebene Limit', () {
    final matches = searchQa('waza', judoQaIndex, limit: 2);
    expect(matches.length, lessThanOrEqualTo(2));
  });

  test('searchQa sortiert Treffer absteigend nach Punktzahl', () {
    final matches = searchQa('kata gürtel regel technik', judoQaIndex);
    for (var i = 1; i < matches.length; i++) {
      expect(matches[i - 1].score, greaterThanOrEqualTo(matches[i].score));
    }
  });

  test('Kyu-Theoriefragen mit hinterlegter Antwort landen im Index', () {
    final matches = searchQa('was ist judo', judoQaIndex);
    expect(
      matches.any((m) => m.entry.targetType == QaTargetType.kyuGrade),
      isTrue,
    );
  });
}
