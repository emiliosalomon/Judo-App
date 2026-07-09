import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/technique_video_data.dart';
import 'package:judo_app/data/techniques_data.dart';
import 'package:judo_app/data/dan_grades_data.dart';

void main() {
  test('findTechniqueVideo findet Treffer trotz Suffixen wie " RL"', () {
    expect(findTechniqueVideo('O-soto-gari RL'), isNotNull);
    expect(findTechniqueVideo('Ashi-guruma oder O-guruma RL'), isNotNull);
  });

  test('findTechniqueVideo liefert null fuer unbekannte Technik', () {
    expect(findTechniqueVideo('Voellig-unbekannte-Technik'), isNull);
  });

  test('alle kuratierten Links sind gueltige YouTube-URLs', () {
    for (final url in techniqueVideos.values) {
      final uri = Uri.parse(url);
      expect(uri.host, 'www.youtube.com');
      expect(uri.queryParameters['v'], isNotEmpty);
    }
  });

  test('Namen im Gokyo-/Katame-waza-Katalog stimmen mit vorhandenen '
      'kuratierten Links ueberein (keine Tippfehler in den Schluesseln)', () {
    final catalog = [
      ...kodokanGokyoNageWaza,
      ...osaeKomiWaza,
      ...shimeWaza,
      ...kansetsuWaza,
      for (final grade in judoDanGrades) ...grade.zusatztechniken,
    ];
    for (final key in techniqueVideos.keys) {
      expect(
        catalog.any((name) => name.toLowerCase().contains(key.toLowerCase())),
        isTrue,
        reason: '"$key" kommt in keinem Technik-Katalog vor',
      );
    }
  });
}
