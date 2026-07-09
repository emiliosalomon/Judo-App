/// Zentrale Sammlung aller Nutzer-sichtbaren UI-Texte (nicht die
/// OeJV-Inhaltsdaten aus lib/data/ — nur feste Beschriftungen/Hinweise).
/// Bereitet spaetere echte Lokalisierung vor: hier ist der einzige Ort,
/// an dem UI-Text steht.
class AppStrings {
  AppStrings._();

  static const bullet = '•  ';

  // Home
  static const appTitle = 'Judo App';
  static const wheelHint = 'Ziehen zum Drehen, antippen zum Auswählen';

  // Platzhalter
  static const contentComingSoon = 'Inhalte folgen.';

  // Gürtelprüfung
  static const beltExamTitle = 'Gürtelprüfung';
  static const tabKyu = 'Kyu (Schülergrade)';
  static const tabDan = 'Dan (Meistergrade)';
  static const sectionUkemiWaza = 'Ukemi-waza (Falltechnik)';
  static const sectionNageWaza = 'Nage-waza (Wurftechnik)';
  static const sectionKatameWaza = 'Katame-waza (Bodentechnik)';
  static const sectionAnwendungsaufgaben =
      'Anwendungsaufgaben (Standardsituationen)';
  static const sectionTheorieThemen = 'Theorie-Themen';
  static const sectionZusatzbegriffe = 'Zusatzbegriffe';

  static String minAgeSubtitle(int age) => 'ab $age Jahren';
  static String minAgeLabel(int age) => 'Mindestalter: $age Jahre';
  static String progressFraction(int done, int total) => '$done/$total';
  static String learnedProgress(int done, int total) =>
      '$done von $total Punkten als gelernt markiert';

  // Dan-Detail
  static String beltLabel(String belt) => 'Gürtel: $belt';
  static const requiredKataLabel = 'Pflicht-Kata';
  static const zusatztechnikenLabel = 'Zusatztechniken';
  static const theorieThemenbereicheLabel = 'Theorie-Themenbereiche';
  static const answerPending =
      'Antwort wird noch ergänzt — dazu fehlt uns bislang eine verlässliche Quelle.';

  // Kata
  static const kataTitle = 'Kata';
  static const kataIntro =
      'Die formalen Kata-Uebungen, jeweils Pflicht-Kata fuer eine '
      'Dan-Pruefung laut OeJV-Danordnung.';
  static String requiredForGrade(String gradeTitle) =>
      'Pflicht-Kata für den $gradeTitle';
  static const kataStructureSummaryOnly =
      'Struktur (ausführliche Technik-Liste folgt):';
  static const kataTechniquesLabel = 'Techniken';

  // Standardsituationen
  static const standardSituationsTitle = 'Standardsituationen';
  static const standardSituationsIntro =
      'Anwendungsaufgaben aus dem OeJV-Kyu-Programm, gebündelt über '
      'alle Gürtelstufen. Dieselben Inhalte findest du auch direkt bei '
      'der jeweiligen Gürtelstufe.';

  // Weiterführende Techniken
  static const techniquesTitle = 'Weiterführende Techniken';
  static const techniquesIntro =
      'Vollständiger Technik-Katalog nach dem klassischen Kodokan-'
      'Gokyo. Techniken, die schon Teil deines Kyu-Programms sind, '
      'sind entsprechend markiert.';
  static const nageWazaGokyoSection = 'Nage-waza (Kodokan Gokyo)';
  static const osaeKomiWazaSection = 'Osae-komi-waza';
  static const shimeWazaSection = 'Shime-waza';
  static const kansetsuWazaSection = 'Kansetsu-waza';
  static const zusatztechnikenPerDanTitle = 'Zusatztechniken je Dan-Grad';
  static const zusatztechnikenPerDanIntro =
      'Weitere anerkannte Techniken (Shinmeisho-no-waza u.a.), die erst '
      'ab bestimmten Dan-Prüfungen dazukommen.';
  static String zusatztechnikenSectionTitle(String gradeTitle) =>
      '$gradeTitle – Zusatztechniken';
  static String techniqueSectionTitle(String title, int count) =>
      '$title ($count)';
  static String coveredFromGrade(int kyu) => 'ab $kyu. Kyu';
  static const notCoveredLabel = 'weiterführend';

  // Suche
  static const searchTitle = 'Suche';
  static const searchHint = 'Technik, Kata, Begriff ... (z.B. "osotogari")';
  static const categoriesLabel = 'Kategorien';
  static const searchEmptyState =
      'Tippe einen Begriff ein — Vorschläge erscheinen automatisch.';

  // Technik-Medien (Bild + YouTube-Link)
  static const watchOnYoutube = 'Auf YouTube ansehen';
  static const noIllustrationYet =
      'Noch keine Illustration hinterlegt — nutze den YouTube-Link.';
  static const imageAttributionPrefix = 'Bild: ';
  static const couldNotOpenLink = 'Link konnte nicht geöffnet werden.';
}
