import '../models/dan_grade.dart';

/// Dan-Pruefungsprogramm des OeJV (Danordnung 2025-10), 1. bis 10. Dan.
///
/// Kata-Zuordnung und Zusatztechnik-Namen sind ein Namens-Katalog aus der
/// offiziellen OeJV-Danordnung. Ausfuehrliche Beschreibungstexte im Original
/// sind OeJV-Eigentum und werden hier bewusst nicht wortwoertlich uebernommen.
const judoDanGrades = <DanGrade>[
  DanGrade(
    dan: 1,
    beltDescription: 'Schwarz',
    kata: 'Nage-no-Kata',
    zusatztechniken: [
      'Seoi-otoshi',
      'Morote-seoi-nage',
      'Obi-otoshi',
      'Yama-arashi',
      'Ko-uchi-gaeshi',
      'Ko-uchi-maki-komi',
      'Sode-tsuri-komi-goshi',
      'Kubi-nage',
      'Uchi-mata-sukashi',
      'O-uchi-gaeshi',
      'Harai-goshi-gaeshi',
      'Tsubame-gaeshi',
      'O-soto-otoshi',
      'O-soto-gaeshi',
      'Hane-goshi-gaeshi',
    ],
    hinweis:
        'Plus 5 frei wählbare Gonosen/Gaeshi-waza und 6 Renraku/Rensoku-waza '
        'mit der eigenen Tokui-waza.',
  ),
  DanGrade(
    dan: 2,
    beltDescription: 'Schwarz',
    kata: 'Katame-no-Kata',
    zusatztechniken: [
      'Tama-guruma',
      'Kuchiki-daoshi',
      'Kibisu-gaeshi',
      'Morote-gari',
      'Obi-tori-gaeshi',
      'Ni-dan-ko-soto-gari/gake',
      'Uchi-mata-gaeshi',
      'Hikikomi-gaeshi',
      'Yoko-tomoe-nage',
      'Daki-wakare',
      'Tawara-gaeshi',
      'Ude-gaeshi',
      'Kani-basami',
      'Uchi-maki-komi',
      'Harai-maki-komi',
      'Uchi-mata-maki-komi',
      'O-soto-maki-komi',
    ],
  ),
  DanGrade(
    dan: 3,
    beltDescription: 'Schwarz',
    kata: 'Kodokan Goshin-Jutsu',
    zusatztechniken: [
      'Ashi-garami',
      'Ude-garami (min. 5 Varianten)',
      'Ude-hishigi-hiza-gatame (min. 3 Varianten)',
      'Ude-hishigi-juji-gatame (min. 3 Varianten)',
      'Ude-hishigi-sankaku-gatame (min. 3 Varianten)',
      'Kata-juji-jime (min. 2 Varianten)',
      'Okuri-eri-jime (min. 2 Varianten)',
      'Do-jime',
      'Kata-te-jime (min. 4 Varianten)',
      'Ryote-jime (min. 3 Varianten)',
      'Kata-ha-jime (min. 3 Varianten)',
      'Sankaku-jime (min. 3 Varianten)',
      'Sode-guruma-jime (min. 2 Varianten)',
    ],
  ),
  DanGrade(
    dan: 4,
    beltDescription: 'Schwarz',
    kata: 'Ju-no-Kata',
    gonosenGaeshiWaza: [
      'Tai-otoshi → Ko-soto-gake',
      'Uchi-mata → Hidari-tai-otoshi',
      'Uchi-mata → Hidari-te-guruma',
      'Harai-goshi → O-soto-guruma',
      'Kubi-nage → Ushiro-goshi',
      'Tsuri-komi-goshi → Hidari-o-goshi',
      'Harai-goshi → Hidari-utsuri-goshi',
      'O-goshi → Seoi-nage',
      'Seoi-nage → Hidari-tai-otoshi',
      'Uchi-mata → Seoi-nage',
    ],
    renrakuRensokuWaza: [
      'Seoi-nage → Ko-uchi-gake',
      'Tai-otoshi → O-uchi-gari',
      'Tai-otoshi → Hidari-seoi-nage',
      'Uchi-mata → O-uchi-gari',
      'Uchi-mata → Ko-uchi-gari',
      'Uchi-mata → O-soto-gari',
      'Uchi-mata → Hidari-ko-soto-gake',
      'Uchi-mata → Tani-otoshi',
      'Seoi-nage → O-uchi-gari',
      'Seoi-nage → Ko-soto-gake',
      'Koshi-guruma → Ashi-guruma',
      'Koshi-guruma → Soto-maki-komi',
      'Koshi-guruma → Kani-basami',
    ],
  ),
  DanGrade(
    dan: 5,
    beltDescription: 'Schwarz (Kodansha)',
    kata: 'Kime-no-Kata',
    gonosenGaeshiWaza: [
      'Ko-soto-gari → O-soto-gari',
      'O-soto-gari → O-soto-guruma',
      'Hiza-guruma → Hiza-guruma',
      'Hidari-de-ashi-barai → Tsubame-gaeshi',
      'O-uchi-gari → Hidari-seoi-nage',
      'O-soto-gari → Sukui-nage',
      'Hidari-ko-uchi-gari → Hiza-guruma',
      'O-uchi-gari → Ko-soto-gake',
      'O-uchi-gari → De-ashi-barai',
      'Hiza-guruma → Ko-uchi-gari',
      'O-soto-gari → Ko-soto-gari',
    ],
    renrakuRensokuWaza: [
      'Tsuri-komi-goshi → Te-guruma',
      'Tsuri-komi-goshi → O-uchi-gari',
      'Tsuri-komi-goshi → Hane-goshi',
      'Tsuri-komi-goshi → Harai-goshi',
      'Hane-goshi → O-soto-otoshi',
      'Tai-otoshi → Ko-uchi-gari',
      'Uki-goshi → O-uchi-gari',
      'Ko-uchi-gari → Morote-seoi-nage',
    ],
  ),
  DanGrade(
    dan: 6,
    beltDescription: 'Rot-Weiß',
    kata: 'Koshiki-no-Kata',
    hinweis:
        'Gonosen/Gaeshi- und Renraku/Rensoku-Ketten, z.B. Seoi-nage → '
        'Yoko-guruma, O-uchi-gari → Hidari-tai-otoshi (vollständige Liste im '
        'Original-Prüfungsprogramm, Kapitel 17).',
  ),
  DanGrade(
    dan: 7,
    beltDescription: 'Rot-Weiß',
    hinweis:
        'Ab 7. Dan nur mehr Überprüfung mit reduzierten Anforderungen '
        '(Kategorien A–D), keine neue Pflicht-Kata.',
  ),
  DanGrade(
    dan: 8,
    beltDescription: 'Rot-Weiß',
    hinweis: 'Überprüfung mit reduzierten Anforderungen (Kategorien A–D).',
  ),
  DanGrade(
    dan: 9,
    beltDescription: 'Rot',
    hinweis: 'Grad der Reife — Überprüfung mit reduzierten Anforderungen.',
  ),
  DanGrade(
    dan: 10,
    beltDescription: 'Rot',
    hinweis: 'Grad der Reife — Überprüfung mit reduzierten Anforderungen.',
  ),
];

/// Gemeinsame Theorie-Themenbereiche fuer alle Dan-Pruefungen (1.-6. Dan).
const danTheorieThemenbereiche = <String>[
  'Sportordnung (Wettkampfsysteme, Alters-/Gewichtsklassen, Kampfzeiten, '
      'Lizenzarten, Proteste, ärztliche Versorgung)',
  'Wettkampfregeln (aktuelle IJF-/ÖJV-Regelauslegung)',
  'Organisation (Landesverband/ÖJV, DAN-Kollegium, Prüfungsberechtigung, '
      'Trainer-/Kampfrichterausbildung, EJU-/IJF-Struktur)',
  'Geschichte (Jigoro Kano, Kodokan-Gründung, Ju-Jitsu-Ursprünge, '
      'Judo-Geschichte Österreichs)',
];
