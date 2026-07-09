import 'package:flutter/material.dart';
import '../data/dan_grades_data.dart';
import '../models/dan_grade.dart';
import '../theme/judo_theme.dart';

class DanGradeDetailScreen extends StatelessWidget {
  final DanGrade grade;

  const DanGradeDetailScreen({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(grade.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Gürtel: ${grade.beltDescription}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (grade.kata != null) ...[
            const SizedBox(height: 12),
            Text(
              'Pflicht-Kata',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: JudoColors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(grade.kata!),
          ],
          if (grade.hinweis != null) ...[
            const SizedBox(height: 16),
            Text(grade.hinweis!),
          ],
          if (grade.zusatztechniken.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Zusatztechniken',
              style: TextStyle(fontWeight: FontWeight.bold, color: JudoColors.red),
            ),
            const SizedBox(height: 8),
            for (final technik in grade.zusatztechniken)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('•  $technik'),
              ),
          ],
          const SizedBox(height: 20),
          const Text(
            'Theorie-Themenbereiche',
            style: TextStyle(fontWeight: FontWeight.bold, color: JudoColors.red),
          ),
          const SizedBox(height: 8),
          for (final thema in danTheorieThemenbereiche)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('•  $thema'),
            ),
        ],
      ),
    );
  }
}
