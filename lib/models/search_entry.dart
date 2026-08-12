enum SearchTargetType { kyuGrade, danGrade, techniqueCatalog, kata }

/// Ein durchsuchbarer Eintrag im App-weiten Suchindex.
class SearchEntry {
  final String title;
  final String contextLabel;
  final String categoryId;
  final SearchTargetType targetType;

  /// Kyu- bzw. Dan-Nummer, wenn [targetType] darauf verweist.
  final int? gradeNumber;

  const SearchEntry({
    required this.title,
    required this.contextLabel,
    required this.categoryId,
    required this.targetType,
    this.gradeNumber,
  });
}
