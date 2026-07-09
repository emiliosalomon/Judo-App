import '../models/kyu_grade.dart';

/// Kyu-Pruefungsprogramm des OeJV, sortiert absteigend (11. bis 1. Kyu).
///
/// Technik-/Begriffslisten sind Namens-Kataloge aus dem offiziellen
/// OeJV-Pruefungsprogramm (Kyu-Hefte 2022, judoaustria.at). Die ausfuehrlichen
/// Beschreibungstexte/Fotos im Original sind OeJV-Eigentum und werden hier
/// bewusst nicht wortwoertlich uebernommen.
const judoKyuGrades = <KyuGrade>[
  KyuGrade(
    kyu: 11,
    beltName: 'Weiß (Sonne)',
    hinweis:
        'Einstiegsstufe ohne eigenes Technikprogramm — erstes Kennenlernen '
        'von Judo, kein formaler Pruefungsinhalt im OeJV-Katalog.',
  ),
  KyuGrade(
    kyu: 10,
    beltName: 'Weiß-Gelb',
    minAge: 7,
    ukemiWaza: [
      'Fall rückwärts (Hockstand)',
      'Fall seitwärts (Hockstand) RL',
      'Fall vorwärts (Kniestand)',
      'Rolle vorwärts (Halbkniestand) RL',
      'Rolle rückwärts (Hockstand) RL',
    ],
    nageWaza: ['Uki-goshi RL', 'O-soto-otoshi RL'],
    katameWaza: ['Prinzip „Kesa" RL', 'Prinzip „Yoko" RL'],
    anwendungsaufgaben: [
      'Nage-waza → Osae-komi-waza',
      'Wechsel zwischen Kesa-Techniken',
      'Wechsel zwischen Yoko-Techniken',
      'Befreiung aus Kesa',
      'Befreiung aus Yoko',
    ],
    theorieThemen: [
      'Was ist Judo?',
      'Bekleidung/Grundbegriffe',
      'Hygiene',
      'Verantwortung für den Partner',
      'Kampfrichterkommandos',
    ],
    zusatzbegriffe: ['Kumi-kata (Grundfassart)', 'Kuzushi (4 Richtungen)'],
  ),
  KyuGrade(
    kyu: 9,
    beltName: 'Gelb',
    minAge: 7,
    ukemiWaza: [
      'Fall rückwärts (Stand)',
      'Fall seitwärts (Stand) RL',
      'Fall vorwärts (Grätschstand)',
      'Rolle vorwärts/O-chugaeri (Stand) RL',
      'Rolle rückwärts (Stand) RL',
    ],
    nageWaza: ['De-ashi-barai RL', 'O-goshi RL'],
    katameWaza: ['Prinzip „Tate"', 'Prinzip „Kami"'],
    anwendungsaufgaben: [
      'Nage-waza → Osae-komi-waza',
      'Befreiung aus Tate',
      'Befreiung aus Kami',
    ],
    theorieThemen: [
      'Weitere Kampfrichterkommandos/Handzeichen',
      'Verbote im Judo',
      'Osae-komi-Ansage/Dauer',
      'Sono-mama',
    ],
    zusatzbegriffe: ['Tsukuri (direkter/indirekter Eingang)'],
  ),
  KyuGrade(
    kyu: 8,
    beltName: 'Gelb-Orange',
    minAge: 8,
    ukemiWaza: [
      'Fall rückwärts über Hindernis',
      'Fall seitwärts/Überschlag über Hindernis RL',
      'Rolle vorwärts über Hindernis RL',
      'Rolle rückwärts über Hindernis',
    ],
    nageWaza: ['Koshi-guruma RL', 'Ippon-seoi-nage RL'],
    katameWaza: ['Gyaku-kesa-gatame RL'],
    anwendungsaufgaben: [
      'Nage-waza → Osae-komi-waza',
      'Bewegungsrichtungen',
      'Aussteigen in/gegen Eindrehrichtung',
      'O-goshi gegen Koshi-guruma',
      'Befreiung aus Gyaku-kesa-gatame',
      'Bankstellung/Bauchlage → Osae-komi-waza',
    ],
    theorieThemen: [
      'Wettkampffläche',
      'Bestrafungsstufen',
      'Entstehung von Judo',
    ],
  ),
  KyuGrade(
    kyu: 7,
    beltName: 'Orange',
    minAge: 9,
    nageWaza: ['Morote-seoi-nage RL', 'Tsuri-komi-goshi RL'],
    katameWaza: ['Kata-gatame RL'],
    anwendungsaufgaben: [
      'Block',
      'Kampfauslage (Ai-yotsu/Kenka-yotsu)',
      'Bewegung über den Griff',
      'Befreiung aus Kata-gatame',
      'Beinumschlingung (Rückenlage)',
      'Tori zwischen Beinen von Uke',
    ],
    theorieThemen: [
      'Handzeichen des Kampfrichters',
      'Kriterien für Ippon/Waza-ari',
    ],
  ),
  KyuGrade(
    kyu: 6,
    beltName: 'Orange-Grün',
    minAge: 10,
    ukemiWaza: ['Überschlag (freier Fall)'],
    nageWaza: [
      'Ko-uchi (Barai/Gari)',
      'O-uchi (Barai/Gari)',
      'Tai-otoshi RL',
      'Tani-otoshi RL',
    ],
    katameWaza: ['Ude-hishigi-juji-gatame RL', 'Ude-garami RL', 'Uki-gatame'],
    anwendungsaufgaben: [
      'Kombination O-uchi/Ko-uchi',
      'Tsuri-komi-goshi → Tani-otoshi',
      'Tai-otoshi → Tai-otoshi',
      'Hishigi → Uki-gatame und zurück',
      'Bankstellung → Kansetsu-waza',
      'Befreiung aus Uki-gatame',
    ],
    theorieThemen: [
      'Aufgaben Kampfrichter/Außenrichter',
      'Erlaubtes bei Hebeltechniken',
      'Wettkampfablauf',
    ],
  ),
  KyuGrade(
    kyu: 5,
    beltName: 'Grün',
    minAge: 11,
    nageWaza: ['O-soto-gari RL', 'Harai-goshi RL'],
    katameWaza: [
      'Ura-gatame RL',
      'Nami-juji-jime',
      'Gyaku-juji-jime',
      'Kata-juji-jime',
    ],
    anwendungsaufgaben: [
      'Werfen in 4 Wurfrichtungen',
      'Kombination Harai-goshi/O-soto-gari',
      'Befreiung aus Ura-gatame',
      'Tori in Rückenlage, Uke zwischen Beinen',
    ],
    theorieThemen: [
      'Erlaubtes bei Würgetechniken',
      'Shido-Gründe',
      'Mate-Ansage',
    ],
  ),
  KyuGrade(
    kyu: 4,
    beltName: 'Grün-Blau',
    minAge: 12,
    nageWaza: ['Uchi-mata RL', 'Ko-uchi-maki-komi', 'Sumi-gaeshi'],
    katameWaza: [
      'Ude-hishigi-hiza-gatame RL',
      'Ude-hishigi-ude-gatame RL',
      'Sankaku-waza',
    ],
    anwendungsaufgaben: [
      'Bewegen/Kombinationen mit Ashi-waza',
      'Uchi-mata-sukashi',
      'Verteidigung gegen Hishigi',
    ],
    theorieThemen: [
      'Inaktivität',
      'Passivität/Negativ-Judo',
      'Hansokumake-Gründe',
      'Judo-Geschichte Österreich',
    ],
  ),
  KyuGrade(
    kyu: 3,
    beltName: 'Blau',
    minAge: 13,
    nageWaza: [
      'Hiza-guruma oder Sasae-tsuri-komi-ashi RL',
      'Soto-maki-komi RL',
      'Tomoe-nage',
    ],
    katameWaza: ['Okuri-eri-jime', 'Koshi-jime'],
    anwendungsaufgaben: [
      'Situationsbezogene Anwendung der Tokui-waza',
      'Bankstellung → Shime-waza',
      'Handlungskomplex mit Sankaku',
    ],
    theorieThemen: [
      'Wettkampfsysteme Österreich',
      'Altersklassen',
      'Gewichtsklassen/Kampfzeiten',
      'Verdiente österreichische Judoka',
    ],
  ),
  KyuGrade(
    kyu: 2,
    beltName: 'Blau-Braun',
    minAge: 14,
    nageWaza: ['Okuri-ashi-barai RL', 'Ko-soto-gari/gake', 'Utsuri-goshi'],
    katameWaza: [
      'Eri-jime',
      'Ude-hishigi-waki-gatame',
      'Ude-hishigi-ashi-gatame RL',
    ],
    anwendungsaufgaben: [
      'Griffkampf (gleiche/gegengleiche Auslage)',
      'Handlungskette mit Tokui-waza',
      'Handlungskette am Boden',
    ],
    theorieThemen: [
      'Wettkampfausschreibung',
      'Proteste',
      'Organisation des Judo-Sports',
      'Trainer-/Kampfrichterausbildung',
      'Meisterschaftsarten',
    ],
  ),
  KyuGrade(
    kyu: 1,
    beltName: 'Braun',
    minAge: 15,
    nageWaza: ['Ashi-guruma oder O-guruma RL', 'Yoko-guruma', 'Ura-nage'],
    katameWaza: ['Hadaka-jime (+ Ushiro-jime-Variante)', 'Kata-ha-jime'],
    anwendungsaufgaben: [
      'Handlungskomplex Tokui-waza (technisch/taktisch)',
      'Handlungskomplex am Boden (technisch/taktisch)',
    ],
    theorieThemen: [
      'Verletzung eines Kämpfers',
      'Medizinische Untersuchung/Hilfe',
      'Was ist eine Kata?',
      'Startberechtigung bei Meisterschaften/Turnieren',
    ],
  ),
];
