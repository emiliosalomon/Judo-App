/// Zentrale Sammlung aller Nutzer-sichtbaren UI-Texte (nicht die
/// OeJV-Inhaltsdaten aus lib/data/ — nur feste Beschriftungen/Hinweise).
/// Bereitet spaetere echte Lokalisierung vor: hier ist der einzige Ort,
/// an dem UI-Text steht.
class AppStrings {
  AppStrings._();

  static const bullet = '•  ';

  // Anmeldesystem
  static const authWelcomeTitle = 'Willkommen bei der Judo App';
  static const authWelcomeSubtitle =
      'Mit Konto bleibt dein Fortschritt geräteübergreifend gespeichert. '
      'Ohne Anmeldung kannst du sofort loslegen — deine Daten werden dann '
      'aber nicht gespeichert.';
  static const authLoginButton = 'Anmelden';
  static const authRegisterButton = 'Registrieren';
  static const authContinueAsGuestButton = 'Ohne Anmeldung fortfahren';
  static const authEmailLabel = 'E-Mail-Adresse';
  static const authPasswordLabel = 'Passwort';
  static const authLoginTitle = 'Anmelden';
  static const authRegisterTitle = 'Registrieren';
  static const authLoginSubmit = 'Anmelden';
  static const authRegisterSubmit = 'Konto erstellen';
  static const authSwitchToRegister = 'Noch kein Konto? Registrieren';
  static const authSwitchToLogin = 'Schon ein Konto? Anmelden';
  static const authEmailRequired = 'Bitte E-Mail-Adresse eingeben.';
  static const authPasswordTooShort = 'Mindestens 6 Zeichen.';
  static const authGuestBanner =
      'Gast-Modus: Fortschritt wird nicht gespeichert.';
  static const authGuestRegisterHint = 'Jetzt registrieren';
  static const authSignedInAs = 'Angemeldet als';
  static const authSignOut = 'Abmelden';
  static const authAccountTooltip = 'Konto';

  // Home
  static const appTitle = 'Judo App';
  static const wheelHint = 'Ziehen zum Drehen, antippen zum Auswählen';
  static const logoTapHint = 'Judo-Logo, zum Anhören von "Hajime!" antippen';

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
  static const gonosenGaeshiWazaLabel = 'Gonosen-/Gaeshi-Waza (Konterketten)';
  static const renrakuRensokuWazaLabel =
      'Renraku-/Rensoku-Waza (Kombinationsketten)';
  static const answerPending =
      'Antwort wird noch ergänzt — dazu fehlt uns bislang eine verlässliche Quelle.';

  // Regelwerk
  static const rulesTitle = 'Regelwerk';
  static const rulesIntro =
      'Überblick über die wichtigsten Judo- und Wettkampfregeln nach '
      'IJF- und OeJV-Vorgaben.';
  static const rulesPendingNote =
      'Die genauen, aktuellen Angaben dazu ändern sich gelegentlich und '
      'waren über keine verlässliche, frei zugängliche Quelle abrufbar — '
      'bitte auf judoaustria.at nachsehen, statt sich auf geratene Werte '
      'zu verlassen.';

  // Kata
  static const kataTitle = 'Kata';
  static const kataIntro =
      'Die formalen Kata-Uebungen, jeweils Pflicht-Kata fuer eine '
      'Dan-Pruefung laut OeJV-Danordnung.';
  static String requiredForGrade(String gradeTitle) =>
      'Pflicht-Kata für den $gradeTitle';
  static const kataTechniquesLabel = 'Techniken';
  static const watchFullKataOnYoutube = 'Gesamten Ablauf ansehen';
  static const kataVideoAttribution =
      'Video: offizieller YouTube-Kanal des Kodokan';
  static const kataTechniqueVideoHint =
      'Antippen zeigt Video-Optionen (oder, ohne kuratierten Link, eine '
      'Suche im offiziellen Kodokan-YouTube-Kanal).';

