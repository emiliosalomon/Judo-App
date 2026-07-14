import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/services/cloud_sync.dart';

void main() {
  test('ist nicht verfuegbar und verhaelt sich als No-Op, solange kein '
      'Firebase-Projekt initialisiert ist', () async {
    expect(CloudSync.isAvailable, isFalse);
    expect(await CloudSync.pull('irgendeine-uid'), isNull);
    // Darf nicht werfen.
    CloudSync.push('irgendeine-uid', {'completed_items': <String>[]});
  });
}
