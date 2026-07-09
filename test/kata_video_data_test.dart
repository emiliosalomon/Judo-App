import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/kata_video_data.dart';
import 'package:judo_app/models/kata_info.dart';

void main() {
  test('jede Kata aus judoKataInfos hat ein kuratiertes Video vom '
      'Kodokan-Kanal', () {
    for (final name in judoKataInfos.keys) {
      expect(
        kataFullVideos.containsKey(name),
        isTrue,
        reason: '$name hat keinen Eintrag in kataFullVideos',
      );
    }
  });

  test('jeder Video-Link ist eine gueltige YouTube-URL', () {
    for (final url in kataFullVideos.values) {
      final uri = Uri.parse(url);
      expect(uri.host, 'www.youtube.com');
      expect(uri.queryParameters['v'], isNotEmpty);
    }
  });
}