  // Technik-ABC
  static const techniquesAZTitle = 'Technik-ABC';
  static const techniquesAZIntro =
      'Alle Basistechniken alphabetisch zum Nachschlagen. Antippen zeigt '
      'deutsche Übersetzung, Erklärung und Video.';
  static const standTechniquesSection = 'Standtechniken (Nage-waza)';
  static const groundTechniquesSection =
      'Bodentechniken (Osae-komi-, Shime-, Kansetsu-waza)';

  static String techniqueSectionTitle(String title, int count) =>
      '$title ($count)';

  // Suche
  static const searchTitle = 'Suche';
  static const searchHint = 'Technik, Kata, Begriff ... (z.B. "osotogari")';
  static const categoriesLabel = 'Kategorien';
  static const searchEmptyState =
      'Antippen zeigt Vorschläge, Tippen grenzt sie weiter ein.';

  // KI-Frage-Antwort-Suche (durchsucht lokal alle App-Inhalte, ohne Server)
  static const aiSearchSectionTitle = 'Frag mich etwas';
  static const aiSearchHint =
      'z.B. "Wie lang muss der Gürtel sein?" oder "Was ist Kuzushi?"';
  static const aiSearchEmptyState =
      'Stell eine Frage zu Technik, Regeln, Kata oder Prüfungsprogramm — '
      'die Suche durchsucht alle Inhalte der App danach.';
  static const aiSearchNoMatch =
      'Dazu wurde in den App-Inhalten noch keine passende Antwort gefunden. '
      'Versuch es mit anderen Begriffen oder nutze die Direktsuche weiter '
      'unten.';
  static const aiSearchSourcePrefix = 'Quelle: ';
  static const aiSearchOpenSource = 'Mehr dazu ansehen';
  static const aiSearchRecentLabel = 'Zuletzt gesucht';
  static const quickJumpLabel = 'Direkt zu Technik, Kata oder Prüfungsstufe';

  // Technik-Medien (Bild + YouTube-Link)
  static const imageAttributionPrefix = 'Bild: ';
  static const couldNotOpenLink = 'Link konnte nicht geöffnet werden.';
  static const tapAgainForVideoHint = 'Nochmal antippen für Video-Optionen';
  static const videoChoiceStandbildOption = 'Video-Standbild ansehen';
  static const videoChoiceFullOption = 'Ganzes Video ansehen';

  // Technik-Quiz
  static const quizTitle = 'Technik-Quiz';
  static const quizIntro =
      'Welche deutsche Übersetzung passt zur Technik? Bei jeder Runde '
      'werden zufällige Techniken aus den ausgewählten Gürtelstufen '
      'abgefragt.';
  static const quizStartButton = 'Zeig mir, was du kannst';
  static const quizGradeSelectionButton = 'Gürtelstufen auswählen';
  static const quizGradeSelectionTitle = 'Gürtelstufen auswählen';
  static const quizGradeSelectionIntro =
      'Nur ausgewählte Stufen kommen im Quiz vor — so werden z.B. '
      'Anfänger nicht mit Dan-Zusatztechniken abgefragt.';
  static const quizGradeSelectionSelectAll = 'Alle';
  static const quizGradeSelectionSelectNone = 'Keine';
  static const quizGradeSelectionOtherSubtitle =
      'Techniken ohne eigenen Kyu-/Dan-Programmpunkt, u.a. Kata-Techniken';
  static String quizGradeSelectionSummary(int count) => count == 0
      ? 'Keine Gürtelstufe ausgewählt'
      : count == 1
      ? '1 Gürtelstufe ausgewählt'
      : '$count Gürtelstufen ausgewählt';
  static const quizNoGradesSelectedHint =
      'Bitte mindestens eine Gürtelstufe auswählen.';
  static const quizHajimeAnnouncement = 'Hajime!';
  static String quizQuestionProgress(int current, int total) =>
      'Frage $current/$total';
  static const quizTechniqueVideoHint = 'Technik antippen für Video-Optionen';
  static const quizCorrectFeedback = 'Richtig!';
  static String quizWrongFeedback(String correctAnswer) =>
      'Leider falsch — richtig wäre: $correctAnswer';
  static const quizNextButton = 'Weiter';
  static const quizFinishButton = 'Ergebnis ansehen';
  static const quizPreviousQuestionButton = 'Vorherige Technik';
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
