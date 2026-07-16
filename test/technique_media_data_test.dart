import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/technique_media_data.dart';
import 'package:judo_app/data/technique_video_data.dart';

void main() {
  test('TechniqueImage.asset baut ein Image.asset-Widget, .network ein '
      'Image.network-Widget', () {
    const asset = TechniqueImage.asset('assets/images/techniques/x.jpg');
    expect(asset.build(), isA<Image>());
    expect((asset.build() as Image).image, isA<AssetImage>());
    expect(asset.attribution, isNull);

    const network = TechniqueImage.network(
      url: 'https://example.com/x.jpg',
      attribution: 'Test',
    );
    expect((network.build() as Image).image, isA<NetworkImage>());
    expect(network.attribution, 'Test');
  });

  test('findTechniqueImage findet Treffer trotz Suffixen wie " RL"', () {
    expect(findTechniqueImage('O-soto-gari RL'), isNotNull);
    expect(findTechniqueImage('O-uchi-gari RL'), isNotNull);
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

  test('Techniken ohne eigenes Foto/Video erben nicht faelschlich das Bild '
      'einer aehnlich benannten, aber eigenstaendigen anderen Technik '
      '(Yoko-tomoe-nage hat weder eigenes Foto noch kuratiertes Video)', () {
    expect(findTechniqueImage('Yoko-tomoe-nage'), isNull);
  });

  test('Ushiro-kesa-gatame und Harai-goshi-gaeshi haben eigene, '
      'unverwechselbare kuratierte Video-Eintraege - das automatische '
      'Standbild darf hier also nicht per Sperrliste unterdrueckt werden', () {
    final ushiro = findTechniqueImage('Ushiro-kesa-gatame');
    final haraiGaeshi = findTechniqueImage('Harai-goshi-gaeshi');
    expect(ushiro, isNotNull);
    expect(haraiGaeshi, isNotNull);
    expect(
      ushiro!.networkUrl,
      contains(
        Uri.parse(techniqueVideos['Ushiro-kesa-gatame']!).queryParameters['v']!,
      ),
    );
    expect(
      haraiGaeshi!.networkUrl,
      contains(
        Uri.parse(techniqueVideos['Harai-goshi-gaeshi']!).queryParameters['v']!,
      ),
    );
  });
}
