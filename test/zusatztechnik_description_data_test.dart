import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/dan_grades_data.dart';
import 'package:judo_app/data/zusatztechnik_description_data.dart';

void main() {
  test('findet eine Erklaerung trotz Suffix wie "(min. 3 Varianten)"', () {
    expect(
      findZusatztechnikDescription('Kata-te-jime (min. 4 Varianten)'),
      isNotNull,
    );
  });

  test('liefert null fuer unbekannte Techniken', () {
    expect(findZusatztechnikDescription('Voellig-erfundene-technik'), isNull);
  });

  test('deckt einen relevanten Teil der Zusatztechniken im 1.-3. Dan-'
      'Programm ab (nicht erschoepfend, da nicht jede Variante in den '
      'Quellen-Handbuechern beschrieben ist)', () {
    final dan1bis3 = judoDanGrades.where((g) => g.dan <= 3);
    final alleTechniken = dan1bis3.expand((g) => g.zusatztechniken);
    final mitErklaerung = alleTechniken.where(
      (t) => findZusatztechnikDescription(t) != null,
    );

    expect(mitErklaerung.length, greaterThan(10));
  });
}
