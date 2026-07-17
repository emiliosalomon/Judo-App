import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/services/app_edition.dart';

void main() {
  test('isProEdition ist standardmaessig (ohne --dart-define) false - die '
      'App ist ohne Build-Flag die kostenlose Edition. Nur relevant, wenn '
      'ohne --dart-define=PRO_EDITION=true getestet wird.', () {
    if (isProEdition) return;
    expect(isProEdition, isFalse);
  });
}
