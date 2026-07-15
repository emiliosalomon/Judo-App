import 'package:flutter/widgets.dart';
import 'fuzzy_technique_match.dart';

/// Zuordnung Technik-Name -> Bild, entweder ein eigenes Foto
/// ([TechniqueImage.asset], lokal im Repo unter assets/images/techniques/)
/// oder eine frei lizenzierte Illustration von Wikimedia Commons
/// ([TechniqueImage.network]). Eigene Fotos werden bevorzugt eingetragen,
/// sobald sie vorliegen - siehe CLAUDE.md zur Bevorzugung eigenen
/// Bildmaterials.
///
/// Die Wikimedia-Illustrationen sind Strichzeichnungen (keine Fotos echter
/// Menschen) von Michael Hultström, CC BY-SA 3.0. URLs nutzen Wikimedias
/// "Special:FilePath"-Mechanismus (stabiler Link auf die aktuelle
/// Dateiversion, ohne den MD5-Hash-Pfad kennen zu muessen). Dateinamen
/// stammen aus einer Recherche mit indexierten Suchtreffern (nicht per
/// Live-Abruf verifiziert, da commons.wikimedia.org in dieser Sandbox
/// blockiert war) — vor Release stichprobenartig pruefen.
///
/// Fuer Halte-/Wuerge-/Hebeltechniken (Katame-waza) gibt es auf Commons
/// bisher kaum vergleichbare freie Illustrationen; diese Techniken zeigen
/// nur den YouTube-Link, bis ein eigenes Foto vorliegt.
class TechniqueImage {
  final String? assetPath;
  final String? networkUrl;
  final String? attribution;

  /// Eigenes, lokal im Repo liegendes Foto (assets/images/techniques/...).
  const TechniqueImage.asset(String path, {this.attribution})
    : assetPath = path,
      networkUrl = null;

  /// Extern gehostete, frei lizenzierte Illustration (z.B. Wikimedia
  /// Commons) - Attribution ist hier Pflicht (Lizenzbedingung).
  const TechniqueImage.network({required String url, required this.attribution})
    : networkUrl = url,
      assetPath = null;

  /// Baut das passende Image-Widget (asset oder Netzwerk). Laedt das Bild
  /// nicht, wenn es fehlt/nicht erreichbar ist, sondern zeigt nichts an
  /// (kein kaputtes Bild-Icon) - der Rest der aufgeklappten Zeile
  /// (Beschreibung etc.) bleibt trotzdem sichtbar.
  Widget build({BoxFit fit = BoxFit.contain}) {
    Widget onError(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    ) => const SizedBox.shrink();
    final path = assetPath;
    if (path != null) {
      return Image.asset(path, fit: fit, errorBuilder: onError);
    }
    return Image.network(networkUrl!, fit: fit, errorBuilder: onError);
  }
}

const _hultstroem = 'Michael Hultström, CC BY-SA 3.0, via Wikimedia Commons';

const techniqueImages = <String, TechniqueImage>{
  'O-soto-gari': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/O-soto-gari.jpg',
    attribution: _hultstroem,
  ),
  'O-soto-otoshi': TechniqueImage.network(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/O-soto-otoshi.jpg',
    attribution: _hultstroem,
  ),
  'O-uchi-gari': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/O-uchi-gari.jpg',
    attribution: _hultstroem,
  ),
  'Ko-uchi-gari': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Ko-uchi-gari.jpg',
    attribution: _hultstroem,
  ),
  'Ko-soto-gari': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Ko-soto-gari.jpg',
    attribution: _hultstroem,
  ),
  'Ko-soto-gake': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Ko-soto-gake.jpg',
    attribution: _hultstroem,
  ),
  'Tai-otoshi': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Tai-otoshi.jpg',
    attribution: _hultstroem,
  ),
  'De-ashi-barai': TechniqueImage.network(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/De-ashi-barai.jpg',
    attribution: _hultstroem,
  ),
  'Harai-goshi': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Harai-goshi.jpg',
    attribution: _hultstroem,
  ),
  'Harai-tsuri-komi-ashi': TechniqueImage.network(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Harai-tsurikomi-ashi.jpg',
    attribution: _hultstroem,
  ),
  'Hiza-guruma': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Hiza-guruma.jpg',
    attribution: _hultstroem,
  ),
  'Ashi-guruma': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Ashi-Guruma.svg',
    attribution: _hultstroem,
  ),
  'Sumi-gaeshi': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Sumi-gaeshi.svg',
    attribution: _hultstroem,
  ),
  'Tomoe-nage': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Tomoe-nage.svg',
    attribution: _hultstroem,
  ),
  'Sukui-nage': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Sukui-nage.svg',
    attribution: _hultstroem,
  ),
  'Obi-otoshi': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Obi-otoshi.svg',
    attribution: _hultstroem,
  ),
  'Morote-gari': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Morote-gari.svg',
    attribution: _hultstroem,
  ),
  'Kibisu-gaeshi': TechniqueImage.network(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Kibisu-gaeshi.svg',
    attribution: _hultstroem,
  ),
  'Ude-hishigi-juji-gatame': TechniqueImage.network(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Juji-gatame.jpg',
    attribution: _hultstroem,
  ),
  'Kesa-gatame': TechniqueImage.network(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Hon-kesa-gatame.jpg',
    attribution: _hultstroem,
  ),
  'Kuzure-kesa-gatame': TechniqueImage.network(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Kuzure-kesa-gatame.jpg',
    attribution: _hultstroem,
  ),
  'Gyaku-kesa-gatame': TechniqueImage.network(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Kuzure-kesa-gatame.jpg',
    attribution: _hultstroem,
  ),
  'Makura-kesa-gatame': TechniqueImage.network(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Makura-kesa-gatame.gif',
    attribution: _hultstroem,
  ),
  // OeJV-Kyu-Programm "Prinzip"-Uebung (10. Kyu): Positions-Grundprinzip der
  // Kesa-gatame-Familie, daher dieselbe Illustration wie 'Kesa-gatame'.
  'Prinzip „Kesa"': TechniqueImage.network(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Hon-kesa-gatame.jpg',
    attribution: _hultstroem,
  ),
};

/// Diese Technik-Namen enthalten zwar einen kuerzeren, kuratierten
/// Schluessel als wortgrenzen-gueltigen Teilstring (z.B. "Ushiro-kesa-
/// gatame" enthaelt "Kesa-gatame"), bezeichnen aber eine eigenstaendige,
/// andere Technik - die Illustration des kuerzeren Schluessels waere hier
/// irrefuehrend (analog zum Seoi-nage/Ippon-seoi-nage-Bug bei den Videos).
final _noFallbackImage = RegExp(
  r'\b(ushiro-kesa-gatame|harai-goshi-gaeshi|yoko-tomoe-nage)\b',
  caseSensitive: false,
);

/// Sucht per wortgrenzen-bewusstem Teilstring-Abgleich (siehe
/// fuzzy_technique_match.dart; Kyu-Programm-Namen haben oft Suffixe wie
/// " RL" oder "oder ..."), nicht per exaktem Schluessel.
TechniqueImage? findTechniqueImage(String technique) {
  if (_noFallbackImage.hasMatch(technique.toLowerCase())) return null;
  return findBestTechniqueMatch(technique, techniqueImages);
}
