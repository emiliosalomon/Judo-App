import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/youtube_link.dart';

void main() {
  test('entfernt Anfuehrungszeichen und das alleinstehende Kuerzel RL', () {
    final uri = youtubeSearchUrl('Prinzip „Kesa" RL');
    expect(uri.queryParameters['search_query'], 'Prinzip Kesa judo');
  });

  test('laesst normale Technik-Namen unveraendert', () {
    final uri = youtubeSearchUrl('O-soto-gari');
    expect(uri.queryParameters['search_query'], 'O-soto-gari judo');
  });

  test('entfernt RL nur als eigenes Wort, nicht als Teil eines Namens', () {
    final uri = youtubeSearchUrl('Real-Technik RL');
    expect(uri.queryParameters['search_query'], 'Real-Technik judo');
  });

  test('Kodokan-Kanalsuche zeigt auf den Kodokan-Kanal und uebergibt die '
      'bereinigte Suchanfrage', () {
    final uri = kodokanChannelSearchUrl('Uchi-mata Nage-no-Kata');
    expect(uri.host, 'www.youtube.com');
    expect(uri.path, '/channel/UCtF6tu7GuZYkZzht5MIv8UQ/search');
    expect(uri.queryParameters['query'], 'Uchi-mata Nage-no-Kata');
  });
}
