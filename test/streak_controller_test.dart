import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:judo_app/services/streak_controller.dart';
import 'package:judo_app/services/streak_store.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('erster Besuch startet die Serie bei 1', () async {
    final store = await StreakStore.load();
    final controller = StreakController(
      store,
      now: () => DateTime(2026, 1, 10),
    );

    await controller.recordVisitToday();

    expect(controller.current, 1);
    expect(controller.longest, 1);
  });

  test('Besuch am Folgetag erhoeht die Serie', () async {
    final store = await StreakStore.load();
    final day1 = StreakController(store, now: () => DateTime(2026, 1, 10));
    await day1.recordVisitToday();

    final day2 = StreakController(store, now: () => DateTime(2026, 1, 11));
    await day2.recordVisitToday();

    expect(day2.current, 2);
    expect(day2.longest, 2);
  });

  test('mehrfacher Besuch am selben Tag zaehlt nicht doppelt', () async {
    final store = await StreakStore.load();
    final controller = StreakController(
      store,
      now: () => DateTime(2026, 1, 10),
    );

    await controller.recordVisitToday();
    await controller.recordVisitToday();

    expect(controller.current, 1);
  });

  test('eine Luecke von mehr als einem Tag setzt die Serie zurueck', () async {
    final store = await StreakStore.load();
    final day1 = StreakController(store, now: () => DateTime(2026, 1, 10));
    await day1.recordVisitToday();

    final day5 = StreakController(store, now: () => DateTime(2026, 1, 15));
    await day5.recordVisitToday();

    expect(day5.current, 1);
    expect(day5.longest, 1);
  });

  test('die laengste Serie bleibt auch nach einem Reset erhalten', () async {
    final store = await StreakStore.load();
    final day1 = StreakController(store, now: () => DateTime(2026, 1, 10));
    await day1.recordVisitToday();
    final day2 = StreakController(store, now: () => DateTime(2026, 1, 11));
    await day2.recordVisitToday();
    final day3 = StreakController(store, now: () => DateTime(2026, 1, 12));
    await day3.recordVisitToday();

    final afterGap = StreakController(store, now: () => DateTime(2026, 1, 20));
    await afterGap.recordVisitToday();

    expect(afterGap.current, 1);
    expect(afterGap.longest, 3);
  });
}
