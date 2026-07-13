import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/technique_media_data.dart';

void main() {
  test('findTechniqueImage findet Treffer trotz Suffixen wie " RL"', () {
    expect(findTechniqueImage('O-soto-gari RL'), isNotNull);
    expect(findTechniqueImage('Tai-otoshi RL'), isNotNull);
    expect(
      findTechniqueImage('Hiza-guruma oder Sasae-tsuri-komi-ashi RL'),
      isNotNull,
    );
  });

  test('findTechniqueImage liefert null fuer unbekannte Technik', () {
    expect(findTechniqueImage('Voellig-unbekannte-Technik'), isNull);
  });

  test('findTechniqueImage findet die "Prinzip Kesa"-Uebung aus dem '
      'Kyu-Programm', () {
    expect(findTechniqueImage('Prinzip „Kesa" RL'), isNotNull);
  });

  test('jeder kuratierte Schluessel findet beim exakten Suchen sich selbst '
      '(keine Verwechslung mit einem anderen, aehnlich benannten Schluessel, '
      'z.B. O-uchi-gari vs. Ko-uchi-gari)', () {
    for (final key in techniqueImages.keys) {
      expect(
        findTechniqueImage(key),
        techniqueImages[key],
        reason: '"$key" findet nicht seinen eigenen Eintrag',
      );
    }
  });

  test('Techniken ohne eigene Illustration erben nicht faelschlich das Bild '
      'einer aehnlich benannten, aber eigenstaendigen anderen Technik', () {
    expect(findTechniqueImage('Ushiro-kesa-gatame'), isNull);
    expect(findTechniqueImage('Harai-goshi-gaeshi'), isNull);
    expect(findTechniqueImage('Yoko-tomoe-nage'), isNull);
  });
}
