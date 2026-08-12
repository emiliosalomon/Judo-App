import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/services/firestore_leaderboard_repository.dart';

void main() {
  test('ist nicht verfuegbar und verhaelt sich als No-Op, solange kein '
      'Firebase-Projekt initialisiert ist', () async {
    final repo = FirestoreLeaderboardRepository();

    expect(repo.isAvailable, isFalse);
    expect(repo.currentUserId, isNull);

    // Darf nicht werfen, auch ohne initialisiertes Firebase.
    await repo.submitScore(nickname: 'Test', stars: 5);

    final entries = await repo.watchTopEntries().first;
    expect(entries, isEmpty);
  });
}
