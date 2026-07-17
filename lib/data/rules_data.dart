import '../models/rules_topic.dart';

/// Regelwerk-Uebersicht, eigenstaendig formuliert auf Basis der
/// IJF Sport and Organisation Rules und der OeJV-Wettkampfordnung (kein
/// Original-Text der Verbaende - siehe CLAUDE.md). Ergaenzt die
/// verstreuten Regel-Theoriefragen im Kyu-Programm (kyu_grades_data.dart)
/// um eine gebuendelte Nachschlage-Uebersicht.
///
/// Kinderregeln, Alters-/Gewichtsklassen und Judogiregeln basieren auf den
/// vom OeJV bereitgestellten Original-Dokumenten ("Kinderregeln - Revision
/// und Update 2025", "Alters- & Gewichtsklassen 2026", "OeJV-Judogiregeln"):
/// Zahlenwerte (Altersgrenzen, Gewichtsklassen, Kampfzeiten) wurden direkt
/// uebernommen, da es sich um Fakten und keine schuetzenswerten
/// Beschreibungstexte handelt; alle erklaerenden Saetze sind eigenstaendig
/// formuliert.
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
            'fuer die Altersklassen U8, U10 und U12 (Update mit Gueltigkeit '
            'ab 1. Jaenner 2025), das in mehreren Punkten von den '
            'allgemeinen IJF-Wettkampfregeln fuer Erwachsene abweicht - u.a. '
            'bei zugelassenen Techniken je Altersstufe, bei der '
            'Grifffassung und bei der Golden-Score-Regelung.',
      ),
      RulesSection(
        title: 'Eingeschraenkte/verbotene Techniken (U8-U12)',
        bullets: [
          'Wuerge- (Shime-waza) und Hebeltechniken (Kansetsu-waza) werden '
              'in U8, U10 und U12 grundsaetzlich mit "Mate" abgebrochen, '
              'statt bis zur Aufgabe fortgesetzt zu werden.',
          'Dreieckstechniken (Sankaku-waza) werden in U8 und U10 immer mit '
              '"Mate" unterbrochen. In U12 sind sie nur mit dem Ziel eines '
              'Haltegriffs (Osae-komi-waza) erlaubt - wird stattdessen zu '
              'einer Wuerge- oder Hebeltechnik gewechselt, folgt "Mate".',
          'Tomoe-nage, Sumi-gaeshi und verwandte Techniken (z.B. Hikkomi-'
              'gaeshi) sind in U8 und U10 komplett verboten - Versuch '
              'bedeutet Shido und keine Wertung.',
          'Ura-nage: Angriff oder Konterversuch mit Ura-nage bedeutet '
              'Shido. Geht danach Uke in einen Haltegriff ueber, zaehlt '
              'dieser (Shido bleibt bestehen); geht stattdessen Tori in '
              'einen Haltegriff ueber, folgt "Mate" und ebenfalls Shido.',
          'Direkte Seoi-nage/Seoi-otoshi-Angriffe auf beiden Knien '
              'bedeuten in U8 und U10 Shido; ein misslungener Angriff '
              'allein loest dagegen kein Shido aus.',
          'Tani-otoshi und Ko-soto-gake gelten in U8 und U10 nur als '
              'Uebergang in den Bodenkampf: keine Wertung, aber auch kein '
              '"Mate" - der Kampf laeuft direkt in Ne-waza weiter.',
        ],
      ),
      RulesSection(
        title: 'Grifffassung (Kumikata) in U8/U10',
        bullets: [
          'Erlaubt ist ausschliesslich die Standardfassart unterhalb des '
              'Schluesselbeins.',
          'Fassart oberhalb des Schluesselbeins wird mit "Mate" '
              'unterbrochen; wiederholte Versuche fuehren zu Shido.',
        ],
      ),
      RulesSection(
        title: 'Golden Score bei Kindern',
        bullets: [
          'U8: bei Wertungsgleichstand max. 2 Minuten Golden Score, danach '
              'Unentschieden (Hiki-wake).',
          'U10 und U12: ebenfalls max. 2 Minuten Golden Score, ist der '
              'Kampf danach weiter unentschieden, entscheidet das '
              'Kampfgericht per Mehrheitsentscheid (Hantei).',
        ],
      ),
      RulesSection(
        title: 'Turnierrahmen fuer die Altersklasse U8',
        bullets: [
          'Nur ein Jahrgang (7-Jaehrige) darf in der U8 teilnehmen, kein '
              'Aufstieg in eine hoehere Altersklasse.',
          'Maximal 5 Starter pro Kampfklasse, keine Titelkaempfe, kein '
              'Startgeld.',
          'Am selben Tag/Ort duerfen maximal 4 weitere Altersklassen '
              'ausgetragen werden; teilnehmen duerfen nur bei einem '
              'oesterreichischen Verein gemeldete Sportler.',
        ],
      ),
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
            '(von den juengsten Kindern bis zu den Senioren/Veteranen), '
            'innerhalb jeder Altersklasse zusaetzlich nach Gewichtsklassen '
            'getrennt nach Geschlecht. Massgeblich ist der Jahrgang, nicht '
            'das exakte Geburtsdatum. Stand: OeJV-Festlegung fuer 2026.',
      ),
      RulesSection(
        title: 'Gewichtsklassen Frauen',
        bullets: [
          'U8 (7 Jahre, Jg. 2019, 2 min): 18-20, 20-22, 22-25, 25-28, '
              '28-32, 32-36, 36-40, 40-44, 44-48, +48 kg',
          'U10 (8-9 Jahre, Jg. 2018/2017, 2 min): 18-20, 20-22, 22-25, '
              '25-28, 28-32, 32-36, 36-40, 40-44, 44-48, +48 kg',
          'U12 (10-11 Jahre, Jg. 2016/2015, 2 min): 20-22, 22-25, 25-28, '
              '28-32, 32-36, 36-40, 40-44, 44-48, 48-52, +52 kg',
          'U14 (12-13 Jahre, Jg. 2014/2013, 2 min): 22-25, 25-28, 28-32, '
              '32-36, 36-40, 40-44, 44-48, 48-52, 52-57, +57 kg',
          'U16 (13-15 Jahre, Jg. 2013-2011, 3 min): 28-32, 32-36, 36-40, '
              '40-44, 44-48, 48-52, 52-57, 57-63, 63-70, +70 kg',
          'U18 (15-17 Jahre, Jg. 2011-2009, 4 min): 36-40, 40-44, 44-48, '
              '48-52, 52-57, 57-63, 63-70, +70 kg',
          'U21 (15-20 Jahre, Jg. 2011-2006, 4 min): 40-44, 44-48, 48-52, '
              '52-57, 57-63, 63-70, 70-78, +78 kg',
          'U23 (15-22 Jahre, Jg. 2011-2004, 4 min): 44-48, 48-52, 52-57, '
              '57-63, 63-70, 70-78, +78 kg',
          'AK+/Veteranen (ab 15 Jahre, Jg. 2011 und aelter, 4 min): 44-48, '
              '48-52, 52-57, 57-63, 63-70, 70-78, +78 kg',
        ],
      ),
      RulesSection(
        title: 'Gewichtsklassen Maenner',
        bullets: [
          'U8 (7 Jahre, Jg. 2019, 2 min): 18-20, 20-22, 22-24, 24-27, '
              '27-30, 30-34, 34-38, 38-42, 42-46, +46 kg',
          'U10 (8-9 Jahre, Jg. 2018/2017, 2 min): 18-20, 20-22, 22-24, '
              '24-27, 27-30, 30-34, 34-38, 38-42, 42-46, +46 kg',
          'U12 (10-11 Jahre, Jg. 2016/2015, 2 min): 22-24, 24-27, 27-30, '
              '30-34, 34-38, 38-42, 42-46, 46-50, 50-55, +55 kg',
          'U14 (12-13 Jahre, Jg. 2014/2013, 2 min): 27-30, 30-34, 34-38, '
              '38-42, 42-46, 46-50, 50-55, 55-60, 60-66, +66 kg',
          'U16 (13-15 Jahre, Jg. 2013-2011, 3 min): 34-38, 38-42, 42-46, '
              '46-50, 50-55, 55-60, 60-66, 66-73, 73-81, +81 kg',
          'U18 (15-17 Jahre, Jg. 2011-2009, 4 min): 42-46, 46-50, 50-55, '
              '55-60, 60-66, 66-73, 73-81, 81-90, +90 kg',
          'U21 (15-20 Jahre, Jg. 2011-2006, 4 min): 50-55, 55-60, 60-66, '
              '66-73, 73-81, 81-90, 90-100, +100 kg',
          'U23 (15-22 Jahre, Jg. 2011-2004, 4 min): 55-60, 60-66, 66-73, '
              '73-81, 81-90, 90-100, +100 kg',
          'AK+/Veteranen (ab 15 Jahre, Jg. 2011 und aelter, 4 min): 55-60, '
              '60-66, 66-73, 73-81, 81-90, 90-100, +100 kg',
        ],
      ),
      RulesSection(
        title: 'Weitere Bestimmungen',
        bullets: [
          'Golden Score ohne zeitliches Limit gilt bei Einzelbewerben ab '
              'U14; fuer U8-U12 gelten die eigenen OeJV-Kinderregeln zum '
              'Golden Score (siehe Regelwerk Kinder).',
          'Bis einschliesslich U18 ist eine Abwaage im nackten Zustand '
              'verboten - Maenner werden in Unterwaesche, Frauen in '
              'Unterwaesche mit zusaetzlichem T-Shirt abgewogen, mit einer '
              'Toleranz von 0,1 kg (m) bzw. 0,2 kg (w).',
          'Ab der Altersklasse U16 muessen Judoka bei Meisterschaften/'
              'Turnieren in Oesterreich ihre Nationalitaet vorab vom OeJV '
              'bestaetigen lassen.',
          'In der jeweils untersten und obersten Gewichtsklasse von U8, '
              'U10, U12 und U14 kann bei Einzelturnieren die Turnierleitung '
              'das tatsaechliche Koerpergewicht ermitteln und im Bedarfsfall '
              'weitere Gewichtsklassen ergaenzen.',
        ],
      ),
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
          'Die Aermel muessen den ganzen Arm bis zum Handgelenk bedecken '
              '(Sokuteiki-Regel).',
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
      RulesSection(
        title: 'EJU/IJF- vs. OeJV-Veranstaltungen',
        bullets: [
          'Bei EJU-/IJF-Veranstaltungen (auch wenn sie in Oesterreich '
              'ausgetragen werden) gelten die vollen EJU-/IJF-Judogi-'
              'Regeln.',
          'Bei OeJV-Veranstaltungen (Oesterreichische Meisterschaften '
              'inkl. Bundesliga) gilt in allen Altersklassen die Aermel-'
              'laenge nach EJU/IJF (Sokuteiki-Regel), ein IJF-Label ist '
              'dort bis auf weiteres nicht erforderlich.',
        ],
      ),
    ],
  ),
];
