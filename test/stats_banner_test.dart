import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:judo_app/data/dan_grades_data.dart';
import 'package:judo_app/data/kyu_grades_data.dart';
import 'package:judo_app/services/progress_controller.dart';
import 'package:judo_app/services/progress_store.dart';
import 'package:judo_app/widgets/stats_banner.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('countTrophies ist 0, solange kein Guertel komplett ist', () async {
    final store = await ProgressStore.load();
    final progress = ProgressController(store);
    final grade = judoKyuGrades.firstWhere((g) => g.kyu == 10);
    progress.toggle('kyu:${grade.kyu}:${grade.ukemiWaza.first}');

    expect(countTrophies(progress), 0);
  });

  test('countTrophies zaehlt eine vollstaendig abgehakte Kyu-Stufe', () async {
    final store = await ProgressStore.load();
    final progress = ProgressController(store);
    final grade = judoKyuGrades.firstWhere((g) => g.kyu == 10);
    for (final item in [
      ...grade.ukemiWaza,
      ...grade.nageWaza,
      ...grade.katameWaza,
      ...grade.anwendungsaufgaben,
    ]) {
      progress.toggle('kyu:${grade.kyu}:$item');
    }

    expect(countTrophies(progress), 1);
    expect(
      kyuTrackableCount(grade),
      grade.ukemiWaza.length +
          grade.nageWaza.length +
          grade.katameWaza.length +
          grade.anwendungsaufgaben.length,
    );
  });

  test(
    'countTrophies zaehlt einen vollstaendig abgehakten Dan-Zusatztechniken-Satz',
    () async {
      final store = await ProgressStore.load();
      final progress = ProgressController(store);
      final grade = judoDanGrades.firstWhere((g) => g.dan == 1);
      for (final technik in grade.zusatztechniken) {
        progress.toggle('dan:${grade.dan}:$technik');
      }

      expect(countTrophies(progress), 1);
    },
  );

  test('Dan-Stufen ohne Zusatztechniken zaehlen nie als Pokal', () async {
    final store = await ProgressStore.load();
    final progress = ProgressController(store);
    final grade = judoDanGrades.firstWhere((g) => g.zusatztechniken.isEmpty);

    expect(grade.zusatztechniken, isEmpty);
    expect(countTrophies(progress), 0);
  });
}
