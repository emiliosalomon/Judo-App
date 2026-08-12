import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/dan_grades_data.dart';
import 'package:judo_app/data/kyu_grades_data.dart';

void main() {
  test('Kyu-Programm deckt 11. bis 1. Kyu vollstaendig und absteigend ab', () {
    expect(judoKyuGrades.length, 11);
    expect(judoKyuGrades.first.kyu, 11);
    expect(judoKyuGrades.last.kyu, 1);
    for (var i = 0; i < judoKyuGrades.length - 1; i++) {
      expect(judoKyuGrades[i].kyu, judoKyuGrades[i + 1].kyu + 1);
    }
  });

  test('Jede Kyu-Stufe außer der Einstiegsstufe hat Anwendungsaufgaben', () {
    for (final grade in judoKyuGrades.where((g) => g.kyu != 11)) {
      expect(
        grade.anwendungsaufgaben,
        isNotEmpty,
        reason: '${grade.title} sollte Anwendungsaufgaben haben',
      );
    }
  });

  test('Dan-Programm deckt 1. bis 10. Dan ab, Kata nur bis 6. Dan', () {
    expect(judoDanGrades.length, 10);
    expect(judoDanGrades.first.dan, 1);
    expect(judoDanGrades.last.dan, 10);

    final withKata = judoDanGrades.where((g) => g.kata != null);
    expect(withKata.length, 6);
    for (final grade in withKata) {
      expect(grade.dan, lessThanOrEqualTo(6));
    }
  });
}
