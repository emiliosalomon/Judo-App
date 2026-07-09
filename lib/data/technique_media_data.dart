/// Zuordnung Technik-Name -> frei lizenzierte, gezeichnete Illustration von
/// Wikimedia Commons. Alle hier verlinkten Bilder sind Strichzeichnungen
/// (keine Fotos echter Menschen) von Michael Hultström, CC BY-SA 3.0.
///
/// URLs nutzen Wikimedias "Special:FilePath"-Mechanismus (stabiler Link auf
/// die aktuelle Dateiversion, ohne den MD5-Hash-Pfad kennen zu muessen).
/// Dateinamen stammen aus einer Recherche mit indexierten Suchtreffern
/// (nicht per Live-Abruf verifiziert, da commons.wikimedia.org in dieser
/// Sandbox blockiert war) — vor Release stichprobenartig pruefen.
///
/// Fuer Halte-/Wuerge-/Hebeltechniken (Katame-waza) gibt es auf Commons
/// bisher kaum vergleichbare freie Illustrationen; diese Techniken zeigen
/// nur den YouTube-Link.
class TechniqueImage {
  final String url;
  final String attribution;

  const TechniqueImage({required this.url, required this.attribution});
}

const _hultstroem = 'Michael Hultström, CC BY-SA 3.0, via Wikimedia Commons';

const techniqueImages = <String, TechniqueImage>{
  'O-soto-gari': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/O-soto-gari.jpg',
    attribution: _hultstroem,
  ),
  'O-soto-otoshi': TechniqueImage(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/O-soto-otoshi.jpg',
    attribution: _hultstroem,
  ),
  'O-uchi-gari': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/O-uchi-gari.jpg',
    attribution: _hultstroem,
  ),
  'Ko-uchi-gari': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Ko-uchi-gari.jpg',
    attribution: _hultstroem,
  ),
  'Ko-soto-gari': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Ko-soto-gari.jpg',
    attribution: _hultstroem,
  ),
  'Ko-soto-gake': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Ko-soto-gake.jpg',
    attribution: _hultstroem,
  ),
  'Tai-otoshi': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Tai-otoshi.jpg',
    attribution: _hultstroem,
  ),
  'De-ashi-barai': TechniqueImage(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/De-ashi-barai.jpg',
    attribution: _hultstroem,
  ),
  'Harai-goshi': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Harai-goshi.jpg',
    attribution: _hultstroem,
  ),
  'Harai-tsuri-komi-ashi': TechniqueImage(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Harai-tsurikomi-ashi.jpg',
    attribution: _hultstroem,
  ),
  'Hiza-guruma': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Hiza-guruma.jpg',
    attribution: _hultstroem,
  ),
  'Ashi-guruma': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Ashi-Guruma.svg',
    attribution: _hultstroem,
  ),
  'Sumi-gaeshi': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Sumi-gaeshi.svg',
    attribution: _hultstroem,
  ),
  'Tomoe-nage': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Tomoe-nage.svg',
    attribution: _hultstroem,
  ),
  'Sukui-nage': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Sukui-nage.svg',
    attribution: _hultstroem,
  ),
  'Obi-otoshi': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Obi-otoshi.svg',
    attribution: _hultstroem,
  ),
  'Morote-gari': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Morote-gari.svg',
    attribution: _hultstroem,
  ),
  'Kibisu-gaeshi': TechniqueImage(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Kibisu-gaeshi.svg',
    attribution: _hultstroem,
  ),
  'Ude-hishigi-juji-gatame': TechniqueImage(
    url: 'https://commons.wikimedia.org/wiki/Special:FilePath/Juji-gatame.jpg',
    attribution: _hultstroem,
  ),
  'Kesa-gatame': TechniqueImage(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Hon-kesa-gatame.jpg',
    attribution: _hultstroem,
  ),
  'Kuzure-kesa-gatame': TechniqueImage(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Kuzure-kesa-gatame.jpg',
    attribution: _hultstroem,
  ),
  'Gyaku-kesa-gatame': TechniqueImage(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Kuzure-kesa-gatame.jpg',
    attribution: _hultstroem,
  ),
  'Makura-kesa-gatame': TechniqueImage(
    url:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Makura-kesa-gatame.gif',
    attribution: _hultstroem,
  ),
};

/// Sucht per Teilstring-Abgleich (Kyu-Programm-Namen haben oft Suffixe wie
/// " RL" oder "oder ..."), nicht per exaktem Schluessel.
TechniqueImage? findTechniqueImage(String technique) {
  final normalized = technique.toLowerCase();
  for (final entry in techniqueImages.entries) {
    if (normalized.contains(entry.key.toLowerCase())) return entry.value;
  }
  return null;
}
