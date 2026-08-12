import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/technique_media_data.dart';

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

  test('findTechniqueImage liefert derzeit fuer jede Technik null - '
      'techniqueImages ist leer, bis eigene Fotos vorliegen (siehe '
      'Doc-Kommentar in technique_media_data.dart); das YouTube-Standbild '
      'wird stattdessen im Video-Auswahlmenue angeboten (siehe '
      'chooseTechniqueVideo in widgets/video_choice_sheet.dart)', () {
    expect(findTechniqueImage('O-soto-gari'), isNull);
    expect(findTechniqueImage('Voellig-unbekannte-Technik'), isNull);
  });

  test('jeder kuratierte Schluessel findet beim exakten Suchen sich selbst '
      '(keine Verwechslung mit einem anderen, aehnlich benannten Schluessel, '
      'z.B. O-uchi-gari vs. Ko-uchi-gari) - greift automatisch, sobald '
      'eigene Fotos in techniqueImages eingetragen werden', () {
    for (final key in techniqueImages.keys) {
      expect(
        findTechniqueImage(key),
        techniqueImages[key],
        reason: '"$key" findet nicht seinen eigenen Eintrag',
      );
    }
  });
}
