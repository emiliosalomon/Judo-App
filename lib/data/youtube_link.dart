/// Baut eine YouTube-Suche-URL fuer eine Technik. Kein kuratierter,
/// spezifischer Video-Link (das waere fuer ~150 Techniken nicht zuverlaessig
/// pflegbar) - stattdessen eine deterministische Suche, die immer
/// funktioniert.
Uri youtubeSearchUrl(String query) {
  final cleaned = _cleanQuery(query);
  return Uri.https('www.youtube.com', '/results', {
    'search_query': '$cleaned judo',
  });
}

/// Offizieller YouTube-Kanal des Kodokan (siehe IJF-Meldung "Kodokan
/// launched official YouTube channel"). Der Kanal veroeffentlicht u.a. eine
/// Serie einzelner Technik-Kurzvideos ("100 Judo techniques") sowie volle
/// Kata-Lehrfilme.
const _kodokanChannelId = 'UCtF6tu7GuZYkZzht5MIv8UQ';

/// Kanal-interne YouTube-Suche: liefert nur Treffer vom Kodokan-Kanal selbst
/// (kein kuratierter Einzel-Link pro Technik, da der Kanal keine stabilen
/// Permalinks pro Technik veroeffentlicht - stattdessen eine Suche, die
/// zuverlaessig innerhalb des offiziellen Kanals bleibt).
Uri kodokanChannelSearchUrl(String query) {
  final cleaned = _cleanQuery(query);
  return Uri.https('www.youtube.com', '/channel/$_kodokanChannelId/search', {
    'query': cleaned,
  });
}

String _cleanQuery(String query) => query
    // Anfuehrungszeichen aus Programmnamen wie 'Prinzip „Kesa" RL' stoeren
    // die Suche, ebenso das alleinstehende Kuerzel "RL" (Randori-Lernstufe).
    .replaceAll(RegExp('[„“”"]'), '')
    .replaceAll(RegExp(r'\bRL\b'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();
