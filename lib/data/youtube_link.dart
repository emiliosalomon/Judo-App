/// Baut eine YouTube-Suche-URL fuer eine Technik. Kein kuratierter,
/// spezifischer Video-Link (das waere fuer ~150 Techniken nicht zuverlaessig
/// pflegbar) - stattdessen eine deterministische Suche, die immer
/// funktioniert.
Uri youtubeSearchUrl(String query) {
  final cleaned = query
      // Anfuehrungszeichen aus Programmnamen wie 'Prinzip „Kesa" RL' stoeren
      // die Suche, ebenso das alleinstehende Kuerzel "RL" (Randori-Lernstufe).
      .replaceAll(RegExp('[„“”"]'), '')
      .replaceAll(RegExp(r'\bRL\b'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return Uri.https('www.youtube.com', '/results', {
    'search_query': '$cleaned judo',
  });
}
