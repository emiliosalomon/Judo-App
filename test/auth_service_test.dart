import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/services/auth_service.dart';

void main() {
  test('ist nicht verfuegbar und verhaelt sich als No-Op, solange kein '
      'Firebase-Projekt initialisiert ist', () async {
    final service = AuthService();

    expect(service.isAvailable, isFalse);
    expect(service.currentUserId, isNull);
    expect(service.currentUserEmail, isNull);
    expect(await service.authStateChanges.first, isNull);

    // Darf nicht werfen, auch ohne initialisiertes Firebase - liefert
    // stattdessen eine nutzerlesbare Fehlermeldung.
    expect(await service.signIn('a@b.de', 'geheim1'), isNotNull);
    expect(await service.register('a@b.de', 'geheim1'), isNotNull);
    await service.signOut();
  });
}
