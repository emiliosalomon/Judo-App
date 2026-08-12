import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/models/fight_entry.dart';
import 'package:judo_app/services/fight_log_store.dart';
import 'package:judo_app/services/progress_store.dart';
import 'package:judo_app/services/streak_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gast-Modus: Daten duerfen innerhalb einer Instanz sichtbar bleiben
/// (damit die App waehrend der Sitzung normal funktioniert), aber nicht
/// nach SharedPreferences durchsickern - eine neue Instanz (z.B. nach
/// Neustart) darf nichts davon sehen.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('ProgressStore.ephemeral() persistiert nichts', () async {
    final store = ProgressStore.ephemeral();
    expect(store.read(), isEmpty);
    await store.write({'kyu-10-ukemi'});
    expect(store.read(), {'kyu-10-ukemi'});

    expect(ProgressStore.ephemeral().read(), isEmpty);
    expect((await ProgressStore.load()).read(), isEmpty);
  });

  test('StreakStore.ephemeral() persistiert nichts', () async {
    final store = StreakStore.ephemeral();
    expect(store.readCurrent(), 0);
    await store.write(current: 3, longest: 5, lastActive: '2026-07-14');
    expect(store.readCurrent(), 3);
    expect(store.readLongest(), 5);

    expect(StreakStore.ephemeral().readCurrent(), 0);
    expect((await StreakStore.load()).readCurrent(), 0);
  });

  test('FightLogStore.ephemeral() persistiert nichts', () async {
    final store = FightLogStore.ephemeral();
    expect(store.read(), isEmpty);
    final entry = FightEntry(
      id: '1',
      date: DateTime(2026, 7, 14),
      tournamentName: 'Test-Turnier',
      location: 'Wien',
      placement: '1. Platz',
      opponentsCount: 3,
    );
    await store.write([entry]);
    expect(store.read(), hasLength(1));

    expect(FightLogStore.ephemeral().read(), isEmpty);
    expect((await FightLogStore.load()).read(), isEmpty);
  });
}
