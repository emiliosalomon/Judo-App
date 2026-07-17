/// Ein Abschnitt innerhalb eines Regelwerk-Themas: Titel + Erklaerungstext
/// in eigener Formulierung (siehe CLAUDE.md, kein Original-IJF-/OeJV-Text)
/// und optionale Stichpunkte.
///
/// [text] ist null, wenn der genaue aktuelle Stand (z.B. Gewichtsklassen-
/// Grenzen, die sich jaehrlich aendern koennen) nicht aus einer
/// verlaesslichen, frei zugaenglichen Quelle bestaetigt werden konnte -
/// dann zeigt die App stattdessen einen Hinweis mit Verweis auf die
/// offizielle OeJV-Quelle, statt Zahlen zu raten.
class RulesSection {
  final String title;
  final String? text;
  final List<String> bullets;

  const RulesSection({required this.title, this.text, this.bullets = const []});
}

/// Ein Themenbereich im Regelwerk (z.B. "Wettkampfregeln").
class RulesTopic {
  final String id;
  final String title;
  final List<RulesSection> sections;

  const RulesTopic({
    required this.id,
    required this.title,
    this.sections = const [],
  });
}
