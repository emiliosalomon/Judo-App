/// Free/Pro-Unterscheidung der App. Aktuell ein reiner Kompilierzeit-
/// Schalter ohne echten Bezahlvorgang - gesetzt per Build-Flag:
///
///   flutter build apk --dart-define=PRO_EDITION=true
///
/// (ohne das Flag: Free-Edition). Pro schaltet frei:
/// - Technik-Standbilder im Video-Auswahlmenue (siehe video_choice_sheet.dart)
///   - die Free-Edition bleibt bewusst bildfrei, bis die Bildrechte mit dem
///   Kodokan geklaert sind (siehe CLAUDE.md).
/// - Anmeldesystem/Cloud-Sync (siehe auth_controller.dart) - die
///   Free-Edition bleibt rein lokal, wie eine App ohne Login.
/// - Meine Kaempfe (siehe home_screen.dart).
const bool isProEdition = bool.fromEnvironment(
  'PRO_EDITION',
  defaultValue: false,
);
