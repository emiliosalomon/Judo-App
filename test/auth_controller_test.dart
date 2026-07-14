import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/services/auth_controller.dart';
import 'package:judo_app/services/auth_service.dart';
import 'package:judo_app/services/guest_choice_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'ist disabled, solange kein Firebase-Projekt konfiguriert ist - App '
    'verhaelt sich wie vor dem Anmeldesystem, kein Auswahlbildschirm',
    () async {
      final guestChoiceStore = await GuestChoiceStore.load();
      final controller = AuthController(AuthService(), guestChoiceStore);

      expect(controller.status, AuthStatus.disabled);
      controller.dispose();
    },
  );

  test('Gast-Wahl wird lokal gemerkt', () async {
    final guestChoiceStore = await GuestChoiceStore.load();
    expect(guestChoiceStore.isGuest, isFalse);

    await guestChoiceStore.setGuest(true);
    expect(guestChoiceStore.isGuest, isTrue);

    final reloaded = await GuestChoiceStore.load();
    expect(reloaded.isGuest, isTrue);
  });
}
