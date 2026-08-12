import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/models/fight_entry.dart';
import 'package:judo_app/services/fight_log_controller.dart';
import 'package:judo_app/services/fight_log_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  FightEntry sample({
    required String id,
    required DateTime date,
    String tournamentName = 'Landesmeisterschaft',
    String location = 'Wien',
  }) => FightEntry(
    id: id,
    date: date,
    tournamentName: tournamentName,
    location: location,
    placement: '1. Platz',
    opponentsCount: 3,
  );

  test('addFight fuegt hinzu und notifiziert Listener', () async {
    final store = await FightLogStore.load();
    final controller = FightLogController(store);
    var notifications = 0;
    controller.addListener(() => notifications++);

    expect(controller.fights, isEmpty);

    controller.addFight(sample(id: '1', date: DateTime(2026, 3, 1)));

    expect(controller.fights, hasLength(1));
    expect(controller.fights.first.tournamentName, 'Landesmeisterschaft');
    expect(notifications, 1);
  });

  test('fights sind nach Datum absteigend sortiert (neueste zuerst)', () async {
    final store = await FightLogStore.load();
    final controller = FightLogController(store);

    controller.addFight(sample(id: '1', date: DateTime(2026, 1, 1)));
    controller.addFight(sample(id: '2', date: DateTime(2026, 6, 1)));
    controller.addFight(sample(id: '3', date: DateTime(2026, 3, 1)));

    expect(controller.fights.map((f) => f.id), ['2', '3', '1']);
  });

  test('removeFight entfernt genau den passenden Eintrag', () async {
    final store = await FightLogStore.load();
    final controller = FightLogController(store);
    controller.addFight(sample(id: '1', date: DateTime(2026, 1, 1)));
    controller.addFight(sample(id: '2', date: DateTime(2026, 2, 1)));

    controller.removeFight('1');

    expect(controller.fights, hasLength(1));
    expect(controller.fights.first.id, '2');
  });

  test('Tagebuch bleibt ueber einen Neustart (neue FightLogStore-Instanz) '
      'erhalten, inkl. optionaler Felder', () async {
    final store1 = await FightLogStore.load();
    final controller1 = FightLogController(store1);
    controller1.addFight(
      FightEntry(
        id: '1',
        date: DateTime(2026, 5, 4),
        tournamentName: 'OeJV Cup',
        location: 'Graz',
        placement: '3. Platz',
        opponentsCount: 4,
        notes: 'Guter Tag, Uchi-mata hat gesessen.',
        photoBase64: 'Zm9vYmFy',
      ),
    );

    final store2 = await FightLogStore.load();
    final controller2 = FightLogController(store2);

    expect(controller2.fights, hasLength(1));
    final restored = controller2.fights.first;
    expect(restored.tournamentName, 'OeJV Cup');
    expect(restored.location, 'Graz');
    expect(restored.placement, '3. Platz');
    expect(restored.opponentsCount, 4);
    expect(restored.notes, 'Guter Tag, Uchi-mata hat gesessen.');
    expect(restored.photoBase64, 'Zm9vYmFy');
    expect(restored.date, DateTime(2026, 5, 4));
  });
}
