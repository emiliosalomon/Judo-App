import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/technique_video_data.dart';
import 'package:judo_app/data/techniques_data.dart';
import 'package:judo_app/data/dan_grades_data.dart';
import 'package:judo_app/data/kyu_grades_data.dart';

void main() {
  test('findTechniqueVideo findet Treffer trotz Suffixen wie " RL"', () {
    expect(findTechniqueVideo('O-soto-gari RL'), isNotNull);
    expect(findTechniqueVideo('Ashi-guruma oder O-guruma RL'), isNotNull);
  });

  test('findTechniqueVideo liefert null fuer unbekannte Technik', () {
    expect(findTechniqueVideo('Voellig-unbekannte-Technik'), isNull);
  });

  test('findTechniqueVideo verwechselt aehnlich klingende Techniken nicht '
      '(z.B. Yoko-guruma darf nicht auf O-guruma anschlagen)', () {
    expect(findTechniqueVideo('Yoko-guruma'), techniqueVideos['Yoko-guruma']);
    expect(findTechniqueVideo('O-guruma'), techniqueVideos['O-guruma']);
    expect(
      findTechniqueVideo('O-soto-guruma'),
      techniqueVideos['O-soto-guruma'],
    );
    expect(
      findTechniqueVideo('Ko-soto-gari RL'),
      techniqueVideos['Ko-soto-gari'],
    );
    expect(
      findTechniqueVideo('O-soto-gari RL'),
      techniqueVideos['O-soto-gari'],
    );
    expect(
      findTechniqueVideo('Ko-uchi-gari RL'),
      techniqueVideos['Ko-uchi-gari'],
    );
    expect(
      findTechniqueVideo('O-uchi-gari RL'),
      techniqueVideos['O-uchi-gari'],
    );
    expect(findTechniqueVideo('Ushiro-goshi'), techniqueVideos['Ushiro-goshi']);
    expect(findTechniqueVideo('Tsuri-goshi'), techniqueVideos['Tsuri-goshi']);
    expect(findTechniqueVideo('Utsuri-goshi'), techniqueVideos['Utsuri-goshi']);
    expect(
      findTechniqueVideo('Ko-uchi-gaeshi'),
      techniqueVideos['Ko-uchi-gaeshi'],
    );
    expect(
      findTechniqueVideo('O-uchi-gaeshi'),
      techniqueVideos['O-uchi-gaeshi'],
    );
  });

  test('Ippon-seoi-nage und Morote-seoi-nage sind unterschiedliche Techniken '
      'und duerfen nicht dasselbe Video wie die jeweils andere zeigen '
      '(Bug: Morote-seoi-nage RL zeigte faelschlich das Ippon-Video)', () {
    final ippon = findTechniqueVideo('Ippon-seoi-nage RL');
    final morote = findTechniqueVideo('Morote-seoi-nage RL');
    expect(ippon, isNotNull);
    expect(morote, isNotNull);
    expect(ippon, isNot(equals(morote)));
    expect(ippon, techniqueVideos['Ippon-seoi-nage']);
    expect(morote, techniqueVideos['Morote-seoi-nage']);
  });

  test('O-soto-maki-komi ist eine eigenstaendige Technik und darf nicht das '
      'Video von Soto-maki-komi erben', () {
    expect(
      findTechniqueVideo('O-soto-maki-komi'),
      isNot(equals(techniqueVideos['Soto-maki-komi'])),
    );
  });

  test('findTechniqueVideo findet die "Prinzip"-Uebungen aus dem '
      'Kyu-Programm trotz Anfuehrungszeichen und RL-Suffix', () {
    expect(findTechniqueVideo('Prinzip „Kesa" RL'), isNotNull);
    expect(findTechniqueVideo('Prinzip „Yoko" RL'), isNotNull);
    expect(findTechniqueVideo('Prinzip „Tate"'), isNotNull);
    expect(findTechniqueVideo('Prinzip „Kami"'), isNotNull);
  });

  test(
    'jeder kuratierte Schluessel findet beim exakten Suchen sich selbst '
    '(keine Verwechslung mit einem anderen, aehnlich benannten Schluessel)',
    () {
      for (final key in techniqueVideos.keys) {
        expect(
          findTechniqueVideo(key),
          techniqueVideos[key],
          reason: '"$key" findet nicht seinen eigenen Eintrag',
        );
      }
    },
  );

  test('alle kuratierten Links sind gueltige YouTube-URLs', () {
    for (final url in techniqueVideos.values) {
      final uri = Uri.parse(url);
      expect(uri.host, 'www.youtube.com');
      expect(uri.queryParameters['v'], isNotEmpty);
    }
  });

  test('findTechniqueVideoThumbnail liefert null fuer unbekannte Technik', () {
    expect(findTechniqueVideoThumbnail('Voellig-unbekannte-Technik'), isNull);
  });

  test('findTechniqueVideoThumbnail leitet aus dem kuratierten Video-Link '
      'automatisch die YouTube-Standbild-URL ab (trotz Suffix wie " RL")', () {
    final thumbnail = findTechniqueVideoThumbnail('O-soto-gari RL');
    expect(thumbnail, isNotNull);
    final uri = Uri.parse(thumbnail!);
    expect(uri.host, 'img.youtube.com');
    expect(
      uri.path,
      contains(
        Uri.parse(techniqueVideos['O-soto-gari']!).queryParameters['v']!,
      ),
    );
  });

  test('jede kuratierte Video-URL liefert eine gueltige Standbild-URL', () {
    for (final key in techniqueVideos.keys) {
      final thumbnail = findTechniqueVideoThumbnail(key);
      expect(thumbnail, isNotNull, reason: '"$key" liefert kein Standbild');
      expect(Uri.parse(thumbnail!).host, 'img.youtube.com');
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
      for (final grade in judoKyuGrades) ...grade.nageWaza,
      for (final grade in judoKyuGrades) ...grade.katameWaza,
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
