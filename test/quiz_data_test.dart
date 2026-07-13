import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/quiz_data.dart';

void main() {
  test('generateQuestion liefert genau 3 unterschiedliche Optionen, '
      'darunter die richtige Antwort', () {
    final random = Random(1);
    for (final technique in quizTechniquePool) {
      final question = generateQuestion(technique, random);
      expect(question.options.length, 3);
      expect(question.options.toSet().length, 3);
      expect(question.options, contains(question.correctAnswer));
    }
  });

  test('generateQuestion mischt die Reihenfolge ueber mehrere Aufrufe', () {
    final random = Random(2);
    const technique = 'O-soto-gari';
    final positions = <int>{};
    for (var i = 0; i < 20; i++) {
      final question = generateQuestion(technique, random);
      positions.add(question.options.indexOf(question.correctAnswer));
    }
    // Bei 20 Versuchen sollte die richtige Antwort nicht immer an
    // derselben Position stehen (sonst waere es kein echtes Mischen).
    expect(positions.length, greaterThan(1));
  });

  test('pickQuizTechniques liefert die angeforderte Anzahl unterschiedlicher '
      'Techniken', () {
    final random = Random(3);
    final picked = pickQuizTechniques(10, random);
    expect(picked.length, 10);
    expect(picked.toSet().length, 10);
    for (final technique in picked) {
      expect(quizTechniquePool, contains(technique));
    }
  });
}
