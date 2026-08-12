import '../models/kyu_grade.dart';
import '../models/theory_question.dart';

/// Kyu-Pruefungsprogramm des OeJV, sortiert absteigend (11. bis 1. Kyu).
///
/// Technik-/Begriffslisten sind Namens-Kataloge aus dem offiziellen
/// OeJV-Pruefungsprogramm (Kyu-Hefte 2022, judoaustria.at). Die ausfuehrlichen
/// Beschreibungstexte/Fotos im Original sind OeJV-Eigentum und werden hier
/// bewusst nicht wortwoertlich uebernommen.
///
/// Die Theorie-Antworten sind eigenstaendig formulierte Kurzerklaerungen
/// auf Basis allgemeinen/IJF-Standard-Judowissens (Kommandos, Regeln,
/// Geschichte) - kein OeJV-Originaltext. Fuer oesterreich-spezifische
/// Detailfragen (Geschichte/Namen/Ausbildungsstufen), bei denen keine
/// verlaessliche Quelle vorlag, ist die Antwort bewusst leer (null)
/// gelassen statt geraten.
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
      TheoryQuestion(
        question: 'Was ist Judo?',
        answer:
            'Judo ("sanfter Weg") wurde 1882 von Jigoro Kano in Japan aus '
            'dem Ju-Jitsu entwickelt. Ziel ist es, den Gegner durch Wurf-, '
            'Halte-, Würge- oder Hebeltechniken zu besiegen — begleitet von '
            'den Werten Respekt, Höflichkeit und gegenseitiger Hilfe.',
      ),
      TheoryQuestion(
        question: 'Bekleidung/Grundbegriffe',
        answer:
            'Der Judogi besteht aus Jacke (Uwagi), Hose (Zubon) und Gürtel '
            '(Obi). Tori ist die ausführende, Uke die empfangende Person '
            'einer Technik. Die Trainingsfläche heißt Tatami.',
      ),
      TheoryQuestion(
        question: 'Hygiene',
        answer:
            'Saubere, kurz geschnittene Finger- und Zehennägel, ein '
            'sauberer Judogi und gewaschene Füße sind Pflicht — Judo ist '
            'Körperkontakt-Sport, mangelnde Hygiene gefährdet den Partner.',
      ),
      TheoryQuestion(
        question: 'Verantwortung für den Partner',
        answer:
            'Techniken werden kontrolliert ausgeführt, besonders bei '
            'ungleichem Kräfteverhältnis oder unerfahrenen Partnern. Wer '
            'eine Verletzung riskiert, verstößt gegen den Grundgedanken '
            'des Judo.',
      ),
      TheoryQuestion(
        question: 'Kampfrichterkommandos',
        answer:
            'Die wichtigsten Grundkommandos: Hajime (Start), Mate '
            '(Unterbrechung), Sono-mama (sofort einfrieren), Sore-made '
            '(Kampfende).',
      ),
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
      TheoryQuestion(
        question: 'Weitere Kampfrichterkommandos/Handzeichen',
        answer:
            'Zusätzlich zu den Grundkommandos zeigt der Kampfrichter Ippon, '
            'Waza-ari, Shido und Osae-komi jeweils mit einem eigenen '
            'Handzeichen an, begleitet vom gesprochenen Kommando.',
      ),
      TheoryQuestion(
        question: 'Verbote im Judo',
        answer:
            'Verboten sind u.a. Schläge, Tritte, Angriffe auf Augen/'
            'Genitalien/Kehle, gefährliche Techniken auf Kopf oder Nacken '
            'sowie unsportliches Verhalten.',
      ),
      TheoryQuestion(
        question: 'Osae-komi-Ansage/Dauer',
        answer:
            'Der Kampfrichter ruft „Osae-komi", sobald ein gültiger '
            'Haltegriff beginnt. Ununterbrochene Kontrolle über die volle '
            'Haltedauer ergibt Ippon; bei Unterbrechung ruft er „Toketa".',
      ),
      TheoryQuestion(
        question: 'Sono-mama',
        answer:
            '„Sono-mama" bedeutet „bleib genau so" — beide Kämpfer '
            'erstarren sofort in ihrer Position, z.B. um ein Foul zu '
            'klären. Mit „Yoshi" geht der Kampf in derselben Position '
            'weiter.',
      ),
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
      TheoryQuestion(
        question: 'Wettkampffläche',
        answer:
            'Die Wettkampffläche (Tatami) ist quadratisch, mit einer '
            'Kampfzone und einer umgebenden Sicherheitszone. Verlässt ein '
            'Kämpfer die Kampfzone deutlich, unterbricht der Kampfrichter '
            'mit „Mate".',
      ),
      TheoryQuestion(
        question: 'Bestrafungsstufen',
        answer:
            'Nach aktuellem Regelwerk gibt es die Strafstufe Shido '
            '(Ermahnung); drei Shido gegen denselben Kämpfer führen zum '
            'Hansoku-make (Disqualifikation). Schwere Regelverstöße '
            'können auch direkt zum Hansoku-make führen.',
      ),
      TheoryQuestion(
        question: 'Entstehung von Judo',
        answer:
            'Judo wurde 1882 von Jigoro Kano am Kodokan in Tokio '
            'gegründet, abgeleitet aus verschiedenen Ju-Jitsu-Schulen. '
            'Kano wollte Kampftechniken mit Erziehung und '
            'Persönlichkeitsbildung verbinden.',
      ),
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
      TheoryQuestion(
        question: 'Handzeichen des Kampfrichters',
        answer:
            'Ippon: Arm einmal gestreckt über den Kopf. Waza-ari: Arm '
            'seitlich auf Schulterhöhe. Shido: Arm mit gestrecktem '
            'Zeigefinger zur Seite. Osae-komi: Arm nach vorne unten zur '
            'Matte.',
      ),
      TheoryQuestion(
        question: 'Kriterien für Ippon/Waza-ari',
        answer:
            'Ippon: Wurf mit erheblicher Kraft und Geschwindigkeit, '
            'größtenteils auf den Rücken, kontrolliert ausgeführt. Fehlt '
            'eines dieser Kriterien, wird die Technik als Waza-ari '
            'bewertet.',
      ),
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
      TheoryQuestion(
        question: 'Aufgaben Kampfrichter/Außenrichter',
        answer:
            'Der Kampfrichter auf der Matte trifft alle Entscheidungen '
            '(Bewertungen, Strafen, Unterbrechungen). Ein Video-'
            'Kampfgericht kann ihn bei strittigen Entscheidungen '
            'unterstützen bzw. Entscheidungen überprüfen.',
      ),
      TheoryQuestion(
        question: 'Erlaubtes bei Hebeltechniken',
        answer:
            'Erlaubt sind Hebel nur auf das Ellbogengelenk (Ude-hishigi-'
            'Techniken). Hebel auf andere Gelenke — Knie, Wirbelsäule, '
            'Finger etc. — sind verboten.',
      ),
      TheoryQuestion(
        question: 'Wettkampfablauf',
        answer:
            'Nach der Begrüßung (Rei) beginnt der Kampf mit „Hajime" und '
            'endet mit „Sore-made" bzw. bei Ippon oder Ablauf der '
            'Kampfzeit. Danach werden die Bewertungen verglichen und der '
            'Sieger verkündet.',
      ),
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
      TheoryQuestion(
        question: 'Erlaubtes bei Würgetechniken',
        answer:
            'Würgetechniken (Shime-waza) sind im Stand nicht erlaubt und '
            'nur im Bodenkampf zulässig — entweder wenn beide Kämpfer '
            'bereits am Boden sind, oder im direkten Übergang aus einem '
            'Wurf.',
      ),
      TheoryQuestion(
        question: 'Shido-Gründe',
        answer:
            'Typische Shido-Gründe: übermäßige Passivität, Griff '
            'außerhalb der erlaubten Zone, absichtliches Verlassen der '
            'Kampffläche, Finger in Ärmel/Hosenbein des Gegners stecken, '
            'unsportliches Verhalten.',
      ),
      TheoryQuestion(
        question: 'Mate-Ansage',
        answer:
            '„Mate" unterbricht den Kampf, z.B. bei Verlassen der '
            'Kampffläche, Regelverstoß, Verletzung oder wenn keine Aktion '
            'mehr stattfindet. Danach gehen beide zurück zur '
            'Startposition.',
      ),
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
      TheoryQuestion(
        question: 'Inaktivität',
        answer:
            'Anhaltende Inaktivität bzw. das Vermeiden echter '
            'Angriffsversuche wird vom Kampfrichter mit Shido bestraft, '
            'um aktiven, angriffsfreudigen Judo zu fördern.',
      ),
      TheoryQuestion(
        question: 'Passivität/Negativ-Judo',
        answer:
            'Passives bzw. „negatives" Judo — z.B. dauerhaftes Blockieren '
            'ohne eigene Angriffsabsicht, ständiges Ausweichen — '
            'widerspricht dem Grundgedanken des Judo und wird bestraft.',
      ),
      TheoryQuestion(
        question: 'Hansokumake-Gründe',
        answer:
            'Hansoku-make (Disqualifikation) erfolgt bei schwerwiegenden '
            'oder wiederholten Regelverstößen, z.B. gefährlichen/'
            'verbotenen Techniken, drei Shido oder grob unsportlichem '
            'Verhalten.',
      ),
      TheoryQuestion(question: 'Judo-Geschichte Österreich', answer: null),
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
      TheoryQuestion(
        question: 'Wettkampfsysteme Österreich',
        answer:
            'Wie in den meisten IJF-/EJU-Mitgliedsverbänden üblich, wird '
            'meist im K.o.-System mit Repechage (Trostrunde) gekämpft: '
            'wer gegen einen Finalisten verliert, bekommt über die '
            'Repechage noch die Chance auf Bronze.',
      ),
      TheoryQuestion(question: 'Altersklassen', answer: null),
      TheoryQuestion(
        question: 'Gewichtsklassen/Kampfzeiten',
        answer:
            'IJF-Gewichtsklassen Senioren: Herren -60/-66/-73/-81/-90/-100/'
            '+100 kg, Damen -48/-52/-57/-63/-70/-78/+78 kg. Die '
            'Kampfzeit im Seniorenbereich beträgt nach aktuellem '
            'Regelwerk 4 Minuten.',
      ),
      TheoryQuestion(
        question: 'Verdiente österreichische Judoka',
        answer: null,
      ),
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
      TheoryQuestion(
        question: 'Wettkampfausschreibung',
        answer:
            'Eine Wettkampfausschreibung enthält alle Eckdaten eines '
            'Turniers: Datum, Ort, Alters-/Gewichtsklassen, Meldefrist, '
            'Wettkampfsystem und Verantwortliche.',
      ),
      TheoryQuestion(
        question: 'Proteste',
        answer:
            'Gegen laufende Kampfrichterentscheidungen sind während des '
            'Kampfes keine Proteste möglich. Formale Einsprüche (z.B. '
            'gegen die Startberechtigung eines Gegners) müssen '
            'schriftlich und fristgerecht über die Vereins-/'
            'Verbandsleitung eingereicht werden.',
      ),
      TheoryQuestion(
        question: 'Organisation des Judo-Sports',
        answer:
            'Aufbau von unten nach oben: Verein → Landesverband → '
            'nationaler Verband (ÖJV) → Kontinentalverband (EJU) → '
            'Weltverband (IJF).',
      ),
      TheoryQuestion(question: 'Trainer-/Kampfrichterausbildung', answer: null),
      TheoryQuestion(
        question: 'Meisterschaftsarten',
        answer:
            'Typische Stufen: Landesmeisterschaft, österreichische '
            'Staatsmeisterschaft, sowie internationale Turniere bis hin '
            'zu Europa- und Weltmeisterschaften.',
      ),
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
      TheoryQuestion(
        question: 'Verletzung eines Kämpfers',
        answer:
            'Bei einer Verletzung unterbricht der Kampfrichter sofort mit '
            '„Mate". Kann der verletzte Kämpfer nicht fortsetzen, führt '
            'das zum Kampfabbruch — der Gegner gewinnt durch Aufgabe '
            '(Kiken-gachi).',
      ),
      TheoryQuestion(
        question: 'Medizinische Untersuchung/Hilfe',
        answer:
            'Bei Verletzungen darf medizinisches Personal die Matte '
            'betreten. Die Untersuchungszeit ist reglementiert; danach '
            'muss der Kampf fortgesetzt oder abgebrochen werden.',
      ),
      TheoryQuestion(
        question: 'Was ist eine Kata?',
        answer:
            'Eine Kata ist eine festgelegte Abfolge von Techniken, die '
            'zwei Judoka in genau vorgeschriebener Form zeigen — im '
            'Gegensatz zum freien Randori dient sie der Demonstration und '
            'Vertiefung technischen Verständnisses.',
      ),
      TheoryQuestion(
        question: 'Startberechtigung bei Meisterschaften/Turnieren',
        answer: null,
      ),
    ],
  ),
];
