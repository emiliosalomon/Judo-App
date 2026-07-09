/// Baut eine YouTube-Suche-URL fuer eine Technik. Kein kuratierter,
/// spezifischer Video-Link (das waere fuer ~150 Techniken nicht zuverlaessig
/// pflegbar) - stattdessen eine deterministische Suche, die immer
/// funktioniert.
Uri youtubeSearchUrl(String query) {
  return Uri.https('www.youtube.com', '/results', {
    'search_query': '$query judo',
  });
}
