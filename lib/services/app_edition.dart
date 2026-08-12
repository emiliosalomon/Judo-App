/// Free/Pro-Unterscheidung der App. Aktuell ein reiner Kompilierzeit-
/// Schalter ohne echten Bezahlvorgang - gesetzt per Build-Flag:
///
///   flutter build apk --dart-define=PRO_EDITION=true
///
/// (ohne das Flag: Free-Edition). Pro schaltet frei:
/// - Anmeldesystem/Cloud-Sync (siehe auth_controller.dart) - die
///   Free-Edition bleibt rein lokal, wie eine App ohne Login.
/// - Meine Kaempfe (siehe home_screen.dart).
///
/// Die Technik-Standbilder im Video-Auswahlmenue (video_choice_sheet.dart)
/// sind bewusst NICHT an dieses Flag gekoppelt - die stehen vorerst allen
/// zum Lernen zur Verfuegung, bis die Bildrechte mit dem Kodokan geklaert
/// sind und eine echte Free/Pro-Unterscheidung dafuer ansteht (siehe
/// CLAUDE.md).
const bool isProEdition = bool.fromEnvironment(
  'PRO_EDITION',
  defaultValue: false,
);
