import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/fuzzy_technique_match.dart';

void main() {
  test('findet einen eindeutigen Teilstring-Treffer', () {
    final table = {'O-soto-gari': 1, 'Harai-goshi': 2};
    expect(findBestTechniqueMatch('O-soto-gari RL', table), 1);
  });

  test('matcht nicht mitten im Wort (Yoko-guruma darf nicht auf '
      'O-guruma anschlagen)', () {
    final table = {'O-guruma': 'falsch', 'Yoko-guruma': 'richtig'};
    expect(findBestTechniqueMatch('Yoko-guruma', table), 'richtig');
  });

  test('bei mehreren gueltigen Treffern gewinnt der laengste Schluessel', () {
    final table = {'Uchi-mata': 'kurz', 'Uchi-mata-sukashi': 'lang'};
    expect(findBestTechniqueMatch('Uchi-mata-sukashi', table), 'lang');
  });

  test('liefert null, wenn nichts passt', () {
    final table = {'O-soto-gari': 1};
    expect(findBestTechniqueMatch('Voellig-unbekannt', table), isNull);
  });
}
