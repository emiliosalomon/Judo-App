import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/leaderboard_entry.dart';
import 'leaderboard_repository.dart';

/// Firestore-gestuetzte Rangliste. Nutzt anonyme Firebase-Anmeldung (keine
/// Email/Passwort noetig) - die UID ist der Dokument-Schluessel, der
/// selbstgewaehlte Nickname nur ein Anzeigefeld.
///
/// Greift nie auf Firebase.instance* zu, ohne vorher [isAvailable] zu
/// pruefen: solange kein echtes Firebase-Projekt konfiguriert ist (siehe
/// main.dart), bleibt die App voll nutzbar, nur die Rangliste zeigt einen
/// Hinweis statt Daten.
class FirestoreLeaderboardRepository implements LeaderboardRepository {
  static const _collection = 'leaderboard';

  @override
  bool get isAvailable => Firebase.apps.isNotEmpty;

  @override
  String? get currentUserId =>
      isAvailable ? FirebaseAuth.instance.currentUser?.uid : null;

  Future<User?> _ensureSignedIn() async {
    if (!isAvailable) return null;
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) return auth.currentUser;
    try {
      final credential = await auth.signInAnonymously();
      return credential.user;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> submitScore({
    required String nickname,
    required int stars,
  }) async {
    if (!isAvailable) return;
    final user = await _ensureSignedIn();
    if (user == null) return;
    await FirebaseFirestore.instance.collection(_collection).doc(user.uid).set({
      'nickname': nickname,
      'stars': stars,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Stream<List<LeaderboardEntry>> watchTopEntries({int limit = 50}) {
    if (!isAvailable) return Stream.value(const []);
    return FirebaseFirestore.instance
        .collection(_collection)
        .orderBy('stars', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => [
            for (final doc in snapshot.docs)
              LeaderboardEntry(
                userId: doc.id,
                nickname: (doc.data()['nickname'] as String?) ?? '?',
                stars: (doc.data()['stars'] as num?)?.toInt() ?? 0,
              ),
          ],
        );
  }
}
