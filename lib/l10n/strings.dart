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

  // Lernanreiz (Streak/Sterne/Pokale)
  static const streakLabel = 'Serie';
  static const starsLabel = 'Sterne';
  static const trophiesLabel = 'Pokale';
  static String streakDaysTooltip(int days) =>
      days == 1 ? '1 Tag in Folge aktiv' : '$days Tage in Folge aktiv';
  static const beltCompleteBadge = 'Gürtel komplett!';
  static const rewardCloseLabel = 'Weiter geht\'s!';

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
  static const watchFullKataOnYoutube = 'Gesamten Ablauf ansehen';
  static const kataVideoAttribution =
      'Video: offizieller YouTube-Kanal des Kodokan';
  static const kataTechniqueVideoHint =
      'Antippen öffnet eine Suche im offiziellen Kodokan-YouTube-Kanal.';

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
      'Antippen zeigt Vorschläge, Tippen grenzt sie weiter ein.';

  // Technik-Medien (Bild + YouTube-Link)
  static const imageAttributionPrefix = 'Bild: ';
  static const couldNotOpenLink = 'Link konnte nicht geöffnet werden.';
  static const tapAgainForVideoHint = 'Nochmal antippen fürs Video';

  // Technik-Quiz
  static const quizTitle = 'Technik-Quiz';
  static const quizIntro =
      'Welche deutsche Übersetzung passt zur Technik? Bei jeder Runde '
      'werden zufällige Techniken aus dem gesamten Programm abgefragt.';
  static const quizStartButton = 'Runde starten';
  static String quizQuestionProgress(int current, int total) =>
      'Frage $current/$total';
  static const quizTechniqueVideoHint = 'Technik antippen fürs Video';
  static const quizCorrectFeedback = 'Richtig!';
  static String quizWrongFeedback(String correctAnswer) =>
      'Leider falsch — richtig wäre: $correctAnswer';
  static const quizNextButton = 'Weiter';
  static const quizFinishButton = 'Ergebnis ansehen';
  static const quizFinishedTitle = 'Runde geschafft!';
  static String quizScoreSummary(int correct, int total) =>
      '$correct von $total richtig';
  static const quizPlayAgainButton = 'Nochmal spielen';
  static const quizBackButton = 'Zurück zur Übersicht';
  static const quizExitButton = 'Zurück';
  static const quizMedalTitle = 'Medaille verdient!';
  static String quizMedalSubtitle(int total) =>
      '$total richtig beantwortete Techniken';
  static const quizTrophyTitle = 'Pokal verdient!';
  static String quizTrophySubtitle(int total) =>
      '$total richtig beantwortete Techniken insgesamt';
  static String quizProgressSummary(int total, int medals, int trophies) =>
      '$total gelernt · $medals Medaillen · $trophies Pokale';
  static String quizReviewButton(int count) => 'Falsche wiederholen ($count)';
  static const quizReviewIntro =
      'Wiederhole gezielt die Techniken, bei denen du zuletzt daneben '
      'lagst.';

  // Rangliste
  static const leaderboardTitle = 'Rangliste';
  static const leaderboardUnavailable =
      'Die Rangliste ist aktuell nicht verfügbar.';
  static const leaderboardEmpty =
      'Noch niemand auf der Rangliste — sei die/der Erste!';
  static const leaderboardJoinButton = 'Bei der Rangliste mitmachen';
  static const nicknamePromptTitle = 'Wie sollen wir dich nennen?';
  static const nicknamePromptHint = 'Spitzname';
  static const nicknamePromptConfirm = 'Speichern';
  static const nicknamePromptCancel = 'Abbrechen';

  // Meine Kaempfe
  static const myFightsButtonLabel = 'Meine Kämpfe';
  static const myFightsTitle = 'Meine Kämpfe';
  static const myFightsEmptyState =
      'Noch keine Kämpfe eingetragen — leg los und werde deine eigene '
      'Fighting-Legende!';
  static const addFightTitle = 'Kampf eintragen';
  static const addFightFabTooltip = 'Kampf hinzufügen';
  static const fightDateLabel = 'Datum';
  static const fightTournamentLabel = 'Turnier';
  static const fightTournamentHint = 'Name des Turniers';
  static const fightLocationLabel = 'Ort';
  static const fightLocationHint = 'Wo hat der Kampf stattgefunden?';
  static const fightPlacementLabel = 'Erreichter Platz';
  static const fightPlacementHint = 'z.B. 1. Platz, Vorrunde ausgeschieden';
  static const fightOpponentsCountLabel = 'Anzahl Kämpfe/Gegner';
  static const fightNotesLabel = 'Notizen';
  static const fightNotesHint = 'Wie ist es gelaufen? Was hast du gelernt?';
  static const fightPhotoLabel = 'Erinnerungsfoto';
  static const fightBracketPhotoLabel = 'Kämpferliste / Auslosung';
  static const addPhotoButton = 'Foto hinzufügen';
  static const changePhotoButton = 'Foto ändern';
  static const removePhotoButton = 'Foto entfernen';
  static const saveFightButton = 'Speichern';
  static String fightOpponentsCountSummary(int count) =>
      count == 1 ? '1 Gegner' : '$count Gegner';
  static const deleteFightTooltip = 'Kampf löschen';
  static const deleteFightConfirmTitle = 'Kampf löschen?';
  static const deleteFightConfirmMessage =
      'Dieser Eintrag wird unwiderruflich gelöscht.';
  static const deleteConfirm = 'Löschen';
  static const deleteCancel = 'Abbrechen';
  static const fightRequiredFieldsMissing =
      'Bitte Turnier, Ort und Datum ausfüllen.';
  static const judoAustriaTermineButton = 'Judo Austria – Turniertermine';
}
