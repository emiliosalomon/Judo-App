import '../models/leaderboard_entry.dart';

/// Zugriff auf die geraete-uebergreifende Sterne-Rangliste. Implementierung
/// dahinter kann Firestore sein (Produktion) oder ein In-Memory-Fake (Tests,
/// bzw. Fallback wenn kein Backend erreichbar ist).
abstract class LeaderboardRepository {
  /// Ob das Backend grundsaetzlich erreichbar/konfiguriert ist. Wenn false,
  /// zeigt die UI einen Hinweis statt der Rangliste.
  bool get isAvailable;

  /// Stabile ID des aktuellen Nutzers (z.B. anonyme Firebase-UID), oder
  /// null, solange noch keine Anmeldung stattgefunden hat.
  String? get currentUserId;

  /// Traegt den aktuellen Sternestand unter [nickname] ein/aktualisiert ihn.
  Future<void> submitScore({required String nickname, required int stars});

  /// Live-Stream der Top-Eintraege, absteigend nach Sternen sortiert.
  Stream<List<LeaderboardEntry>> watchTopEntries({int limit = 50});
}
