/// Gemeinsame Suchlogik fuer technique_media_data.dart und
/// technique_video_data.dart: findet zu einem Programmnamen (der oft
/// Suffixe wie " RL" oder "oder ..." hat) den passenden kuratierten
/// Eintrag per Teilstring-Abgleich.
///
/// Reiner `contains()`-Abgleich waere zu naiv: 'O-guruma' ist ein
/// Teilstring von 'Yoko-guruma' (...yok|o-guruma), obwohl es eine ganz
/// andere Technik ist. Deshalb zaehlt ein Treffer nur, wenn er an einer
/// Wortgrenze beginnt/endet (nicht direkt an einen weiteren Buchstaben
/// angrenzt), und bei mehreren gueltigen Treffern gewinnt der laengste
/// (spezifischste) Schluessel.
T? findBestTechniqueMatch<T>(String query, Map<String, T> table) {
  final normalized = query.toLowerCase();
  String? bestKey;
  T? bestValue;
  for (final entry in table.entries) {
    final key = entry.key.toLowerCase();
    if (!_matchesAsWord(normalized, key)) continue;
    if (bestKey == null || key.length > bestKey.length) {
      bestKey = key;
      bestValue = entry.value;
    }
  }
  return bestValue;
}

final _letter = RegExp(r'[a-zà-ÿ]');

bool _matchesAsWord(String haystack, String needle) {
  if (needle.isEmpty) return false;
  final pattern = RegExp(
    '(?<!${_letter.pattern})${RegExp.escape(needle)}(?!${_letter.pattern})',
  );
  return pattern.hasMatch(haystack);
}
