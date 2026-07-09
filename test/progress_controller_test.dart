import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/services/progress_controller.dart';
import 'package:judo_app/services/progress_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('toggle markiert und entmarkiert eine ID, notifiziert Listener', () async {
    final store = await ProgressStore.load();
    final controller = ProgressController(store);
    var notifications = 0;
    controller.addListener(() => notifications++);

    expect(controller.isCompleted('kyu:5:O-soto-gari'), isFalse);

    controller.toggle('kyu:5:O-soto-gari');
    expect(controller.isCompleted('kyu:5:O-soto-gari'), isTrue);
    expect(notifications, 1);

    controller.toggle('kyu:5:O-soto-gari');
    expect(controller.isCompleted('kyu:5:O-soto-gari'), isFalse);
    expect(notifications, 2);
  });

  test('Fortschritt bleibt ueber einen Neustart (neue ProgressStore-Instanz) erhalten', () async {
    final store1 = await ProgressStore.load();
    final controller1 = ProgressController(store1);
    controller1.toggle('kyu:5:O-soto-gari');
    controller1.toggle('kyu:5:Harai-goshi');

    // Simuliert App-Neustart: neue Store-Instanz liest denselben
    // SharedPreferences-Zustand.
    final store2 = await ProgressStore.load();
    final controller2 = ProgressController(store2);

    expect(controller2.isCompleted('kyu:5:O-soto-gari'), isTrue);
    expect(controller2.isCompleted('kyu:5:Harai-goshi'), isTrue);
    expect(controller2.countCompletedWithPrefix('kyu:5:'), 2);
  });

  test('countCompletedWithPrefix zaehlt nur passende IDs', () async {
    final store = await ProgressStore.load();
    final controller = ProgressController(store);
    controller.toggle('kyu:5:O-soto-gari');
    controller.toggle('kyu:10:Uki-goshi');
    controller.toggle('gokyo:Seoi-nage');

    expect(controller.countCompletedWithPrefix('kyu:5:'), 1);
    expect(controller.countCompletedWithPrefix('kyu:10:'), 1);
    expect(controller.countCompletedWithPrefix('gokyo:'), 1);
  });
}
