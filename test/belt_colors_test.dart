import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/theme/belt_colors.dart';

void main() {
  test('einfarbiger Guertel liefert eine Farbe', () {
    expect(beltColorsFromName('Gelb'), hasLength(1));
  });

  test('zweifarbiger Guertel liefert zwei Farben', () {
    expect(beltColorsFromName('Weiß-Gelb'), hasLength(2));
    expect(beltColorsFromName('Grün-Blau'), hasLength(2));
  });

  test('Klammerzusatz wird ignoriert', () {
    expect(beltColorsFromName('Weiß (Sonne)'), hasLength(1));
    expect(
      beltColorsFromName('Weiß (Sonne)').first,
      beltColorsFromName('Weiß').first,
    );
  });

  test('Dan-Guertelbeschreibungen werden erkannt', () {
    expect(beltColorsFromName('Schwarz'), hasLength(1));
    expect(beltColorsFromName('Rot-Weiß'), hasLength(2));
    expect(beltColorsFromName('Rot'), hasLength(1));
  });

  test('unbekannter Name faellt auf eine Fallback-Farbe zurueck', () {
    expect(beltColorsFromName('Voellig-unbekannt'), hasLength(1));
  });
}
