import '../models/qa_entry.dart';

/// Woerter, die fuer den Abgleich ignoriert werden, weil sie in praktisch
/// jeder Frage vorkommen und nichts zur Unterscheidung beitragen.
const _stopwords = {
  'was',
  'ist',
  'sind',
  'wie',
  'der',
  'die',
  'das',
  'wird',
  'werden',
  'man',
  'bei',
  'fur',
  'im',
  'in',
  'zu',
  'zum',
  'zur',
  'und',
  'oder',
  'ein',
  'eine',
  'einen',
  'einem',
  'einer',
  'des',
  'dem',
  'den',
  'auf',
  'mit',
  'nach',
  'vor',
  'uber',
  'unter',
  'als',
  'so',
  'gibt',
  'es',
  'sich',
  'wenn',
  'wann',
  'wer',
  'welche',
  'welcher',
  'welches',
  'muss',
  'mussen',
  'kann',
  'konnen',
  'soll',
  'sollen',
  'darf',
  'durfen',
  'heisst',
  'heissen',
  'bedeutet',
  'bedeuten',
  'erklar',
  'erklare',
  'erklaren',
  'sag',
  'sage',
  'zeig',
  'zeige',
  'mir',
  'mich',
  'dir',
  'ich',
  'du',
  'frage',
  'bitte',
  'von',
  'am',
  'aus',
  'noch',
  'auch',
  'nur',
  'sehr',
  'ganz',
  'gut',
  'genau',
};

// Faltet echte Umlaute UND die haendisch getippte ASCII-Ersatzschreibweise
// (z.B. "ue" statt "ü", wie ohne deutsche Tastatur ueblich) auf dieselbe
// Form, damit z.B. "Gürtel" und "guertel" als Suchanfrage zusammenfinden.
String _foldUmlauts(String input) => input
    .toLowerCase()
    .replaceAll('ü', 'u')
    .replaceAll('ö', 'o')
    .replaceAll('ä', 'a')
    .replaceAll('ß', 'ss')
    .replaceAll('ue', 'u')
    .replaceAll('oe', 'o')
    .replaceAll('ae', 'a');

List<String> _tokenize(String input) {
  return _foldUmlauts(input)
      .split(RegExp(r'[^a-z0-9]+'))
      .where((token) => token.length > 2 && !_stopwords.contains(token))
      .toList();
}

bool _tokensOverlap(String a, String b) => a.contains(b) || b.contains(a);

/// Ein Suchtreffer mit Relevanz-Punktzahl (hoeher = passender).
class QaMatch {
  final QaEntry entry;
  final int score;

  const QaMatch(this.entry, this.score);
}

/// Durchsucht [index] nach Eintraegen, die zur Freitext-Frage [query]
/// passen. Kein echtes KI-Modell, sondern ein einfacher, dafuer
/// vollstaendig lokaler und kostenloser Abgleich: [query] wird in Woerter
/// zerlegt (Stoppwoerter wie "was"/"wie"/"der" entfernt) und gegen Frage,
/// Antwort und Quelle jedes Eintrags abgeglichen — Teilstring-Treffer
/// zaehlen auch (z.B. "gürtel" trifft "Gürtellänge").
List<QaMatch> searchQa(String query, List<QaEntry> index, {int limit = 5}) {
  final queryTokens = _tokenize(query);
  if (queryTokens.isEmpty) return const [];

  final matches = <QaMatch>[];
  for (final entry in index) {
    final questionTokens = _tokenize(entry.question);
    final answerTokens = _tokenize(entry.answer);
    final sourceTokens = _tokenize(entry.source);

    var score = 0;
    for (final queryToken in queryTokens) {
      if (questionTokens.any((t) => _tokensOverlap(t, queryToken))) {
        score += 3;
      }
      if (answerTokens.any((t) => _tokensOverlap(t, queryToken))) {
        score += 1;
      }
      if (sourceTokens.any((t) => _tokensOverlap(t, queryToken))) {
        score += 1;
      }
    }
    if (score > 0) matches.add(QaMatch(entry, score));
  }

  matches.sort((a, b) => b.score.compareTo(a.score));
  return matches.take(limit).toList();
}
