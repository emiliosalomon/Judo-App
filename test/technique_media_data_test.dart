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
}
