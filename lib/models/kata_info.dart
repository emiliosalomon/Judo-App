/// Eine Gruppe von Techniken innerhalb einer Kata (z.B. "Te-waza").
class KataSection {
  final String title;
  final List<String> techniques;

  const KataSection({required this.title, this.techniques = const []});
}

/// Struktur-Informationen zu einer der 6 offiziell anerkannten Kata.
/// Eigenstaendig formuliert anhand allgemein bekannter Kodokan-Struktur
/// (kein OeJV-Originaltext).
class KataInfo {
  final String name;
  final String meaning;
  final String description;
  final List<KataSection> sections;

  /// Wenn true, ist die Technik-Liste in [sections] nur strukturell
  /// (Gruppen/Anzahl), keine vollstaendige Aufzaehlung.
  final bool sectionsAreSummaryOnly;

  const KataInfo({
    required this.name,
    required this.meaning,
    required this.description,
    this.sections = const [],
    this.sectionsAreSummaryOnly = false,
  });
}

const judoKataInfos = <String, KataInfo>{
  'Nage-no-Kata': KataInfo(
    name: 'Nage-no-Kata',
    meaning: 'Formen des Werfens',
    description:
        'Zeigt 15 grundlegende Wurftechniken in 5 Gruppen zu je 3, jede '
        'Technik einmal nach rechts und einmal nach links. Trainiert '
        'Kuzushi (Gleichgewichtsbruch), Tsukuri (Eingang) und Kake '
        '(Ausfuehrung) in Reinform, ohne Wettkampf-Anpassung.',
    sections: [
      KataSection(
        title: 'Te-waza (Handtechniken)',
        techniques: ['Uki-otoshi', 'Seoi-nage', 'Kata-guruma'],
      ),
      KataSection(
        title: 'Koshi-waza (Hüfttechniken)',
        techniques: ['Uki-goshi', 'Harai-goshi', 'Tsuri-komi-goshi'],
      ),
      KataSection(
        title: 'Ashi-waza (Beintechniken)',
        techniques: [
          'Okuri-ashi-barai',
          'Sasae-tsuri-komi-ashi',
          'Uchi-mata',
        ],
      ),
      KataSection(
        title: 'Ma-sutemi-waza (Opfertechniken rückwärts)',
        techniques: ['Tomoe-nage', 'Ura-nage', 'Sumi-gaeshi'],
      ),
      KataSection(
        title: 'Yoko-sutemi-waza (Opfertechniken seitwärts)',
        techniques: ['Yoko-gake', 'Yoko-guruma', 'Uki-waza'],
      ),
    ],
  ),
  'Katame-no-Kata': KataInfo(
    name: 'Katame-no-Kata',
    meaning: 'Formen des Bodenkampfs',
    description:
        'Zeigt 15 Bodentechniken in 3 Gruppen zu je 5. Anders als bei '
        'Nage-no-Kata wird hier meist nur eine Seite gezeigt, dafuer mit '
        'ausfuehrlichem Gegenwehr- und Befreiungsanteil.',
    sections: [
      KataSection(
        title: 'Osaekomi-waza (Haltegriffe)',
        techniques: [
          'Kesa-gatame',
          'Kata-gatame',
          'Kami-shiho-gatame',
          'Yoko-shiho-gatame',
          'Kuzure-kami-shiho-gatame',
        ],
      ),
      KataSection(
        title: 'Shime-waza (Würgetechniken)',
        techniques: [
          'Kata-juji-jime',
          'Hadaka-jime',
          'Okuri-eri-jime',
          'Kata-ha-jime',
          'Gyaku-juji-jime',
        ],
      ),
      KataSection(
        title: 'Kansetsu-waza (Hebeltechniken)',
        techniques: [
          'Ude-garami',
          'Ude-hishigi-juji-gatame',
          'Ude-hishigi-ude-gatame',
          'Ude-hishigi-hiza-gatame',
          'Ashi-garami',
        ],
      ),
    ],
  ),
  'Kodokan Goshin-Jutsu': KataInfo(
    name: 'Kodokan Goshin-Jutsu',
    meaning: 'Formen der Selbstverteidigung',
    description:
        '1956 vom Kodokan als moderne Selbstverteidigungs-Kata '
        'zusammengestellt: 21 Techniken gegen unbewaffnete und bewaffnete '
        'Angriffe. Anders als die aelteren Kata bezieht sie explizit Angriffe '
        'mit Messer (Tanto), Stock (Jo) und Pistole (Kenju) ein.',
    sectionsAreSummaryOnly: true,
    sections: [
      KataSection(
        title: 'Kumitsuki (Angriffe im Griff, 5 Techniken)',
      ),
      KataSection(
        title: 'Hanarete (Angriffe auf Abstand, 7 Techniken)',
      ),
      KataSection(
        title: 'Tanto-Dori (Verteidigung gegen Messer, 3 Techniken)',
      ),
      KataSection(
        title: 'Jo-Dori (Verteidigung gegen Stock, 3 Techniken)',
      ),
      KataSection(
        title: 'Kenju-Dori (Verteidigung gegen Pistole, 3 Techniken)',
      ),
    ],
  ),
  'Ju-no-Kata': KataInfo(
    name: 'Ju-no-Kata',
    meaning: 'Formen der Sanftheit',
    description:
        'Zeigt 15 Bewegungsprinzipien in 3 Gruppen zu je 5, ohne Faelle oder '
        'harte Wuerfe — Tori fuehrt und leitet die Kraft von Uke, statt sie '
        'zu brechen. Urspruenglich fuer Judoka konzipiert, die keine '
        'Fallschule (mehr) ueben koennen/sollen.',
    sectionsAreSummaryOnly: true,
    sections: [
      KataSection(title: '1. Gruppe (Ikkyo, 5 Formen)'),
      KataSection(title: '2. Gruppe (Nikyo, 5 Formen)'),
      KataSection(title: '3. Gruppe (Sankyo, 5 Formen)'),
    ],
  ),
  'Kime-no-Kata': KataInfo(
    name: 'Kime-no-Kata',
    meaning: 'Formen der Entscheidung',
    description:
        'Selbstverteidigungs-Kata gegen ernsthafte Angriffe, in zwei Teilen: '
        'kniend (Idori) und stehend (Tachiai). Historisch aeltere und '
        'haertere Kata als Goshin-Jutsu, mit Schlag-, Stoss- und '
        'Waffenangriffen.',
    sectionsAreSummaryOnly: true,
    sections: [
      KataSection(title: 'Idori (kniend, 8 Formen)'),
      KataSection(title: 'Tachiai (stehend, 12 Formen)'),
    ],
  ),
  'Koshiki-no-Kata': KataInfo(
    name: 'Koshiki-no-Kata',
    meaning: 'Alte Formen',
    description:
        'Die aelteste im Judo erhaltene Kata, aus der Kito-Ryu-Jujutsu-'
        'Tradition uebernommen und von Jigoro Kano bewahrt. Simuliert '
        'Kampf in Ruestung — daher die ungewoehnlich langsamen, '
        'kontrollierten Bewegungen ohne die uebliche Kuzushi-Dynamik.',
    sectionsAreSummaryOnly: true,
    sections: [
      KataSection(title: 'Omote (14 Formen)'),
      KataSection(title: 'Ura (7 Formen)'),
    ],
  ),
};
