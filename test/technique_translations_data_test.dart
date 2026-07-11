import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/dan_grades_data.dart';
import 'package:judo_app/data/kyu_grades_data.dart';
import 'package:judo_app/data/technique_translations_data.dart';
import 'package:judo_app/data/techniques_data.dart';
import 'package:judo_app/models/kata_info.dart';

void main() {
  test('jede Gokyo-Technik (Nage-/Osae-komi-/Shime-/Kansetsu-waza) hat eine '
      'deutsche Uebersetzung', () {
    final missing = <String>{};
    for (final technique in [
      ...kodokanGokyoNageWaza,
      ...osaeKomiWaza,
      ...shimeWaza,
      ...kansetsuWaza,
    ]) {
      if (translateTechnique(technique) == null) missing.add(technique);
    }
    expect(
      missing,
      isEmpty,
      reason: 'Fehlende Uebersetzungen fuer: ${missing.join(', ')}',
    );
  });

  test('jede Nage-/Katame-waza-Technik aus dem Kyu-Programm findet eine '
      'deutsche Uebersetzung (auch mit Suffixen wie " RL")', () {
    final missing = <String>{};
    for (final grade in judoKyuGrades) {
      for (final technique in [...grade.nageWaza, ...grade.katameWaza]) {
        // "Prinzip „..."" sind schon eingedeutschte Konzeptnamen, keine
        // reinen Technik-Namen - fuer die gilt keine Uebersetzungspflicht.
        if (technique.startsWith('Prinzip')) continue;
        if (translateTechnique(technique) == null) missing.add(technique);
      }
    }
    expect(
      missing,
      isEmpty,
      reason: 'Fehlende Uebersetzungen fuer: ${missing.join(', ')}',
    );
  });

  test('jede Dan-Zusatztechnik findet eine deutsche Uebersetzung (auch mit '
      'Suffixen wie "(min. 3 Varianten)")', () {
    final missing = <String>{};
    for (final grade in judoDanGrades) {
      for (final technique in grade.zusatztechniken) {
        if (translateTechnique(technique) == null) missing.add(technique);
      }
    }
    expect(
      missing,
      isEmpty,
      reason: 'Fehlende Uebersetzungen fuer: ${missing.join(', ')}',
    );
  });

  test('jede einzeln aufgezaehlte Kata-Technik findet eine deutsche '
      'Uebersetzung', () {
    final missing = <String>{};
    for (final kata in judoKataInfos.values) {
      for (final section in kata.sections) {
        for (final technique in section.techniques) {
          if (translateTechnique(technique) == null) missing.add(technique);
        }
      }
    }
    expect(
      missing,
      isEmpty,
      reason: 'Fehlende Uebersetzungen fuer: ${missing.join(', ')}',
    );
  });

  test('liefert null fuer Anwendungsaufgaben-Beschreibungen statt einer '
      'irrefuehrenden Teilstring-Uebersetzung', () {
    expect(translateTechnique('Kombination O-uchi/Ko-uchi'), isNull);
    expect(translateTechnique('Befreiung aus Ura-gatame'), isNull);
    expect(translateTechnique('Nage-waza → Osae-komi-waza'), isNull);
  });

  test('liefert null fuer bereits deutsche Ukemi-waza-Bezeichnungen', () {
    expect(translateTechnique('Fall rückwärts (Stand)'), isNull);
  });

  test('liefert null fuer unbekannte Eintraege', () {
    expect(translateTechnique('Voellig unbekannt'), isNull);
  });
}
