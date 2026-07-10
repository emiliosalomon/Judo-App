import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/anwendungsaufgabe_description_data.dart';
import 'package:judo_app/data/kyu_grades_data.dart';

void main() {
  test('jede Anwendungsaufgabe aus dem Kyu-Programm hat eine kuratierte '
      'Erklaerung', () {
    final missing = <String>{};
    for (final grade in judoKyuGrades) {
      for (final aufgabe in grade.anwendungsaufgaben) {
        if (findAnwendungsaufgabeDescription(aufgabe) == null) {
          missing.add(aufgabe);
        }
      }
    }
    expect(
      missing,
      isEmpty,
      reason: 'Fehlende Erklaerungen fuer: ${missing.join(', ')}',
    );
  });

  test('liefert null fuer unbekannte Eintraege', () {
    expect(findAnwendungsaufgabeDescription('Voellig unbekannt'), isNull);
  });
}
