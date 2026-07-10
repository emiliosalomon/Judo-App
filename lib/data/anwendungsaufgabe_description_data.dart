/// Kurze, eigenstaendig formulierte Erklaerungen zu den Anwendungsaufgaben
/// (Standardsituationen) aus dem OeJV-Kyu-Programm. Die Programmzeilen
/// selbst sind oft nur knappe Kurzbezeichnungen (z.B. "Nage-waza ->
/// Osae-komi-waza"), die fuer Lernende ohne Erklaerung nicht
/// selbsterklaerend sind - anders als benannte Einzeltechniken haben sie
/// meist auch kein passendes Foto/Video, das die Bedeutung transportiert.
///
/// Texte sind eigene Formulierungen (siehe CLAUDE.md), keine Uebernahme aus
/// OeJV-Originalunterlagen.
const anwendungsaufgabeDescriptions = <String, String>{
  'Aussteigen in/gegen Eindrehrichtung':
      'Übung zur Wurfabwehr: sich aus dem Einstieg eines Wurfs lösen, indem '
      'man entweder in die Drehrichtung des Angreifers hinein oder dagegen '
      'aussteigt, statt sich werfen zu lassen.',
  'Bankstellung → Kansetsu-waza':
      'Aus der Bankstellung des Gegners (auf Händen und Knien) heraus eine '
      'Hebeltechnik (Kansetsu-waza) ansetzen.',
  'Bankstellung → Shime-waza':
      'Aus der Bankstellung des Gegners heraus eine Würgetechnik '
      '(Shime-waza) ansetzen.',
  'Bankstellung/Bauchlage → Osae-komi-waza':
      'Aus der Bankstellung oder Bauchlage des Gegners heraus in einen '
      'Haltegriff (Osae-komi-waza) übergehen.',
  'Befreiung aus Gyaku-kesa-gatame':
      'Sich aus dem umgekehrten Schal-Haltegriff (Gyaku-kesa-gatame) '
      'befreien.',
  'Befreiung aus Kami':
      'Sich aus einem Vierpunkthalt von oben (Kami-shiho-gatame oder '
      'Kuzure-kami-shiho-gatame) befreien.',
  'Befreiung aus Kata-gatame':
      'Sich aus dem Schulter-Haltegriff (Kata-gatame) befreien.',
  'Befreiung aus Kesa': 'Sich aus dem Schal-Haltegriff (Kesa-gatame) befreien.',
  'Befreiung aus Tate':
      'Sich aus dem Reitsitz-Haltegriff (Tate-shiho-gatame) befreien.',
  'Befreiung aus Uki-gatame': 'Sich aus dem Haltegriff Uki-gatame befreien.',
  'Befreiung aus Ura-gatame':
      'Sich aus dem Rückwärts-Haltegriff (Ura-gatame) befreien.',
  'Befreiung aus Yoko':
      'Sich aus dem seitlichen Haltegriff (Yoko-shiho-gatame) befreien.',
  'Beinumschlingung (Rückenlage)':
      'In Rückenlage den Gegner mit den Beinen umschlingen, um ihn auf '
      'Abstand zu halten oder am Boden zu kontrollieren.',
  'Bewegen/Kombinationen mit Ashi-waza':
      'Im Stand mit Beintechniken (Ashi-waza) Bewegung erzeugen und daraus '
      'Wurf-Kombinationen aufbauen.',
  'Bewegung über den Griff':
      'Den Gegner allein über einen gezielten Griff (Kumikata) aus dem '
      'Gleichgewicht bringen bzw. zur Bewegung zwingen.',
  'Bewegungsrichtungen':
      'Die grundlegenden Bewegungs- und Ausweichrichtungen im Stand.',
  'Block':
      'Einen Wurfansatz des Gegners mit Körper oder Arm blockieren, um sich '
      'zu verteidigen.',
  'Griffkampf (gleiche/gegengleiche Auslage)':
      'Kumikata (Grifffassen) sowohl in gleicher (Ai-yotsu) als auch '
      'gegengleicher (Kenka-yotsu) Kampfauslage üben.',
  'Handlungskette am Boden':
      'Eine Abfolge mehrerer Bodentechniken, die ineinander übergehen '
      '(z.B. Haltegriff → Hebel → Würgetechnik).',
  'Handlungskette mit Tokui-waza':
      'Eine Techniken-Abfolge rund um die eigene Lieblingstechnik '
      '(Tokui-waza) aufbauen.',
  'Handlungskomplex Tokui-waza (technisch/taktisch)':
      'Technisches und taktisches Zusammenspiel rund um die eigene '
      'Lieblingstechnik (Tokui-waza).',
  'Handlungskomplex am Boden (technisch/taktisch)':
      'Technisches und taktisches Zusammenspiel im Bodenkampf.',
  'Handlungskomplex mit Sankaku':
      'Technisches Zusammenspiel rund um Sankaku-waza (Dreieck-Techniken).',
  'Hishigi → Uki-gatame und zurück':
      'Zwischen einem Armhebel (Ude-hishigi) und dem Haltegriff Uki-gatame '
      'hin und her wechseln.',
  'Kampfauslage (Ai-yotsu/Kenka-yotsu)':
      'Gleiche (Ai-yotsu) und gegengleiche (Kenka-yotsu) Kampfauslage '
      'erkennen und gezielt nutzen.',
  'Kombination Harai-goshi/O-soto-gari':
      'Wurf-Kombination: Harai-goshi ansetzen, bei Abwehr auf O-soto-gari '
      'wechseln (oder umgekehrt).',
  'Kombination O-uchi/Ko-uchi':
      'Wurf-Kombination: O-uchi-gari ansetzen, bei Abwehr auf Ko-uchi-gari '
      'wechseln (oder umgekehrt).',
  'Nage-waza → Osae-komi-waza':
      'Direkter Übergang von einem Wurf im Stand in einen Haltegriff am '
      'Boden - der klassische Stand-Boden-Übergang.',
  'O-goshi gegen Koshi-guruma':
      'Konter: O-goshi als Gegentechnik gegen einen Koshi-guruma-Angriff '
      'des Gegners einsetzen.',
  'Situationsbezogene Anwendung der Tokui-waza':
      'Die eigene Lieblingstechnik (Tokui-waza) passend zur jeweiligen '
      'Kampfsituation einsetzen.',
  'Tai-otoshi → Tai-otoshi':
      'Tai-otoshi wiederholt bzw. beidseitig einsetzen, z.B. als '
      'Kombination gegen die Abwehr des ersten Versuchs.',
  'Tori in Rückenlage, Uke zwischen Beinen':
      'Bodenkampf-Grundposition: Tori liegt auf dem Rücken, Uke kniet oder '
      'steht zwischen Toris Beinen (vergleichbar mit der "Guard"-Position).',
  'Tori zwischen Beinen von Uke':
      'Bodenkampf-Grundposition: Tori befindet sich zwischen den Beinen '
      'von Uke, der auf dem Rücken liegt.',
  'Tsuri-komi-goshi → Tani-otoshi':
      'Übergang von Tsuri-komi-goshi in Tani-otoshi, wenn der erste '
      'Wurfansatz nicht gelingt.',
  'Uchi-mata-sukashi':
      'Ausweich-/Kontertechnik gegen einen Uchi-mata-Angriff des Gegners.',
  'Verteidigung gegen Hishigi':
      'Sich gegen einen angesetzten Armhebel (Ude-hishigi) verteidigen '
      'bzw. daraus befreien.',
  'Wechsel zwischen Kesa-Techniken':
      'Zwischen verschiedenen Kesa-gatame-Varianten wechseln, ohne die '
      'Kontrolle über den Gegner zu verlieren.',
  'Wechsel zwischen Yoko-Techniken':
      'Zwischen verschiedenen Yoko-shiho-gatame-Varianten wechseln, ohne '
      'die Kontrolle über den Gegner zu verlieren.',
  'Werfen in 4 Wurfrichtungen':
      'Denselben Wurf in alle vier Grundrichtungen (vorwärts, rückwärts, '
      'links, rechts) sicher ausführen können.',
};

/// Liefert die kuratierte Erklaerung zu einer Anwendungsaufgabe, falls
/// vorhanden. Exakter Abgleich, da der aufrufende Code immer den
/// Original-Programmtext aus lib/data/kyu_grades_data.dart uebergibt.
String? findAnwendungsaufgabeDescription(String aufgabe) =>
    anwendungsaufgabeDescriptions[aufgabe];
