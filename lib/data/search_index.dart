import '../models/search_entry.dart';
import 'dan_grades_data.dart';
import 'kyu_grades_data.dart';
import 'techniques_data.dart';

/// App-weiter Suchindex: baut aus allen bereits vorhandenen Datenquellen
/// (Kyu-/Dan-Programm, Technik-Katalog, Kata) eine durchsuchbare, flache
/// Liste auf. Wird einmalig beim App-Start berechnet.
final List<SearchEntry> judoSearchIndex = _buildSearchIndex();

List<SearchEntry> _buildSearchIndex() {
  final entries = <SearchEntry>[];

  for (final grade in judoKyuGrades) {
    entries.add(
      SearchEntry(
        title: grade.title,
        contextLabel: 'Gürtelprüfung',
        categoryId: 'belt-exam',
        targetType: SearchTargetType.kyuGrade,
        gradeNumber: grade.kyu,
      ),
    );
    for (final technique in [
      ...grade.ukemiWaza,
      ...grade.nageWaza,
      ...grade.katameWaza,
      ...grade.anwendungsaufgaben,
      ...grade.zusatzbegriffe,
    ]) {
      entries.add(
        SearchEntry(
          title: technique,
          contextLabel: grade.title,
          categoryId: 'belt-exam',
          targetType: SearchTargetType.kyuGrade,
          gradeNumber: grade.kyu,
        ),
      );
    }
  }

  for (final grade in judoDanGrades) {
    entries.add(
      SearchEntry(
        title: grade.title,
        contextLabel: grade.kata ?? 'Dan-Prüfung',
        categoryId: 'belt-exam',
        targetType: SearchTargetType.danGrade,
        gradeNumber: grade.dan,
      ),
    );
    for (final technique in grade.zusatztechniken) {
      entries.add(
        SearchEntry(
          title: technique,
          contextLabel: '${grade.title} – Zusatztechnik',
          categoryId: 'belt-exam',
          targetType: SearchTargetType.danGrade,
          gradeNumber: grade.dan,
        ),
      );
    }
    if (grade.kata != null) {
      entries.add(
        SearchEntry(
          title: grade.kata!,
          contextLabel: 'Kata – Pflicht für ${grade.title}',
          categoryId: 'kata',
          targetType: SearchTargetType.kata,
        ),
      );
    }
  }

  for (final technique in [
    ...kodokanGokyoNageWaza,
    ...osaeKomiWaza,
    ...shimeWaza,
    ...kansetsuWaza,
  ]) {
    entries.add(
      SearchEntry(
        title: technique,
        contextLabel: 'Technik-ABC',
        categoryId: 'techniques-az',
        targetType: SearchTargetType.techniqueCatalog,
      ),
    );
  }

  return entries;
}
