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

## Tech-Stack & Werkzeuge

- Sprache / Framework: Flutter (Dart) — eine Codebasis fuer Android und iOS
- Paketmanager: pub (pubspec.yaml)
- Starten (Dev): `flutter run`
- Tests: `flutter test`
- Build: `flutter build apk` (Android) / `flutter build ios` (iOS)

## So ist der Code aufgebaut

<!-- Wird ausgefuellt, sobald das Flutter-Grundgeruest steht. -->

## Konventionen (bitte einhalten)

- Schreib Code im Stil der umliegenden Dateien (gleiche Benennung, gleiche Struktur).
- Keine neuen Abhaengigkeiten ohne kurze Rueckfrage.
- Texte, die der Nutzer sieht, zentral halten (Lokalisierung vorbereiten), nichts hart im Code verstreuen.
- Neue Funktionen bekommen, wo sinnvoll, einen Test.

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
