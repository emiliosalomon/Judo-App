import '../models/rules_topic.dart';

/// Regelwerk-Uebersicht, eigenstaendig formuliert auf Basis der
/// IJF Sport and Organisation Rules und der OeJV-Wettkampfordnung (kein
/// Original-Text der Verbaende - siehe CLAUDE.md). Ergaenzt die
/// verstreuten Regel-Theoriefragen im Kyu-Programm (kyu_grades_data.dart)
/// um eine gebuendelte Nachschlage-Uebersicht.
///
/// Manche Details (v.a. die genauen, sich jaehrlich aendernden
/// Gewichtsklassen-Grenzen und die vollstaendigen OeJV-Kinderregeln) waren
/// ueber die in dieser Umgebung erreichbaren Quellen nicht verlaesslich
/// abrufbar - dort steht bewusst kein Text (null), statt Zahlen zu raten;
/// die App zeigt dann einen Verweis auf die offizielle OeJV-Quelle.
const judoRulesTopics = <RulesTopic>[
  RulesTopic(
    id: 'general',
    title: 'Judo-Regeln allgemein',
    sections: [
      RulesSection(
        title: 'Grundprinzip',
        text:
            'Judo ("sanfter Weg") beruht auf Ju - dem Nachgeben vor Kraft, '
            'statt ihr direkt entgegenzuwirken. Ziel ist es, die Balance '
            'des Partners zu brechen (Kuzushi) und die Technik kontrolliert '
            'auszufuehren, nicht ihn zu verletzen. Gefaehrdendes Verhalten '
            'widerspricht damit dem Grundgedanken des Judo, unabhaengig von '
            'formalen Regeln.',
      ),
      RulesSection(
        title: 'Etikette (Rei)',
        text:
            'Vor und nach jedem Training bzw. Kampf sowie beim Betreten '
            'und Verlassen der Matte wird sich verbeugt (Rei) - Ausdruck '
            'von Respekt gegenueber Partner, Trainingsstaette und dem Sport '
            'selbst.',
      ),
      RulesSection(
        title: 'Grundkommandos des Kampfrichters',
        bullets: [
          'Hajime - Start des Kampfs bzw. Fortsetzung nach einer Pause',
          'Mate - sofortige Unterbrechung (z.B. bei Verlassen der '
              'Kampfzone oder zur Klaerung eines Fouls)',
          'Sono-mama - "bleib genau so": beide Kaempfer erstarren sofort '
              'in ihrer Position; mit Yoshi geht es in derselben Position '
              'weiter',
          'Sore-made - Kampfende',
          'Osae-komi / Toketa - Beginn bzw. Ende eines gueltigen '
              'Haltegriffs',
        ],
      ),
      RulesSection(
        title: 'Verbote',
        text:
            'Verboten sind u.a. Schlaege, Tritte, Angriffe auf Augen, '
            'Genitalien oder Kehle sowie gefaehrliche Techniken auf Kopf '
            'oder Nacken. Auch unsportliches Verhalten (z.B. absichtliches '
            'Verlassen der Kampfflaeche, um einer Wertung zu entgehen) ist '
            'untersagt.',
      ),
    ],
  ),
  RulesTopic(
    id: 'competition',
    title: 'Wettkampfregeln',
    sections: [
      RulesSection(
        title: 'Wertungen',
        bullets: [
          'Ippon - hoechste Wertung, beendet den Kampf sofort. Bei '
              'Wurftechniken: Gegner faellt mit erheblicher Kraft und '
              'Geschwindigkeit kontrolliert auf den Ruecken. Bei '
              'Haltegriffen: volle Haltedauer ohne Unterbrechung.',
          'Waza-ari - Wurf erfuellt nicht alle Ippon-Kriterien vollstaendig '
              '(z.B. nicht ganz auf dem Ruecken). Zwei Waza-ari im selben '
              'Kampf ergeben zusammen einen Ippon und beenden den Kampf.',
        ],
      ),
      RulesSection(
        title: 'Strafen (Shido)',
        text:
            'Shido ist die Ermahnung fuer Regelverstoesse wie mangelnde '
            'Kampfbereitschaft, uebertrieben defensive Griffhaltung oder '
            'Scheinangriffe ohne echte Wurfabsicht. Drei Shido gegen '
            'denselben Kaempfer fuehren zu Hansoku-make (Disqualifikation '
            'fuer diesen Kampf); schwere Regelverstoesse koennen auch '
            'direkt zu Hansoku-make fuehren.',
      ),
      RulesSection(
        title: 'Golden Score',
        text:
            'Steht es nach der regulaeren Kampfzeit unentschieden (auch '
            'bei ungleicher Shido-Anzahl), geht der Kampf ohne Pause in die '
            'Golden Score: Der Kampf laeuft zeitlich unbegrenzt weiter, '
            'bereits erhaltene Shido bleiben bestehen, und die naechste '
            'Wertung jeder Art entscheidet den Kampf sofort.',
      ),
      RulesSection(
        title: 'Wettkampfflaeche',
        text:
            'Die Tatami ist quadratisch und besteht aus einer Kampfzone '
            'mit umgebender Sicherheitszone. Verlaesst ein Kaempfer die '
            'Kampfzone deutlich, unterbricht der Kampfrichter mit "Mate".',
      ),
      RulesSection(
        title: 'Rund um den Wettkampf',
        bullets: [
          'Vor dem Wettkampf steht meist eine offizielle Wiegung an, bei '
              'der die Zugehoerigkeit zur gemeldeten Gewichtsklasse '
              'geprueft wird.',
          'Bis zum 18. Lebensjahr ist einmalig vor der ersten '
              'Wettkampfteilnahme eine aerztliche Bestaetigung der '
              'Sporttauglichkeit vorzulegen.',
        ],
      ),
    ],
  ),
  RulesTopic(
    id: 'children',
    title: 'Wettkampfregeln Kinder',
    sections: [
      RulesSection(
        title: 'Eigenes Regelwerk fuer Kinder',
        text:
            'Der OeJV hat ein eigenes, alters-angepasstes Kinderregelwerk '
            '(zuletzt ueberarbeitet mit Gueltigkeit ab 1. Jaenner 2025), '
            'das in mehreren Punkten von den allgemeinen IJF-'
            'Wettkampfregeln fuer Erwachsene abweicht - u.a. bei '
            'zugelassenen Techniken je Altersstufe und bei der Golden-'
            'Score-Dauer.',
      ),
      RulesSection(
        title: 'Bekannte Abweichungen (Auszug)',
        bullets: [
          'Golden Score ist bei Kindern auf 2 Minuten begrenzt (statt '
              'zeitlich unbegrenzt wie bei Erwachsenen).',
          'In der Altersklasse U12 ist Sankaku-waza nur mit dem Ziel '
              'Osae-komi-waza erlaubt - wird stattdessen in eine Wuerge- '
              'oder Hebeltechnik uebergegangen, unterbricht der '
              'Kampfrichter mit "Mate".',
        ],
      ),
      RulesSection(title: 'Vollstaendige, aktuelle Kinderregeln', text: null),
    ],
  ),
  RulesTopic(
    id: 'age-weight',
    title: 'Alters- und Gewichtsklassen',
    sections: [
      RulesSection(
        title: 'Einteilung nach Altersklassen',
        text:
            'Wettkaempfe werden nach Altersklassen getrennt ausgetragen '
            '(von den juengsten Kindern bis zu den Senioren), innerhalb '
            'jeder Altersklasse zusaetzlich nach Gewichtsklassen getrennt '
            'nach Geschlecht.',
      ),
      RulesSection(title: 'Aktuelle Grenzen', text: null),
    ],
  ),
  RulesTopic(
    id: 'judogi',
    title: 'Judogi-Regeln',
    sections: [
      RulesSection(
        title: 'Farben',
        text:
            'Im Wettkampf traegt der zuerst aufgerufene Kaempfer einen '
            'blauen, der zweite einen weissen (bzw. nahezu weissen) '
            'Judogi - so lassen sich beide fuer Kampfrichter und '
            'Publikum eindeutig unterscheiden.',
      ),
      RulesSection(
        title: 'Passform',
        bullets: [
          'Die Aermel muessen den ganzen Arm bis zum Handgelenk bedecken.',
          'Die Guertelenden muessen nach dem Knoten zwischen 20 und 30 cm '
              'lang sein; der Guertel darf nicht aus steifem oder '
              'rutschigem Material sein, der Knoten muss fest sitzen.',
          'Die Jacke muss beim Ziehen am Revers ausreichend ueberlappen '
              'und darf sich nicht zu leicht oeffnen lassen.',
        ],
      ),
      RulesSection(
        title: 'Kontrolle',
        text:
            'Bei Zweifeln an der Regelkonformitaet misst der Kampfrichter '
            'den Judogi mit dem Sokuteiki (Judogi-Messgeraet) nach, '
            'gemeinsam mit den beiden Eckrichtern.',
      ),
    ],
  ),
];
