# CLAUDE.md — Judo-App

<!--
  Diese Datei ist das Wichtigste im ganzen Kit.
  Claude liest sie automatisch zu Beginn JEDER Sitzung und behandelt sie als
  verbindliche Anweisung. Alles, was Claude ueber dein Projekt wissen soll, ohne
  dass du es jedes Mal neu erklaerst, gehoert hierher.

  Faustregel: Wenn du Claude dieselbe Sache zum zweiten Mal erklaerst,
  schreib sie stattdessen hier rein.
-->

## Was das hier ist

Eine Judo-Lern-App fuer Android und iOS. Zentrales UI-Element ist ein
scrollbares Rad um ein Logo (zwei Judoka im blauen und weissen Kimono, einer
wirft den anderen) mit fuenf auswaehlbaren Kategorien, jede mit dem
japanischen Symbol/Schriftzeichen dafuer:

1. Guertelpruefung
2. Weiterfuehrende Techniken
3. Kata
4. Standardsituationen
5. Suchfunktion mit auswaehlbaren Kategorien

Farbgestaltung: Rot, Weiss, Schwarz — angelehnt an das Budokan-Logo.

**Regelwerk-Referenz:** Inhalte (Guertelpruefung, Techniken, Kata,
Standardsituationen) richten sich nach der **OeJV-Ordnung** (Oesterreichischer
Judo-Verband) und den **IJF-Regeln** (International Judo Federation) — nicht
nach DJB (Deutscher Judo-Bund). Vor dem Befuellen einer Inhalts-Sektion mit
Pruefungsanforderungen/Terminologie erst die aktuellen OeJV/IJF-Dokumente
pruefen statt Annahmen aus anderen Verbaenden zu uebernehmen.

## Tech-Stack & Werkzeuge

- Sprache / Framework: Flutter (Dart) — eine Codebasis fuer Android und iOS
- Paketmanager: pub (pubspec.yaml)
- Starten (Dev): `flutter run`
- Tests: `flutter test`
- Build: `flutter build apk` (Android) / `flutter build ios` (iOS)

## So ist der Code aufgebaut

- `lib/models/` — Datenklassen (`JudoCategory`, `KyuGrade`, `DanGrade`)
- `lib/data/` — die eigentlichen OeJV-Pruefungsinhalte als const-Listen
  (`kyu_grades_data.dart`, `dan_grades_data.dart`)
- `lib/screens/` — je Bildschirm eine Datei (Home, Guertelpruefung inkl.
  Kyu-/Dan-Detail, Kata, Standardsituationen, Suche)
- `lib/widgets/` — wiederverwendbare UI-Bausteine (Auswahlrad, Logo)
- `lib/theme/` — Farben/ThemeData
- `lib/l10n/strings.dart` — alle Nutzer-sichtbaren UI-Texte (feste
  Beschriftungen/Hinweise, nicht die OeJV-Inhaltsdaten aus `lib/data/`)
- `lib/services/` — App-weiter Zustand (z.B. Lernfortschritt via
  ProgressController/ProgressScope, lokal persistiert)

## Konventionen (bitte einhalten)

- Schreib Code im Stil der umliegenden Dateien (gleiche Benennung, gleiche Struktur).
- Keine neuen Abhaengigkeiten ohne kurze Rueckfrage.
- Texte, die der Nutzer sieht, zentral in `lib/l10n/strings.dart` (Klasse
  `AppStrings`) halten, nichts hart im Code verstreuen. Neue UI-Texte dort
  ergaenzen statt als Literal in ein Widget zu schreiben.
- Neue Funktionen bekommen, wo sinnvoll, einen Test.
- **OeJV-Inhalte in `lib/data/`:** Technik-/Begriffsnamen (japanische
  Fachbegriffe wie Nage-waza, Kesa-gatame etc.) sind Standardvokabular und
  unproblematisch. Die ausfuehrlichen Beschreibungstexte/Fotos aus den
  Original-OeJV-PDFs sind OeJV-Eigentum (Kyu-Hefte: Copyright Erwin
  Schoen/OeJV) — nicht wortwoertlich uebernehmen, sondern fuer App-Inhalte
  eigenstaendig neu formulieren bzw. eigenes Bild-/Videomaterial erstellen.

## Arbeitsweise mit Claude (wichtig)

- **Worktree-first:** Fuer groessere Aenderungen arbeitet Claude in einem eigenen
  Git-Branch/Worktree, nicht direkt auf `main`. (Wird durch die Hooks in
  `.claude/hooks/` erzwungen.) Kleine Ein-Zeilen-Korrekturen und reine Fragen
  duerfen direkt auf `main` bleiben.
- **Committen/pushen nur, wenn ich darum bitte.**
- **Erst verstehen, dann aendern:** bei Unklarheit lieber kurz nachfragen als raten.

## Was es NICHT tun soll

- Keine Dateien loeschen oder umbenennen, die du nicht selbst angelegt hast, ohne Rueckfrage.
- Nichts nach aussen schicken (Deploy, App-Store, E-Mails, Veroeffentlichungen) ohne ausdrueckliche Freigabe.
