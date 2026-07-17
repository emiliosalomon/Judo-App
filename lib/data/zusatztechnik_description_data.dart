import 'fuzzy_technique_match.dart';

/// Kurze, eigenstaendig formulierte Erklaerungen zu den Zusatztechniken der
/// Dan-Pruefungsprogramme (1.-3. Dan), auf Basis der OeJV-Handbuecher
/// "Zusatztechniken fuer den 2. Dan - Nage-waza" und "Zusatztechniken fuer
/// den 3. Dan - Katame-waza" (Erwin Schoen/OeJV). Die dortigen
/// Ausfuehrungsbeschreibungen sind OeJV-Eigentum und wurden hier nicht
/// uebernommen, sondern fuer die App neu formuliert (siehe CLAUDE.md).
///
/// Manche hier beschriebenen Techniken sind in der aktuellen Danordnung
/// (2025-10) als konkrete Beispiel-Varianten einer Sammelanforderung
/// gefuehrt (z.B. "min. 5 Varianten von Ude-garami") und stehen deshalb
/// nicht selbst woertlich in judoDanGrades.zusatztechniken - sie sind
/// trotzdem als eigene Eintraege hinterlegt, weil sie unter ihrem eigenen
/// Namen in den Original-Handbuechern vorkommen und so durchsuchbar/
/// nachschlagbar bleiben.
const zusatztechnikDescriptions = <String, String>{
  // Zusatztechniken 2. Dan Nage-waza (heute teils dem 1. Dan zugeordnet,
  // siehe Danordnung 2025-10 - die Techniknamen und ihre Ausfuehrung sind
  // davon unabhaengig).
  'Tama-guruma':
      'Ansatz wie Kata-guruma: weicht Uke dem Beingriff aus, steigt Tori '
      'nach, kniet ab und drueckt mit dem Handruecken gegen Ukes '
      'Schienbein, statt das Bein zu fassen, und wirft aehnlich wie bei '
      'Kata-guruma.',
  'Kibisu-gaeshi':
      'Kontertechnik: Tori fasst Ukes Ferse (z.B. nach einem Ko-uchi-'
      'Angriff, wenn Uke das Bein hebt) und drueckt es nach hinten unten.',
  'Seoi-otoshi':
      'Aehnlich wie Ippon-, Morote- oder Eri-seoi-nage, jedoch kniet Tori '
      'meist ab und hebt Uke nicht aus, sondern stuerzt ihn direkt nach '
      'unten - kein Ausheben wie bei Seoi-nage.',
  'Yama-arashi':
      'Griff aehnlich Grundfassart, jedoch mit der ziehenden Hand nahe '
      'am Hals; die Wurfausfuehrung erinnert an Tai-otoshi, Harai-goshi '
      'oder Ashi-guruma.',
  'Kuchiki-daoshi':
      'Tori fasst mit einer Hand in Ukes Kniekehle und drueckt/zieht ihn '
      'nach hinten unten - anders als bei Sukui-nage wird Uke dabei nicht '
      'angehoben.',
  'Obi-otoshi':
      'Tori greift an Ukes Guertel, steigt seitlich ein und wirft Uke '
      'drehend ueber die eigene Huefte - aehnlich einer aelteren Form von '
      'Sukui-nage. Uke muss sich bei dieser Technik selbst sichern.',
  'Ko-uchi-gaeshi':
      'Kontertechnik gegen Ko-uchi-gari: Tori weicht mit dem angegriffenen '
      'Bein zurueck, dreht sich und wirft Uke durch Drehung und Armzug '
      '(aehnlich einer Lenkradbewegung).',
  'Kubi-nage':
      'Aehnlich wie Koshi-guruma, jedoch greift Tori mit dem Arm um Ukes '
      'Genick statt nur um die Schulter; die weitere Ausfuehrung erinnert '
      'an Tai-otoshi, Harai-goshi oder Ashi-guruma.',
  'Morote-seoi-nage':
      'Aehnlich wie Ippon-seoi-nage, jedoch beugt Tori die Knie staerker '
      'und schwingt den Unterarm unter Ukes andere Achsel statt nur unter '
      'eine Seite zu greifen.',
  'Ko-uchi-gake':
      'Ansatz wie Ko-uchi-gari, jedoch ohne Sichelbewegung: Tori haengt '
      'sich stattdessen ein und faellt mit Uke flach nach vorne zu Boden.',
  'Tsubame-gaeshi':
      'Kontertechnik gegen De-ashi-barai: Tori weicht mit dem '
      'angegriffenen Bein in einer Kreisbewegung aus und wirft Uke '
      'seinerseits mit De-ashi-barai.',
  'Kani-basami':
      'Scherensprung: Tori stuetzt sich mit einer Hand ab, springt mit '
      'beiden Beinen an Uke heran und wirft ihn durch eine Schwung- und '
      'Zugbewegung der Beine und eines Arms zu Boden.',
  'O-uchi-gaeshi':
      'Kontertechnik gegen O-uchi-gari: Tori verlagert rechtzeitig das '
      'Gewicht, um den Angriff ins Leere laufen zu lassen, und drueckt '
      'dann selbst Ukes Standbein weg.',
  'Harai-goshi-gaeshi':
      'Kontertechnik gegen einen Hueft-/Beinwurf-Angriff (Harai-goshi, '
      'Uchi-mata oder Hane-goshi): Tori verkuerzt den Abstand, hebt Uke '
      'an und wirft ihn ueber das eigene, von aussen angesetzte Bein.',
  'Hane-goshi-gaeshi':
      'Kontertechnik gegen einen Hueft-/Beinwurf-Angriff (Harai-goshi, '
      'Uchi-mata oder Hane-goshi): Tori verkuerzt den Abstand, hebt Uke '
      'an und wirft ihn ueber das eigene, von aussen angesetzte Bein.',
  'Uchi-mata-gaeshi':
      'Kontertechnik gegen einen Hueft-/Beinwurf-Angriff (Harai-goshi, '
      'Uchi-mata oder Hane-goshi): Tori verkuerzt den Abstand, hebt Uke '
      'an und wirft ihn ueber das eigene, von aussen angesetzte Bein.',
  'Tawara-gaeshi':
      'Gegenwurf zu Morote-gari: greift Uke mit beiden Armen nach Toris '
      'Beinen, umfasst Tori Ukes Taille bzw. Guertel, laesst sich nach '
      'hinten fallen und wirft Uke ueber sich.',
  'Ude-gaeshi':
      'Tori fixiert Ukes angreifenden Arm zwischen Kopf und Schulter, '
      'dreht sich unter dessen Achsel hindurch und zwingt Uke durch eine '
      'grosse Armkreisbewegung zu einer Rolle vorwaerts.',
  'Uchi-maki-komi':
      'Aehnlich wie Soto-maki-komi, jedoch kniet Tori tiefer ab und '
      'fuehrt den Arm gestreckt unter Ukes Arm statt abgewinkelt wie bei '
      'Ippon-seoi-nage.',
  'Harai-maki-komi':
      'Beginnt wie der Kuzushi von Harai-goshi; statt den Wurf klassisch '
      'zu Ende zu fuehren, lässt Tori das Revers los und leitet mit dem '
      'Arm eine Rollbewegung wie bei Soto-maki-komi ein.',

  // Zusatztechniken 3. Dan Katame-waza.
  'Yoko-shiho-gatame':
      'Haltegriff seitlich ueber Uke: ein Arm umgreift ein Bein bis zum '
      'Guertel, der andere Arm umgreift Kopf/Genick und fasst ins '
      'gegenueberliegende Revers.',
  'Hasami-jime':
      'Aus der Bankstellung: Tori steigt mit einem Bein um Ukes Kopf/'
      'Genick, waehrend die Haende Revers und Ruecken kontrollieren, und '
      'wuergt durch Ziehen mit der Hand und Druck mit dem Bein.',
  'Ashi-jime':
      'Auch Hiza-jime genannt: Tori in Rueckenlage legt ein Bein um Ukes '
      'Kopf/Genick und wuergt, indem Unterarm und Unterschenkel '
      'gegeneinander gedrueckt werden.',
  'Kagato-jime':
      'Tori in Rueckenlage fuehrt sein Bein quer vor Ukes Brust, sodass '
      'das Schienbein gegen den Kehlkopf drueckt, waehrend beide Haende '
      'am Revers ziehen.',
  'Kata-te-jime':
      'Aus Kesa-gatame oder einer verwandten Haltegriff-Variante: loest '
      'Tori einen Griff und drueckt stattdessen den Unterarm gegen Ukes '
      'Kehlkopf, indem er ins gegenueberliegende Revers greift.',
  'Kensui-jime':
      'Setzt an einem misslungenen Tomoe-nage-Versuch im Stand an: '
      'gelingt der Wurf nicht, bleibt Toris Bein in Ukes Bauchleiste, '
      'schwingt um dessen Kopf/Genick und wuergt zusammen mit den Haenden.',
  'Othen-jime':
      'Auch Rollbankwuergen genannt: Tori klemmt aus der Bankstellung '
      'einen Arm von Uke ein, rollt sich vorwaerts ueber ihn und wuergt '
      'anschliessend aehnlich wie bei Kata-ha-jime.',
  'Sode-guruma-jime':
      'Aus der Bankstellung greift Tori mit einer Hand hoch ins Revers, '
      'mit der anderen von oben an die Schulter und wuergt durch '
      'Gegeneinanderdruecken beider Unterarme.',
  'Ura-juji-jime':
      'Aehnlich wie Sode-guruma-jime, jedoch bewegt sich Tori dabei hinter '
      'den sitzenden Uke, sodass am Ende eine stehende Position hinter '
      'Uke entsteht.',
  'Ryote-jime':
      'Tori in Rueckenlage erfasst mit beiden Haenden das Revers auf '
      'Hoehe der Halsschlagadern und wuergt, indem die Handknoechel zum '
      'Hals gedreht und zusammengedrueckt werden.',
  'Tsukkomi-jime':
      'Auch Tsuki-komi-jime genannt: Tori kniet ueber dem liegenden Uke, '
      'wickelt mit einer Hand dessen Revers um den Hals und wuergt durch '
      'gleichzeitigen Druck und Zug beider Haende.',
  'Tawara-jime':
      'Auch Kami-shiho-ryote-jime oder Kakae-jime genannt: Tori greift '
      'von der Kopfseite unter Ukes Kinn und ueber dessen Kopf jeweils '
      'zum eigenen Aermel und wuergt durch Drehen und Zusammendruecken '
      'der Unterarme.',
  'Kaeshi-jime':
      'Aus der Bankstellung zieht Tori Uke ueber sich in eine Yoko-'
      'Position und wuergt dabei durch Zug mit einer Hand aehnlich wie '
      'bei Eri-jime.',
  'Tomoe-jime':
      'Tori in Rueckenlage fasst Ukes Revers mit beiden Haenden auf '
      'unterschiedlicher Hoehe und fuehrt einen Arm ueber Ukes Kopf, '
      'aehnlich der Wuergerichtung von Kata-juji-jime.',
  'Maki-komi-jime':
      'Auch Morote-jime genannt: Tori greift mit beiden Haenden hoch in '
      'beide Revers, gleitet quer zu Uke zu Boden und wuergt durch Druck '
      'des Unterarms und Zug der anderen Hand.',
  'Ude-garami':
      'Sammelbegriff fuer Hebeltechniken, bei denen ein Arm von Uke '
      'verdreht statt gestreckt gehebelt wird (im Unterschied zu den '
      'Ude-hishigi-Techniken) - z.B. Kesa-garami, Gyaku-kesa-garami, '
      'Kanuki-gatame und Kuzure-kami-shiho-garami sind Varianten davon.',
  'Kesa-garami':
      'Aus Kesa-gatame heraus: befreit sich Uke mit einem Arm, bringt '
      'Tori diesen Arm in eine Ude-garami-Position und hebelt mit dem '
      'Unterschenkel um Ukes Unterarm geschlungen.',
  'Ude-hishigi-ashi-gatame':
      'Aus der Bankstellung klemmt Tori einen Arm von Uke mit dem Bein '
      'ein, zieht ihn in Bauchlage und hebelt am Ellbogen durch Druck von '
      'Becken und Unterschenkel.',
  'Ude-hishigi-hara-gatame':
      'Tori zieht Ukes Handgelenk quer ueber den eigenen Bauch (Hara), '
      'klemmt den Arm mit dem Oberschenkel ein und hebelt durch Druck des '
      'Oberkoerpers nach vorne.',
  'Ude-hishigi-te-gatame':
      'Tori dreht Ukes Handflaeche nach oben und drueckt gleichzeitig mit '
      'der anderen Hand gegen den Ellbogen - bekannt vor allem aus Kime-'
      'no-Kata und Kodokan-Goshin-jutsu.',
  'Gyaku-juji':
      'Tori in Rueckenlage klemmt einen Arm von Uke in die Achsel, '
      'schlingt zusaetzlich das Bein darum und hebelt mit dem Schienbein '
      'unter Ukes Kinn.',
  'Gyaku-kesa-garami':
      'Aus Gyaku-kesa-gatame heraus: befreit sich Uke mit einem Arm, '
      'bringt Tori diesen in eine Ude-garami-Position und hebelt mit dem '
      'Unterschenkel um den Unterarm geschlungen.',
  'Kami-hiza-gatame':
      'Tori kniet ueber dem liegenden Uke, dreht dessen Handflaeche nach '
      'oben, legt den Arm ueber den eigenen Oberschenkel und drueckt den '
      'Unterarm nach unten.',
  'Kanuki-gatame':
      'Tori in Rueckenlage schlingt einen Arm um Ukes Oberarm, klemmt '
      'ihn in die Achsel ein und hebelt durch Druck gegen die Schulter '
      'bei gleichzeitigem Anheben des eigenen Unterarms.',
  'Kuzure-kami-shiho-garami':
      'Aus Kuzure-kami-shiho-gatame heraus: bringt Tori einen Arm von '
      'Uke abgewinkelt auf dessen Ruecken und hebelt mit einem Garami-'
      'Armschluessel.',
};

/// Liefert die kuratierte Erklaerung zu einer Zusatztechnik, falls
/// vorhanden. Nutzt Wortgrenzen-Teilstring-Abgleich (siehe
/// fuzzy_technique_match.dart), da die Programmzeilen in
/// dan_grades_data.dart oft Zusaetze wie "(min. 3 Varianten)" tragen.
String? findZusatztechnikDescription(String technik) =>
    findBestTechniqueMatch(technik, zusatztechnikDescriptions);
